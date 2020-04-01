//
//  UserError.swift
//  Hype
//
//  Created by Theo Vora on 4/1/20.
//  Copyright © 2020 Theo Vora. All rights reserved.
//

import Foundation

enum UserError: LocalizedError {
    case ckError(Error)
    case noUserLoggedIn
    case couldNotUnwrap
    
    var errorDescription: String {
        switch self {
        case .ckError(let error):
            return "CloudKit returned an error: \(error.localizedDescription)"
        case .noUserLoggedIn:
            return "No user logged in."
        case .couldNotUnwrap:
            return "Unable to unwrap the value."
        }
            
    } // end errorDescription
} // end enum
