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

class Hype {
    var body: String
    var timestamp: Date
    var recordID: CKRecord.ID
    var userReference: CKRecord.Reference?
    var user: User?
    var photoData: Data?
    
    var hypePhoto: UIImage? {
        get {
            guard let photoData = photoData else { return nil }
            return UIImage(data: photoData)
        }
        set {
            photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    
    var photoAsset: CKAsset? {
        get {
            guard let photoData = photoData else { return nil }
            let tempDirectory = NSTemporaryDirectory()
            let tempDirectoryURL = URL(fileURLWithPath: tempDirectory)
            let fileURL = tempDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
            do {
                try photoData.write(to: fileURL)
            } catch {
                print(error)
            }
            return CKAsset(fileURL: fileURL)
        }
    }
    
    /**
     Initializes a Hype object.
     
     - Parameters
        - body: String value for the Hype's body property
        - timestamp: Date value for the Hype's timestamp property. default value = Date()
     */
    
    
    init(body: String, timestamp: Date = Date(), recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), userReference: CKRecord.Reference?, hypePhoto: UIImage? = nil) {
        self.body = body
        self.timestamp = timestamp
        self.recordID = recordID
        self.userReference = userReference
        
        self.hypePhoto = hypePhoto // computed property. must be last.
    }
}

// Incoming <---- (CKRecord into Hype)

extension Hype {
    
    /**
     Convenience Failable Initializer to initialize Hypes stored in CloudKit
     
     - Parameters:
        - ckRecord: the CKRecord object to turn into a Hype object
     */
    
    convenience init?(ckRecord: CKRecord) {
        
        // get properties
        guard let body = ckRecord[HypeStrings.bodyKey] as? String,
            let timestamp = ckRecord[HypeStrings.timestampKey] as? Date
            else { return nil }
        
        let userReference = ckRecord[HypeStrings.userReferenceKey] as? CKRecord.Reference
        
        var foundPhoto: UIImage?
        if let photoAsset = ckRecord[HypeStrings.photoAssetKey] as? CKAsset {
            do {
                let data = try Data(contentsOf: photoAsset.fileURL!)
                foundPhoto = UIImage(data: data)
            } catch {
                print(error)
            }
        }
        
        // init
        self.init(body: body, timestamp: timestamp, recordID: ckRecord.recordID, userReference: userReference, hypePhoto: foundPhoto)
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
