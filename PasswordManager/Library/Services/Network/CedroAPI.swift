//
//  CedroAPI.swift
//  PasswordManager
//
//  Created by Caio Sanchez Santos Costa on 14/05/18.
//  Copyright © 2018 Caio Sanchez Santos Costa. All rights reserved.
//

import Foundation
import Moya

enum CedroAPI {
    case signUp(SignUpDataType)
    case signIn(SignInDataType)
    case logo(url: String, token: String)
}

extension CedroAPI: TargetType {

    var base: String { return "https://dev.people.com.ai/mobile/api/v2" }

    var baseURL: URL {
        switch self {
        case .signIn, .signUp:
            return URL(string: base)!
        case .logo(let siteUrl, _):
            return URL(string: base + "/\(siteUrl)")!
        }
    }

    var path: String {
        switch self {
        case .signUp:
            return "/register"
        case .signIn:
            return "/login"
        default:
            return ""
        }
    }

    var method: Moya.Method {
        switch self {
        case .signUp, .signIn:
            return .post
        case .logo:
            return .get
        }
    }

    var sampleData: Data {
        switch self {
        case .signUp:
            return Data()
        case .signIn:
            return Data()
        case .logo:
            return Data()
        }
    }

    var task: Task {
        switch self {
        case .signUp(let signUpData):
            return .requestJSONEncodable(signUpData)
        case .signIn(let signInData):
            return .requestJSONEncodable(signInData)
        case .logo:
            return .requestPlain
        }
    }

    var headers: [String : String]? {
        switch self {
        case .logo(_, let token):
            return ["authorization": token]
        default:
            return nil
        }
    }

}
