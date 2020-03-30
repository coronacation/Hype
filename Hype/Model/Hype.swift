//
//  Hype.swift
//  Hype
//
//  Created by theevo on 3/30/20.
//  Copyright © 2020 Theo Vora. All rights reserved.
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
    let body: String
    let timestamp: Date
    
    init(body: String, timestamp: Date = Date()) {
        self.body = body
        self.timestamp = timestamp
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
        self.init(body: body, timestamp: timestamp)
    }
}


// Outgoing ---> (Hype into CKRecord)


extension CKRecord {
    convenience init(hype: Hype) {
        self.init(recordType: HypeStrings.recordTypeKey)
        
        self.setValuesForKeys([
            HypeStrings.bodyKey: hype.body,
            HypeStrings.timestampKey: hype.timestamp
        ])
        
//        Alternative: set dictionary values one at time
//        self.setValue(hype.body, forKey: HypeStrings.bodyKey)
//        self.setValue(hype.timestamp, forKey: HypeStrings.timestampKey)
    }
}
