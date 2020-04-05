//
//  CloudKitProtocols+Extensions.swift
//  Hype
//
//  Created by Theo Vora on 4/3/20.
//  Copyright © 2020 Theo Vora. All rights reserved.
//

import UIKit.UIImage
import CloudKit

protocol CKSyncable {
    
    var ckRecord: CKRecord { get }
    var recordID: CKRecord.ID { get set }
    static var recordType: CKRecord.RecordType { get }
    init?(record: CKRecord)
}

protocol CKPhotoAssetAttachable where Self: CKSyncable {
    var photo: UIImage? { get set }
    var photoData: Data? { get }
    var photoAsset: CKAsset? { get }
}

extension CKPhotoAssetAttachable {
    var photoData: Data? {
        guard let photo = photo else { return nil }
        return photo.jpegData(compressionQuality: 0.5)
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
}


extension CKAsset {
    func getImageForAsset() -> UIImage? {
        guard let data = try? Data(contentsOf: self.fileURL!) else { return nil }
        return UIImage(data: data)
    }
}
