import Foundation

final class KeychainWrapper {
    
    private let service = "com.sportytest.github"
    private let account = "github_token"
    
    func saveToken(_ token: String) throws {
        let data = token.data(using: .utf8)!
        
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        
        let attributes: [String: Any] = [
            kSecValueData as String: data
        ]
        
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        
        if status == errSecItemNotFound {
            query[kSecValueData as String] = data
            let addStatus = SecItemAdd(query as CFDictionary, nil)
            if addStatus != errSecSuccess {
                throw KeychainError.failedToSave
            }
        } else if status != errSecSuccess {
            throw KeychainError.failedToSave
        }
    }
    
    func getToken() throws -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status != errSecItemNotFound else { return nil }
        guard status == errSecSuccess else { throw KeychainError.failedToRetrieve }
        
        guard let data = result as? Data else { throw KeychainError.failedToRetrieve }
        guard let token = String(data: data, encoding: .utf8) else { throw KeychainError.failedToRetrieve }
        
        return token
    }
    
    func deleteToken() throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.failedToDelete
        }
    }
}

enum KeychainError: LocalizedError {
    case failedToSave
    case failedToRetrieve
    case failedToDelete
    
    var errorDescription: String? {
        switch self {
        case .failedToSave:
            return "Failed to save token to keychain"
        case .failedToRetrieve:
            return "Failed to retrieve token from keychain"
        case .failedToDelete:
            return "Failed to delete token from keychain"
        }
    }
}
