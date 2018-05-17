//
//  APIResponse.swift
//  PasswordManager
//
//  Created by Caio Sanchez Santos Costa on 15/05/18.
//  Copyright © 2018 Caio Sanchez Santos Costa. All rights reserved.
//

import Foundation

struct APIResponse: Decodable {
    let type: String
    var token: String?
    var message: String?
    var errors: [String]?
    var successful: Bool {
        return type == "sucess" || type == "success"
    }
}

enum APIError: Error {
    case error(message: String, errors: [String]?)
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .error(let message, let errors):
            guard let errors = errors else { return message }
            let formatedErrors = errors.reduce("") { $0 + " " + $1 }
            return "\(message): \(formatedErrors)"
        }
    }
}
