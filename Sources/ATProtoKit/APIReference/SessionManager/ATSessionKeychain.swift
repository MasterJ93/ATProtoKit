//
//  ATSessionKeychain.swift
//
//
//  Created by Christopher Jr Riley on 2025-03-01.
//

import Foundation

#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
import Security

///
public struct ATSessionKeychain: SessionKeychainProtocol {

    /// The unique key for storing the user account's password.
    public let passwordKey: String = "dev.atprotokit.password"

    /// The unique key for storing the user account's refresh token.
    public let refreshTokenKey: String = "dev.atprotokit.refreshToken"


    /// Stores the provided password securely.
    ///
    /// - Parameter password: The user's password to store.
    ///
    /// - Throws: A `KeychainError` if the operation fails.
    public func storePassword(_ password: String) throws {
        // Convert the password string to Data.
        guard let data = password.data(using: .utf8) else {
            throw ATKeychainError.storeError(message: "Unable to encode password data.")
        }

        try storeData(data, for: passwordKey)
    }

    /// Retrieves the stored password.
    ///
    /// - Returns: The stored password, or `nil` if not found.
    ///
    /// - Throws: A `KeychainError` if the operation fails.
    public func retrievePassword() throws -> String? {
        guard let data = try retrieveData(for: passwordKey) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    /// Updates the stored password with a new value.
    ///
    /// - Parameter password: The new password to update.
    ///
    /// - Throws: A `KeychainError` if the operation fails.
    public func updatePassword(_ password: String) throws {
        guard let data = password.data(using: .utf8) else {
            throw ATKeychainError.updateError(message: "Unable to encode password data.")
        }

        try updateData(data, for: passwordKey)
    }

    /// Removes the stored password.
    ///
    /// - Throws: A `KeychainError` if the operation fails.
    public func removePassword() throws {
        try removeData(for: passwordKey)
    }

    /// Stores the provided refresh token securely.
    ///
    /// - Parameter token: The refresh token to store.
    ///
    /// - Throws: A `KeychainError` if the operation fails.
    public func storeRefreshToken(_ token: String) throws {
        guard let data = token.data(using: .utf8) else {
            throw ATKeychainError.storeError(message: "Unable to encode refresh token data.")
        }

        try storeData(data, for: refreshTokenKey)
    }

    /// Retrieves the stored refresh token.
    ///
    /// - Returns: The stored refresh token, or `nil` if not found.
    ///
    /// - Throws: A `KeychainError` if the operation fails.
    public func retrieveRefreshToken() throws -> String? {
        guard let data = try retrieveData(for: refreshTokenKey) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    /// Updates the stored refresh token with a new value.
    ///
    /// - Parameter token: The new refresh token to update.
    ///
    /// - Throws: A `KeychainError` if the operation fails.
    public func updateRefreshToken(_ token: String) throws {
        guard let data = token.data(using: .utf8) else {
            throw ATKeychainError.updateError(message: "Unable to encode refresh token data.")
        }

        try updateData(data, for: refreshTokenKey)
    }

    /// Removes the stored refresh token.
    ///
    /// - Throws: A `KeychainError` if the operation fails.
    public func removeRefreshToken() throws {
        try removeData(for: refreshTokenKey)
    }

    /// Constructs a keychain query dictionary for a given key.
    ///
    /// - Parameter key: The key for the keychain.
    /// - Returns: A keychain query dictionary.
    private func query(for key: String) -> [String: Any] {
        return [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecAttrService as String: Bundle.main.bundleIdentifier ?? "dev.atprotokit.keychain",
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]
    }

    /// Stores raw data in the keychain for a given key.
    ///
    /// - Parameters:
    ///   - data: The data to store.
    ///   - key: The key associated with the data.
    ///
    /// - Throws: A `KeychainError.storeError` if storing fails.
    private func storeData(_ data: Data, for key: String) throws {
        var query = query(for: key)
        query[kSecValueData as String] = data

        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw ATKeychainError.storeError(message: "Unable to store data for key \(key), status code: \(status)")
        }
    }

    /// Updates existing data in the keychain for a given key.
    ///
    /// - Parameters:
    ///   - data: The new data to update.
    ///   - key: The key associated with the data.
    ///
    /// - Throws: A `KeychainError.updateError` if the update fails.
    private func updateData(_ data: Data, for key: String) throws {
        let query = query(for: key)
        let attributesToUpdate = [kSecValueData as String: data]

        let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
        guard status == errSecSuccess else {
            throw ATKeychainError.updateError(message: "Unable to update data for key \(key), status code: \(status)")
        }
    }

    /// Retrieves raw data from the keychain for a given key.
    ///
    /// - Parameter key: The key associated with the item.
    /// - Returns: The retrieved data, or `nil` if no data exists for the key.
    ///
    /// - Throws: A `KeychainError.retrievalError` if the retrieval fails.
    private func retrieveData(for key: String) throws -> Data? {
        var query = query(for: key)
        query[kSecReturnData as String] = kCFBooleanTrue
        query[kSecMatchLimit as String] = kSecMatchLimitOne

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw ATKeychainError.retrievalError(message: "Unable to retrieve data for key \(key), status code: \(status)")
        }

        return result as? Data
    }

    /// Deletes data in the keychain for a given key.
    ///
    /// - Parameter key: The key associated with the item.
    ///
    /// - Throws: A `KeychainError.removalError` if the deletion fails.
    private func removeData(for key: String) throws {
        let query = query(for: key)
        let status = SecItemDelete(query as CFDictionary)

        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw ATKeychainError.removalError(message: "Unable to remove data for key \(key), status code: \(status)")
        }
    }
}
#endif
