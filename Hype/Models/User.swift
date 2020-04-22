//
//  User.swift
//  Hype
//
//  Created by Theo Vora on 4/1/20.
//  Copyright © 2020 Theo Vora. All rights reserved.
//

import Foundation
import UIKit.UIImage

struct UserConstants {
    static let recordType = "User"
    fileprivate static let usernameKey = "username" // fileprivate means you cannot autocomplete outside of this file?
    fileprivate static let bioKey = "bio"
    static let appleUserRefKey = "appleUserRef"
    fileprivate static let photoAssetKey = "photoAsset"
}

class User {
    var username: String
    var bio: String
    
    var photoData: Data?
    
    var profilePhoto: UIImage? {
        get {
            guard let photoData = photoData else { return nil }
            return UIImage(data: photoData)
        }
        set {
            photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    
    /**
    Initializes a User object.
     
    - Parameters:
        - username: String value fore the User's username property
        - bio: String value for the User's bio property, set by default to an empty string
        - recordID: ckRecordID value for teh User's recordID property, set by default to a uuidString
        - appleUserRef: CKRecord.Reference value for the Users's appleUserRef property
        - profilePhoto: UIImage of the user's profile
     */
    
    init(username: String, bio: String = "", profilePhoto: UIImage? = nil) {
        
        self.username = username
        self.bio = bio
        self.profilePhoto = profilePhoto
    }
}

extension User {
    
    /**
     Failable Convenience Initializer to init Users from CKRecords.
     
     - Parameters:
        - ckRecord: CKRecord containing Key/Value pairs to init a User Object
     */
    
    
//    convenience init?(ckRecord: CKRecord) {
//        guard let username = ckRecord[UserConstants.usernameKey] as? String,
//            let bio = ckRecord[UserConstants.bioKey] as? String,
//            let appleUserRef = ckRecord[UserConstants.appleUserRefKey] as? CKRecord.Reference
//        else { return nil }
//
//        var foundPhoto: UIImage?
//        if let photoAsset = ckRecord[UserConstants.photoAssetKey] as? CKAsset {
//            do {
//                let data = try Data(contentsOf: photoAsset.fileURL!)
//                foundPhoto = UIImage(data: data)
//            } catch {
//                print(error)
//            }
//        }
//
//        self.init(username: username, bio: bio, recordID: ckRecord.recordID, appleUserRef: appleUserRef, profilePhoto: foundPhoto)
//    }
}

//extension CKRecord {
//
//    /**
//     Convenience init to create a CKRecord from a Hype Object
//
//     - Parameters:
//        - user: The User object to set Key/Value pairs for inside the CKRecord object
//     */
//
//
//    convenience init(user: User) {
//
//        self.init(recordType: UserConstants.recordType, recordID: user.recordID)
//
//        setValuesForKeys([
//            UserConstants.usernameKey: user.username,
//            UserConstants.bioKey: user.bio,
//            UserConstants.appleUserRefKey : user.appleUserRef
//        ])
//
//        // CKAsset photo is optional. Must unwrap. Cannot simply assign.
//
//        if let photoAsset = user.photoAsset {
//            self.setValue(photoAsset, forKey: UserConstants.photoAssetKey)
//        }
//    }
//}

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        // TO-DO: redefine this
//        lhs.recordID == rhs.recordID
    }
}
