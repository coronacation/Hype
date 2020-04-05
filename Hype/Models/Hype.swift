//
//  Hype.swift
//  Hype
//
//  Created by Theo Vora on 3/30/20.
//  Copyright © 2020 Studio Awaken. All rights reserved.
//

import CloudKit // contains Foundation. right-click and Jump to Definition for proof.
import UIKit.UIImage


// MARK: - Constants

struct HypeStrings {
    static let recordTypeKey = "Hype"
    static let bodyKey = "body"
    static let timestampKey = "timestamp"
    fileprivate static let userReferenceKey = "userReference"
    fileprivate static let photoAssetKey = "photoAsset"
}

// MARK: - Model

class Hype : CKSyncable, CKPhotoAssetAttachable {
    var body: String
    var timestamp: Date
    var recordID: CKRecord.ID
    var userReference: CKRecord.Reference?
    var user: User?
    var photoData: Data?
    
    var photo: UIImage?
    
    
    
    // CKSyncable
    
    static var recordType: CKRecord.RecordType {
        HypeStrings.recordTypeKey
    }
    
    var ckRecord: CKRecord {
        let record = CKRecord(recordType: Hype.recordType, recordID: self.recordID)
        
        record.setValuesForKeys([
            HypeStrings.bodyKey : self.body,
            HypeStrings.timestampKey : self.timestamp
        ])
        
        if let asset = photoAsset {
            record.setValue(asset, forKey: HypeStrings.photoAssetKey)
        }
        
        if let reference = userReference {
            record.setValue(reference, forKey: HypeStrings.userReferenceKey)
        }
        
        return record
    }
    
    /**
     Initializes a Hype object.
     
     - Parameters
        - body: String value for the Hype's body property
        - timestamp: Date value for the Hype's timestamp property. default value = Date()
     */
    
    
    init(body: String, timestamp: Date = Date(), recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), userReference: CKRecord.Reference?, photo: UIImage? = nil) {
        self.body = body
        self.timestamp = timestamp
        self.recordID = recordID
        self.userReference = userReference
        
        self.photo = photo // computed property. must be last.
    }
    
    
    // Incoming <---- (CKRecord into Hype)
    
    /**
     Convenience Failable Initializer to initialize Hypes stored in CloudKit
     
     - Parameters:
        - ckRecord: the CKRecord object to turn into a Hype object
     */
    
    required convenience init?(record: CKRecord) {
        
        // get properties
        guard let body = record[HypeStrings.bodyKey] as? String,
            let timestamp = record[HypeStrings.timestampKey] as? Date
            else { return nil }
        
        let userReference = record[HypeStrings.userReferenceKey] as? CKRecord.Reference
        
        var foundPhoto: UIImage?
        if let photoAsset = record[HypeStrings.photoAssetKey] as? CKAsset {
            foundPhoto = photoAsset.getImageForAsset()
        }
        
        // init
        self.init(body: body, timestamp: timestamp, recordID: record.recordID, userReference: userReference, photo: foundPhoto)
    }
}


// Outgoing ---> (Hype into CKRecord)


extension CKRecord {
    
    /**
     Convenience Initialiizer to initialize a Cloud Kit record from a Hype object
     
     - Parameters:
        - hype: the Hype object that will be converted to a CKRecord
     */
    
    
    convenience init(hype: Hype) {
        self.init(recordType: HypeStrings.recordTypeKey, recordID: hype.recordID)
        
        self.setValuesForKeys([
            HypeStrings.bodyKey: hype.body,
            HypeStrings.timestampKey: hype.timestamp
        ])
        
//        Alternative: set dictionary values one at time
//        self.setValue(hype.body, forKey: HypeStrings.bodyKey)
//        self.setValue(hype.timestamp, forKey: HypeStrings.timestampKey)
        
        if let reference = hype.userReference {
            self.setValue(reference, forKey: HypeStrings.userReferenceKey)
        }
        
        if hype.photoAsset != nil {
            self.setValue(hype.photoAsset, forKey: HypeStrings.photoAssetKey )
        }
        
        
    }
}


extension Hype: Equatable {
    static func == (lhs: Hype, rhs: Hype) -> Bool {
        return lhs.recordID == rhs.recordID
    }
}
