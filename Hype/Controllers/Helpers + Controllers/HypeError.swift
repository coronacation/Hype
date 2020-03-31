//
//  HypeError.swift
//  Hype
//
//  Created by theevo on 3/31/20.
//  Copyright © 2020 Theo Vora. All rights reserved.
//

import Foundation

enum HypeError: LocalizedError {
    case ckError(Error)
    case couldNotUnwrap
    case unexpectedRecordFound
    
    var errorDescription: String {
        switch self {
        case .ckError(let error):
            return error.localizedDescription
        case .couldNotUnwrap:
            return "Unable to get this Hype, That's not very Hype..."
        case .unexpectedRecordFound:
            return "Unexpected record found when none should have been returned"
        }
    }
    
}
