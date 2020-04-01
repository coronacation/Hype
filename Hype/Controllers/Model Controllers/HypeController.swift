//
//  HypeController.swift
//  Hype
//
//  Created by Theo Vora on 3/30/20.
//  Copyright © 2020 Studio Awaken. All rights reserved.
//

import CloudKit

class HypeController {
    
    // MARK: - Source of Truth and Shared Instance
    
    static let shared = HypeController()
    var hypes: [Hype] = []
    let publicDB = CKContainer.default().publicCloudDatabase
    
    
    // MARK: - CRUD
    
    func saveHype(body: String, completion: @escaping (Result<Hype?, HypeError>) -> Void) {
        guard let currentUser = UserController.shared.currentUser else { return completion(.failure(.noUserLoggedIn)) }
        
        let reference = CKRecord.Reference(recordID: currentUser.recordID, action: .deleteSelf)
        
        let hype = Hype(body: body, userReference: reference)
        
        let record = CKRecord(hype: hype)
        
        publicDB.save(record) { (record, error) in
            if let error = error {
                return completion(.failure(.ckError(error)))
            }
            
            guard let record = record,
                let hype = Hype(ckRecord: record) else
            { return completion(.failure(.couldNotUnwrap)) }
            
            //            self.hypes.append(hype) // Alternative
            self.hypes.insert(hype, at: 0)
            return completion(.success(hype))
        }
    } // end saveHype
    
    func fetchAllHypes(completion: @escaping (Bool) -> Void) {
        
        
        let predicate = NSPredicate(value: true) // return all records
        
        let query = CKQuery(recordType: HypeStrings.recordTypeKey, predicate: predicate)
        
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            
            // error handling
            if let error = error {
                print(error, error.localizedDescription)
                return completion(false)
            }
            
            guard let records = records else { return completion(false) }
            
            let hypes: [Hype] = records.compactMap(Hype.init(ckRecord: )) // you're passing a closure
//            let hypes: [Hype] = records.compactMap { Hype(ckRecord: $0) } // alternative: in-line closure. you're writing your own instructions.
            
            self.hypes = hypes
            return completion(true)
        }
    } // end fetchAllHypes
    
    
    func update(_ hype: Hype, completion: @escaping (Result<Hype?, HypeError>) -> Void) {
        let record = CKRecord(hype: hype)
        
        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        
        operation.modifyRecordsCompletionBlock = { (records, _, error) in
            if let error = error {
                print(error.localizedDescription + " --> \(error)")
                completion(.failure(.ckError(error)))
                return
            }
            
            guard let record = records?.first,
            let updatedHype = Hype(ckRecord: record)
                else { completion(.failure(.couldNotUnwrap)); return }
            
            completion(.success(updatedHype))
        }
        
        publicDB.add(operation)
    }
    
    func delete(_ hype: Hype, completion: @escaping (Result<Bool, HypeError>) -> Void) {
        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [hype.recordID])
        
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = { (records, _, error) in
            if let error = error {
                print(error.localizedDescription + " --> \(error)")
                completion(.failure(.ckError(error)))
                return
            }
            
            if records?.count == 0{
                completion(.success(true))
            } else {
                completion(.failure(.unexpectedRecordFound))
            }
        } // end modifyRecordsCompletionBlock
        
        publicDB.add(operation)
    } // end delete
    
    func subscribeForRemoteNotifications(completion: @escaping (Error?) -> Void) {
        
        let predicate = NSPredicate(value: true)
        let subscription = CKQuerySubscription(recordType: HypeStrings.recordTypeKey, predicate: predicate, options: .firesOnRecordCreation)
        
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.title = "Hype was added"
        notificationInfo.alertBody = "Come check it out"
        notificationInfo.shouldBadge = true
        
        subscription.notificationInfo = notificationInfo
        
        publicDB.save(subscription) { (_, error) in
            if let error = error {
                print(error.localizedDescription + " --> \(error)")
                completion(error)
            }
            completion(nil)
        }
        
    } // end subscribeForRemoteNotifications
} // end HypeController
