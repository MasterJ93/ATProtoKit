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
        <#code#>
    }

    /// Retrieves the stored password.
    ///
    /// - Returns: The stored password, or `nil` if not found.
    ///
    /// - Throws: A `KeychainError` if the operation fails.
    public func retrievePassword() throws -> String? {
        <#code#>
    }

    /// Updates the stored password with a new value.
    ///
    /// - Parameter password: The new password to update.
    ///
    /// - Throws: A `KeychainError` if the operation fails.
    public func updatePassword(_ password: String) throws {
        <#code#>
    }

    /// Removes the stored password.
    ///
    /// - Throws: A `KeychainError` if the operation fails.
    public func removePassword() throws {
        <#code#>
    }

    /// Stores the provided refresh token securely.
    ///
    /// - Parameter token: The refresh token to store.
    ///
    /// - Throws: A `KeychainError` if the operation fails.
    public func storeRefreshToken(_ token: String) throws {
        <#code#>
    }

    /// Retrieves the stored refresh token.
    ///
    /// - Returns: The stored refresh token, or `nil` if not found.
    ///
    /// - Throws: A `KeychainError` if the operation fails.
    public func retrieveRefreshToken() throws -> String? {
        <#code#>
    }

    /// Updates the stored refresh token with a new value.
    ///
    /// - Parameter token: The new refresh token to update.
    ///
    /// - Throws: A `KeychainError` if the operation fails.
    public func updateRefreshToken(_ token: String) throws {
        <#code#>
    }

    /// Removes the stored refresh token.
    ///
    /// - Throws: A `KeychainError` if the operation fails.
    public func removeRefreshToken() throws {
        <#code#>
    }

    /// Constructs a keychain query dictionary for a given key.
    ///
    /// - Parameter key: The key for the keychain.
    /// - Returns: A keychain query dictionary.
    private func keychainQuery(for key: String) -> [String: Any] {
        return [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecAttrService as String: Bundle.main.bundleIdentifier ?? "dev.atprotokit.keychain",
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]
    }
}
#endif
