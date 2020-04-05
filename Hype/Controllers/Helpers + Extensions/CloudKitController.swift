//
//  CloudKitController.swift
//  Hype
//
//  Created by Theo Vora on 4/3/20.
//  Copyright © 2020 Theo Vora. All rights reserved.
//

import CloudKit

enum CKError: Error {
    case ckError(Error)
    case couldNotUnwrap
    
}

struct CKController {
    let publicDB = CKContainer.default().publicCloudDatabase
    
    // CRUD 
    func save<T: CKSyncable>(object: T, completion: @escaping (Result<T, CKError>) -> Void) {
        let record = object.ckRecord
        publicDB.save(record) { (record, error) in
            if let error = error {
                completion(.failure(.ckError(error)))
                return
            }
            
            guard let record = record,
                let savedObject = T(record: record)
                else {
                    completion(.failure(.couldNotUnwrap))
                    return
            }
            completion(.success(savedObject))
        }
    }
    
    func fetch<T: CKSyncable>(predicate: NSCompoundPredicate, completion: @escaping (Result<[T], CKError>) -> Void) {
        let query = CKQuery(recordType: T.recordType, predicate: predicate)
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error in \(#function) -\n\(#file):\(#line) -\n\(error.localizedDescription) \n---\n \(error)")
                completion(.failure(.ckError(error)))
            }
            guard let objects = records?.compactMap({ T(record: $0) }) else {
                    completion(.failure(.couldNotUnwrap))
                    return
            }
            completion(.success(objects))
        }
    }
    
    func update<T: CKSyncable>(object: T, completion: @escaping (Result<T, CKError>) -> Void) {
        let operation = CKModifyRecordsOperation(recordsToSave: [object.ckRecord], recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = { (records, _, error) in
            if let error = error {
                print("Error in \(#function) -\n\(#file):\(#line) -\n\(error.localizedDescription) \n---\n \(error)")
                completion(.failure(.ckError(error)))
            }
            
            guard let objects = records?.compactMap({ T(record: $0) }),
                let object = objects.first
                else {
                    completion(.failure(.couldNotUnwrap))
                    return
            }
            completion(.success(object))
        }
        publicDB.add(operation)
    }
    
    func delete<T: CKSyncable>(object: T, completion: @escaping (Result<Bool, CKError>) -> Void) {
        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [object.recordID])
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = { (_, recordIDs, error) in
            if let error = error {
                print("Error in \(#function) -\n\(#file):\(#line) -\n\(error.localizedDescription) \n---\n \(error)")
                completion(.failure(.ckError(error)))
            }
            
            guard let recordIDs = recordIDs, recordIDs.count > 0 else {
                completion(.failure(.couldNotUnwrap))
                return
            }
            completion(.success(true))
        }
        publicDB.add(operation)
    }
}
