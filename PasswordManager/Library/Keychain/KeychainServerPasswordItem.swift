/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    A struct for accessing generic password keychain items.
*/

import Foundation

struct KeychainServerPasswordItem {
    // MARK: Types
    
    enum KeychainError: Error {
        case noPassword
        case unexpectedPasswordData
        case unexpectedItemData
        case unhandledError(status: OSStatus)
    }
    
    // MARK: Properties
    
    let server: String
    var account: String
    var creator: String

    let accessGroup: String?

    // MARK: Intialization
    
    init(server: String, account: String, creator: String, accessGroup: String? = nil) {
        self.server = server
        self.account = account
        self.creator = creator
        self.accessGroup = accessGroup
    }
    
    // MARK: Keychain access
    
    func readPassword() throws -> String  {
        /*
            Build a query to find the item that matches the server, account and
            access group.
        */
        var query = KeychainServerPasswordItem.keychainQuery(withCreator: creator, server: server, account: account, accessGroup: accessGroup)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanTrue
        
        // Try to fetch the existing keychain item that matches the query.
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        // Check the return status and throw an error if appropriate.
        guard status != errSecItemNotFound else { throw KeychainError.noPassword }
        guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        
        // Parse the password string from the query result.
        guard let existingItem = queryResult as? [String : AnyObject],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: String.Encoding.utf8)
        else {
            throw KeychainError.unexpectedPasswordData
        }
        
        return password
    }
    
    func savePassword(_ password: String) throws {
        // Encode the password into an Data object.
        let encodedPassword = password.data(using: String.Encoding.utf8)!
        
        do {
            // Check for an existing item in the keychain.
            try _ = readPassword()

            // Update the existing item with the new password.
            var attributesToUpdate = [String : AnyObject]()
            attributesToUpdate[kSecValueData as String] = encodedPassword as AnyObject?

            let query = KeychainServerPasswordItem.keychainQuery(withCreator: creator, server: server, account: account, accessGroup: accessGroup)
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            
            // Throw an error if an unexpected status was returned.
            guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        }
        catch KeychainError.noPassword {
            /*
                No password was found in the keychain. Create a dictionary to save
                as a new keychain item.
            */
            var newItem = KeychainServerPasswordItem.keychainQuery(withCreator: creator, server: server, account: account, accessGroup: accessGroup)
            newItem[kSecValueData as String] = encodedPassword as AnyObject?
            
            // Add a the new item to the keychain.
            let status = SecItemAdd(newItem as CFDictionary, nil)
            
            // Throw an error if an unexpected status was returned.
            guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        }
    }
    
    mutating func renameAccount(_ newAccountName: String) throws {
        // Try to update an existing item with the new account name.
        var attributesToUpdate = [String : AnyObject]()
        attributesToUpdate[kSecAttrAccount as String] = newAccountName as AnyObject?
        
        let query = KeychainServerPasswordItem.keychainQuery(withCreator: creator, server: server, account: account, accessGroup: accessGroup)
        let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
        
        // Throw an error if an unexpected status was returned.
        guard status == noErr || status == errSecItemNotFound else { throw KeychainError.unhandledError(status: status) }
        
        self.account = newAccountName
    }

    static func deleteAll() throws {
        let dictionary = [kSecClass as String: kSecClassInternetPassword]
        let status = SecItemDelete(dictionary as CFDictionary)
        // Throw an error if an unexpected status was returned.
        guard status == noErr || status == errSecItemNotFound else { throw KeychainError.unhandledError(status: status) }
    }
    
    func deleteItem() throws {
        // Delete the existing item from the keychain.
        let query = KeychainServerPasswordItem.keychainQuery(withCreator: creator, server: server, account: account, accessGroup: accessGroup)
        let status = SecItemDelete(query as CFDictionary)
        
        // Throw an error if an unexpected status was returned.
        guard status == noErr || status == errSecItemNotFound else { throw KeychainError.unhandledError(status: status) }
    }
    
    static func passwordItems(forCreator creator: String, server: String? = nil, accessGroup: String? = nil) throws -> [KeychainServerPasswordItem] {
        // Build a query for all items that match the server and access group.
        var query = KeychainServerPasswordItem.keychainQuery(withCreator: creator, server: server, accessGroup: accessGroup)
        query[kSecMatchLimit as String] = kSecMatchLimitAll
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanFalse

        // Fetch matching items from the keychain.
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        // If no items were found, return an empty array.
        guard status != errSecItemNotFound else { return [] }

        // Throw an error if an unexpected status was returned.
        guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        
        // Cast the query result to an array of dictionaries.
        guard let resultData = queryResult as? [[String : AnyObject]] else { throw KeychainError.unexpectedItemData }
        
        // Create a `KeychainPasswordItem` for each dictionary in the query result.
        var passwordItems = [KeychainServerPasswordItem]()
        for result in resultData {
            guard
                let creator = result[kSecAttrCreator as String] as? String,
                let account = result[kSecAttrAccount as String] as? String,
                let server = result[kSecAttrServer as String] as? String
            else { throw KeychainError.unexpectedItemData }
            
            let passwordItem = KeychainServerPasswordItem(server: server, account: account, creator: creator, accessGroup: accessGroup)
            passwordItems.append(passwordItem)
        }
        
        return passwordItems
    }

    // MARK: Convenience
    
    private static func keychainQuery(withCreator creator: String, server: String? = nil, account: String? = nil, accessGroup: String? = nil) -> [String : AnyObject] {
        var query = [String : AnyObject]()
        query[kSecClass as String] = kSecClassInternetPassword
        query[kSecAttrCreator as String] = creator as AnyObject?

        if let server = server {
            query[kSecAttrServer as String] = server as AnyObject?
        }

        if let account = account {
            query[kSecAttrAccount as String] = account as AnyObject?
        }

        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup as AnyObject?
        }
        
        return query
    }
}

extension KeychainServerPasswordItem: Equatable {
    static func ==(lhs: KeychainServerPasswordItem, rhs: KeychainServerPasswordItem) -> Bool {
        return lhs.account == rhs.account && lhs.server == rhs.server && lhs.creator == rhs.creator
    }
}
