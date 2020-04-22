//
//  UserController.swift
//  Hype
//
//  Created by Theo Vora on 4/1/20.
//  Copyright © 2020 Theo Vora. All rights reserved.
//

import Foundation
import UIKit.UIImage

class UserController {
    
    static let shared = UserController()
    
    var currentUser: User?
//    let publicDB = CKContainer.default().publicCloudDatabase
    
    
    /**
    Creates a User and saves it to CloudKit
    
    - Parameters:
     - username: Stringvalue to pass into the User init
     - completion: Excaping completion black for the method
     - result: Result found in the completion block with success returning a User and failure returning a UserError
    
    */
    
//    func createUserWith(_ username: String, profilePicture: UIImage?, completion: @escaping (Result<User, UserError>) -> Void) {
//        fetchAppleUserReference { (result) in
//            switch result {
//            case .success(let reference):
//                guard let reference = reference else { return completion(.failure(.noUserLoggedIn))}
//                
//                let newUser = User(username: username, appleUserRef: reference, profilePhoto: profilePicture)
//                
//                let record = CKRecord(user: newUser)
//                
//                self.publicDB.save(record) { (record, error) in
//                    if let error = error {
//                        completion(.failure(.ckError(error)))
//                    }
//                    
//                    guard let record = record,
//                        let savedUser = User(ckRecord: record) else { return completion(.failure(.couldNotUnwrap)) }
//                    
//                    completion(.success(savedUser))
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
    
    /**
     Fetches the recordID of the currently logged in AppleID User
     
     - Parameters:
        - completion: Escaping completion block for the method
        - reference: Optional reference for the found AppleID User
    
    */
    
//    func fetchAppleUserReference(completion: @escaping (Result<CKRecord.Reference?, UserError>) -> Void) {
//
//        CKContainer.default().fetchUserRecordID { (recordID, error) in
//            if let error = error {
//                completion(.failure(.ckError(error)))
//            }
//
//            if let recordID = recordID {
//                let reference = CKRecord.Reference(recordID: recordID, action: .deleteSelf)
//
//                completion(.success(reference))
//            }
//        }
//    }
    
    /**
     Fetches the User object that points to the currently logged in AppleID User from the publicDatabase
     
     - Parameters:
        - completion: Escaping completion block for the method
        - result: Result found in the completion block with success returning a User and failure returning UserError
     */
    
//    func fetchUser(completion: @escaping(Result<User?,UserError>) -> Void) {
//        fetchAppleUserReference { (result) in
//            switch result {
//            case .success(let reference):
//                guard let reference = reference
//                    else { return completion(.failure(.noUserLoggedIn)) }
//                
//                // %K is a key, %@ is the object we are passing it
//                
//                let appleUserPredicate = NSPredicate(format: "%K == %@", [UserConstants.appleUserRefKey], reference)
//                
//                let query = CKQuery(recordType: UserConstants.recordType, predicate: appleUserPredicate)
//                
//                self.publicDB.perform(query, inZoneWith: nil) { (records, error) in
//                    if let error = error {
//                        completion(.failure(.ckError(error)))
//                    }
//                    
//                    guard let record = records?.first,
//                    let foundUser = User(ckRecord: record)
//                        else { return completion(.failure(.couldNotUnwrap)) }
//                    
//                    completion(.success(foundUser))
//                }
//                
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
//    
//    func fetchUserFor(_ hype: Hype, completion: @escaping (Result<User, UserError>) -> Void) {
//        guard let userID = hype.userReference?.recordID
//            else { completion(.failure(.noUserForHype)); return }
//        
//        let fetchUserPredicate = NSPredicate(format: "%K == %@", argumentArray:["recordID", userID])
//        let query = CKQuery(recordType: UserConstants.recordType, predicate: fetchUserPredicate)
//        
//        publicDB.perform(query, inZoneWith: nil) { (records, error) in
//            if let error = error {
//                print(error.localizedDescription + "--> \(error)")
//            }
//            
//            guard let record = records?.first,
//            let foundUser = User(ckRecord: record)
//                else { completion(.failure(.couldNotUnwrap)); return }
//            
//            completion(.success(foundUser))
//        }
//    }
    
    
} // end class
