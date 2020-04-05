//
//  HypeController.swift
//  Hype
//
//  Created by Theo Vora on 3/30/20.
//  Copyright © 2020 Studio Awaken. All rights reserved.
//

import CloudKit
import UIKit.UIImage

class HypeController {
    
    // MARK: - Source of Truth and Shared Instance
    
    static let shared = HypeController()
    var hypes: [Hype] = []
    
    let ckManager = CKController()
    
    
    // MARK: - CRUD
    
    func saveHype(body: String, photo: UIImage?, completion: @escaping (Result<Hype?, HypeError>) -> Void) {
        guard let currentUser = UserController.shared.currentUser
            else { return completion(.failure(.noUserLoggedIn)) }
        
        let reference = CKRecord.Reference(recordID: currentUser.recordID, action: .deleteSelf)
        
        let newHype = Hype(body: body, userReference: reference, photo: photo)
        
        ckManager.save(object: newHype) { (result) in
            switch result {
            case .success(let savedHype):
                self.hypes.append(savedHype)
                completion(.success(savedHype))
            case .failure(let error):
                completion(.failure(.ckError(error)))
        }
        }
    } // end saveHype
    
    func fetchAllHypes(completion: @escaping (Bool) -> Void) {
        
        
        let truePredicate = NSPredicate(value: true) // return all records
        let compoundPred = NSCompoundPredicate(andPredicateWithSubpredicates: [truePredicate])
        
        ckManager.fetch(predicate: compoundPred) { (result: Result<[Hype], CKError>) in
            switch result {
            case .success(let foundHypes):
                self.hypes = foundHypes
                completion(true)
            case .failure:
                completion(false)
            }
        }
        
    } // end fetchAllHypes
    
    
    func update(_ hype: Hype, completion: @escaping (_ success: Bool) -> Void) {
        ckManager.update(object: hype) { (result) in
            switch result {
            case .success:
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
    
    func delete(_ hype: Hype, completion: @escaping (_ success: Bool) -> Void) {
        ckManager.delete(object: hype) { (result) in
            switch result {
            case .success:
                completion(true)
            case .failure:
                completion(false)
            }
        }
    } // end delete
    
    func subscribeForRemoteNotifications(completion: @escaping (Error?) -> Void) {
        
        let predicate = NSPredicate(value: true)
        let subscription = CKQuerySubscription(recordType: HypeStrings.recordTypeKey, predicate: predicate, options: .firesOnRecordCreation)
        
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.title = "Hype was added"
        notificationInfo.alertBody = "Come check it out"
        notificationInfo.shouldBadge = true
        
        subscription.notificationInfo = notificationInfo
        
        ckManager.publicDB.save(subscription) { (_, error) in
            if let error = error {
                print(error.localizedDescription + " --> \(error)")
                completion(error)
            }
            completion(nil)
        }
        
    } // end subscribeForRemoteNotifications
} // end HypeController
