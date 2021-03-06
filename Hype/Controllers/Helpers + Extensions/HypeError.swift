//
//  HypeError.swift
//  Hype
//
//  Created by Theo Vora on 3/31/20.
//  Copyright © 2020 Studio Awaken. All rights reserved.
//

import Foundation

enum HypeError: LocalizedError {
    case ckError(Error)
    case couldNotUnwrap
    case unexpectedRecordFound
    case noUserLoggedIn
    
    var errorDescription: String {
        switch self {
        case .ckError(let error):
            return error.localizedDescription
        case .couldNotUnwrap:
            return "Unable to get this Hype, That's not very Hype..."
        case .unexpectedRecordFound:
            return "Unexpected record found when none should have been returned"
        case .noUserLoggedIn:
            return "No user was found to be logged into iCloud"
        }
    }
    
}
