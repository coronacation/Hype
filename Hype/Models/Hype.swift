//
//  Hype.swift
//  Hype
//
//  Created by Theo Vora on 3/30/20.
//  Copyright © 2020 Studio Awaken. All rights reserved.
//

import CloudKit // contains Foundation. right-click and Jump to Definition for proof.


// MARK: - Constants

struct HypeStrings {
    static let recordTypeKey = "Hype"
    static let bodyKey = "body"
    static let timestampKey = "timestamp"
}

// MARK: - Model

class Hype {
    var body: String
    var timestamp: Date
    var recordID: CKRecord.ID
    
    init(body: String, timestamp: Date = Date(), recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.body = body
        self.timestamp = timestamp
        self.recordID = recordID
    }
}

// Incoming <---- (CKRecord into Hype)

extension Hype {
    
    convenience init?(ckRecord: CKRecord) {
        
        // get properties
        guard let body = ckRecord[HypeStrings.bodyKey] as? String,
            let timestamp = ckRecord[HypeStrings.timestampKey] as? Date
            else { return nil }
        
        // init
        self.init(body: body, timestamp: timestamp, recordID: ckRecord.recordID)
    }
}


// Outgoing ---> (Hype into CKRecord)


extension CKRecord {
    convenience init(hype: Hype) {
        self.init(recordType: HypeStrings.recordTypeKey, recordID: hype.recordID)
        
        self.setValuesForKeys([
            HypeStrings.bodyKey: hype.body,
            HypeStrings.timestampKey: hype.timestamp
        ])
        
//        Alternative: set dictionary values one at time
//        self.setValue(hype.body, forKey: HypeStrings.bodyKey)
//        self.setValue(hype.timestamp, forKey: HypeStrings.timestampKey)
    }
}


extension Hype: Equatable {
    static func == (lhs: Hype, rhs: Hype) -> Bool {
        return lhs.recordID == rhs.recordID
    }
}