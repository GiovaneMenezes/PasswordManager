//
//  UserDefaults+Codable.swift
//  PasswordManager
//
//  Created by Caio Sanchez Santos Costa on 10/05/18.
//  Copyright © 2018 Caio Sanchez Santos Costa. All rights reserved.
//

import Foundation

extension UserDefaults {

    public func store<T: Codable>(_ value: T,
                                  forKey key: String,
                                  encoder: JSONEncoder = JSONEncoder()) {
        if let data: Data = try? encoder.encode(value) {
            set(data, forKey: key)
        }
    }

    public func fetch<T>(forKey key: String,
                         type: T.Type,
                         decoder: JSONDecoder = JSONDecoder()) -> T? where T: Decodable {
        if let data = data(forKey: key) {
            return try? decoder.decode(type, from: data) as T
        }

        return nil
    }

}
