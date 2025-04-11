//
//  AppleSecureKeychain.swift
//
//
//  Created by Christopher Jr Riley on 2025-03-01.
//

import Foundation

#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
import Security

/// Manages the keychains asociated with the sessions for the AT Protocol.
public actor AppleSecureKeychain: SecureKeychainProtocol {

    /// The `UUID` identifier.
    ///
    /// This identifier links the instances of `AppleSecureKeychain`, `SessionConfiguration`,
    /// and `UserSession` together in a decoupled way, allowing for safe transfers of data.
    public let identifier: UUID

    /// The name of the service.
    ///
    /// This corresponds with the `kSecAttrService` parameter of the keychain.
    public let serviceName: String

    /// Initializes an instance of `AppleSecureKeychain`.
    ///
    /// You are welcome to create your own `UUID` value, but in most cases, you should let the
    /// `AppleSecureKeychain` instance handle this job for you.
    ///
    /// - Parameters:
    ///   - identitifer: A `UUID` value. Defaults to `UUID()`.
    ///   - serviceName: The name of the service. Defaults to `"ATProtoKit"`.
    public init(identifier: UUID = UUID(), serviceName: String = "ATProtoKit") {
        self.identifier = identifier
        self.serviceName = serviceName
    }

    /// The access token of the user account. Optional.
    ///
    /// This access token is stored in-memory due to how quickly this token expires.
    private var cachedAccessToken: String?

    /// A cached version of the refresh token. Optional.
    private var cachedRefreshToken: String?

    /// A cahced version of the password. Optional.
    private var cachedPassword: String?

    /// The key for the refresh token.
    private var refreshTokenKey: String { "\(identifier.uuidString).refreshToken" }

    /// The key for the password.
    private var passwordKey: String { "\(identifier.uuidString).password" }

    /// Retrieves the user account's access token.
    ///
    /// - Returns: The user account's access token.
    ///
    /// - Throws:
    public func retrieveAccessToken() async throws -> String {
        guard let cachedAccessToken = cachedAccessToken else {
            throw ApplSecureKeychainError.accessTokenNotFound
        }

        return cachedAccessToken
    }

    /// Saves the user account's access token in-memory.
    ///
    /// - Parameter accessToken: The user account's access token to save.
    ///
    /// - Throws:
    public func saveAccessToken(_ accessToken: String) async throws {
        cachedAccessToken = accessToken
    }

    /// Deletes the access token.
    ///
    /// - Note: Please be sure to delete the instance of the `UserSession` and
    /// `SessionConfiguration` if you're deleting the session.
    ///
    /// - Throws:
    public func deleteAccessToken() async throws {
        cachedAccessToken = nil
    }

    /// Retrieves the user account's refresh token.
    ///
    /// - Throws:
    public func retrieveRefreshToken() async throws -> String {
        if let cached = cachedRefreshToken {
            return cached
        }

        let token = try await readItem(forKey: refreshTokenKey)
        cachedRefreshToken = token
        return token
    }

    /// Saves the user account's refresh token to the keychain.
    ///
    /// - Parameter refreshToken: The user account's refresh token.
    ///
    /// - Throws: `ApplSecureKeychainError.unhandledStatus` if the operation failed.
    public func saveRefreshToken(_ refreshToken: String) async throws {
        try await saveOrUpdateItem(refreshToken, forKey: refreshTokenKey)
        cachedRefreshToken = refreshToken
    }

    /// Updates the user account's refresh token.
    ///
    /// - Parameter newRefreshToken: The user account's updated refresh token.
    ///
    /// - Throws:
    public func updateRefreshToken(_ newRefreshToken: String) async throws {
        try await saveOrUpdateItem(newRefreshToken, forKey: refreshTokenKey)
        cachedRefreshToken = newRefreshToken
    }

    /// Deletes the user account's refresh token.
    ///
    /// - Note: Please be sure to delete the instance of the `UserSession` and
    /// `SessionConfiguration` if you're deleting the session.
    ///
    /// - Throws:
    public func deleteRefreshToken() async throws {
        try await deleteItem(forKey: refreshTokenKey)
        cachedRefreshToken = nil
    }

    /// Retrieves the user account's password from the keychain.
    ///
    /// - Returns: The user account's password to save.
    ///
    /// - Throws:
    public func retrievePassword() async throws -> String {
        if let cached = cachedPassword {
            return cached
        }

        let password = try await readItem(forKey: passwordKey)
        cachedPassword = password

        return password
    }

    /// Saves the user account's password to the keychain.
    ///
    /// - Parameter password: The user account's password to save.
    ///
    /// - Throws: `ApplSecureKeychainError.unhandledStatus` if the operation failed.
    public func savePassword(_ password: String) async throws {
        try await saveOrUpdateItem(password, forKey: passwordKey)
        cachedPassword = password
    }

    /// Updates the user account's password.
    ///
    /// - Parameter newPassword: The updated password.
    ///
    /// - Throws: `ApplSecureKeychainError.unhandledStatus` if the operation failed.
    public func updatePassword(_ newPassword: String) async throws {
        try await saveOrUpdateItem(newPassword, forKey: passwordKey)
        cachedPassword = newPassword
    }

    /// Deletes the password from the keychain.
    ///
    /// - Note: Please be sure to delete the instance of the `UserSession` and
    /// `SessionConfiguration` if you're deleting the session.
    ///
    /// - Throws:
    public func deletePassword() async throws {
        try await deleteItem(forKey: passwordKey)
        cachedPassword = nil
    }

    // MARK: - Helpers

    /// Saves or updates a keychain item.
    ///
    /// - Parameters:
    ///   - value: The keychain value.
    ///   - key: The keychain key.
    ///
    ///   - Throws: `ApplSecureKeychainError.unhandledStatus` if the operation failed.
    private func saveOrUpdateItem(_ value: String, forKey key: String) async throws {
        let data = Data(value.utf8)

        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecAttrService: serviceName,
        ]

        let updateAttributes: [CFString: Any] = [
            kSecValueData: data
        ]

        let status = SecItemUpdate(query as CFDictionary, updateAttributes as CFDictionary)

        switch status {
            case errSecSuccess:
                return
            case errSecItemNotFound:
                var newItem = query
                newItem[kSecValueData] = data
                let addStatus = SecItemAdd(newItem as CFDictionary, nil)
                guard addStatus == errSecSuccess else {
                    throw ApplSecureKeychainError.unhandledStatus(status: addStatus)
                }
            default:
                throw ApplSecureKeychainError.unhandledStatus(status: status)
        }
    }

    /// Reads the value of the keychain item.
    ///
    /// - Parameter key: The key of the keychain value to read.
    /// - Returns: The keychain value.
    ///
    /// - Throws: An error if the item wasn't found, the data was invalid, or if there was an
    /// unhandled operation.
    private func readItem(forKey key: String) async throws -> String {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecAttrService: serviceName,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ]

        var item: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        guard status != errSecItemNotFound else {
            throw ApplSecureKeychainError.itemNotFound(key: key)
        }

        guard status == errSecSuccess else {
            throw ApplSecureKeychainError.unhandledStatus(status: status)
        }

        guard let data = item as? Data, let result = String(data: data, encoding: .utf8) else {
            throw ApplSecureKeychainError.invalidData
        }

        return result
    }

    /// Deletes the item from the keychain.
    ///
    /// - Parameter key: The key of the keychain item to delete.
    ///
    /// - Throws: `ApplSecureKeychainError.unhandledStatus` if there was an unhandled operation.
    private func deleteItem(forKey key: String) async throws {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecAttrService: serviceName
        ]

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw ApplSecureKeychainError.unhandledStatus(status: status)
        }
    }
}

// MARK: - Keychain Error

/// Errors related to keychain management.
public enum ApplSecureKeychainError: Error, LocalizedError {

    /// The keychain item was not found.
    ///
    /// - Parameter key: The key for the item.
    case itemNotFound(key: String)

    /// The access token could not be found.
    case accessTokenNotFound

    /// The data retrieved was invalid.
    case invalidData

    /// There was a keychain unhandled operation.
    ///
    /// - Parameter status: The `OSStatus` value.
    case unhandledStatus(status: OSStatus)

    public var errorDescription: String? {
        switch self {
            case .itemNotFound(let key):
                return "No item found for key: \(key)"
            case .accessTokenNotFound:
                return "No access token was found."
            case .invalidData:
                return "The data retrieved from the keychain was invalid."
            case .unhandledStatus(let status):
                return "Keychain operation failed with status: \(status)"
        }
    }
}
#endif
