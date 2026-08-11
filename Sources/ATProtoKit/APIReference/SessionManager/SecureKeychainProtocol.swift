//
//  SecureKeychainProtocol.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-04-06.
//


import Foundation

/// Stores the credentials used by an AT Protocol App Password session.
///
/// This compatibility protocol preserves existing custom credential implementations. New code
/// should conform to ``ATCredentialStore`` and pass that store to ``ATProtocolConfiguration``.
/// The newer protocol supports both App Password and OAuth persistence through opaque values.
@available(*, deprecated, message: "Conform to ATCredentialStore and use ATProtocolConfiguration.init(pdsURL:credentialStore:sessionIdentifier:configuration:canResolve:) instead.")
public protocol SecureKeychainProtocol: Sendable {

    /// A unique identifier for linking the instance of `UserSession` to the credentials.
    var identifier: UUID { get }

    /// Retrieves the access token of the account.
    ///
    /// - Returns: The access token of the account.
    ///
    /// - Throws: An error if the access token doesn't exist.
    func retrieveAccessToken() async throws -> String

    /// Saves the access token of the account.
    ///
    /// - Parameter accessToken: The token used to authenticate to the service.
    func saveAccessToken(_ accessToken: String) async throws

    /// Deletes the access token of the account.
    func deleteAccessToken() async throws

    /// Saves the password of the account to the keychain.
    ///
    /// This can be either the user's real password or the App Password.
    ///
    /// - Parameter password: The password of the account.
    func savePassword(_ password: String) async throws

    /// Retrieves the password of the account from the keychain.
    ///
    /// - Returns: The password itself.
    ///
    /// - Throws: An error if the password doesn't exist.
    func retrievePassword() async throws -> String

    /// Updates the password of the account into the keychain.
    ///
    /// - Parameter newPassword: The new account password.
    func updatePassword(_ newPassword: String) async throws

    /// Deletes the password of the account from the keychain.
    func deletePassword() async throws

    /// Saves the refresh token of the account to the keychain.
    ///
    /// - Parameter refreshToken: The refresh token of the account.
    func saveRefreshToken(_ refreshToken: String) async throws

    /// Retrieves the refresh token of the account to the keychain.
    ///
    /// - Returns: The refresh token of the account.
    ///
    /// - Throws: An error if the refresh token doesn't exist.
    func retrieveRefreshToken() async throws -> String

    /// Updates the refresh token of the account to the keychain.
    func updateRefreshToken(_ newRefreshToken: String) async throws

    /// Deletes the refresh token of the account to the keychain.
    func deleteRefreshToken() async throws
}

/// Supplies legacy App Password operations to stores that also support opaque values.
@available(*, deprecated, message: "Use ATCredentialStore through ATProtocolConfiguration instead.")
extension SecureKeychainProtocol where Self: ATCredentialStore {

    /// Retrieves the persisted App Password access token.
    ///
    /// - Returns: The access token of the account.
    ///
    /// - Throws: ``ATCredentialStoreError`` or a secure-backend error.
    public func retrieveAccessToken() async throws -> String {
        guard let value = try await loadString(forKey: accessTokenStorageKey) else {
            throw ATCredentialStoreError.accessTokenNotFound
        }

        return value
    }

    /// Saves the App Password access token.
    ///
    /// - Parameter accessToken: The access token to persist.
    ///
    /// - Throws: An error from the secure-value backend.
    public func saveAccessToken(_ accessToken: String) async throws {
        try await saveString(accessToken, forKey: accessTokenStorageKey)
    }

    /// Deletes the App Password access token.
    ///
    /// - Throws: An error from the secure-value backend.
    public func deleteAccessToken() async throws {
        try await deleteValue(forKey: accessTokenStorageKey)
    }

    /// Saves the App Password credential.
    ///
    /// - Parameter password: The App Password credential to persist.
    ///
    /// - Throws: An error from the secure-value backend.
    public func savePassword(_ password: String) async throws {
        try await saveString(password, forKey: passwordStorageKey)
    }

    /// Retrieves the persisted App Password credential.
    ///
    /// - Returns: The App Password credential.
    ///
    /// - Throws: ``ATCredentialStoreError`` or a secure-backend error.
    public func retrievePassword() async throws -> String {
        guard let value = try await loadString(forKey: passwordStorageKey) else {
            throw ATCredentialStoreError.valueNotFound(key: passwordStorageKey)
        }

        return value
    }

    /// Replaces the persisted App Password credential.
    ///
    /// - Parameter newPassword: The new App Password credential.
    ///
    /// - Throws: An error from the secure-value backend.
    public func updatePassword(_ newPassword: String) async throws {
        try await saveString(newPassword, forKey: passwordStorageKey)
    }

    /// Deletes the persisted App Password credential.
    ///
    /// - Throws: An error from the secure-value backend.
    public func deletePassword() async throws {
        try await deleteValue(forKey: passwordStorageKey)
    }

    /// Saves the App Password refresh token.
    ///
    /// - Parameter refreshToken: The refresh token to persist.
    ///
    /// - Throws: An error from the secure-value backend.
    public func saveRefreshToken(_ refreshToken: String) async throws {
        try await saveString(refreshToken, forKey: refreshTokenStorageKey)
    }

    /// Retrieves the persisted App Password refresh token.
    ///
    /// - Returns: The refresh token.
    ///
    /// - Throws: ``ATCredentialStoreError`` or a secure-backend error.
    public func retrieveRefreshToken() async throws -> String {
        guard let value = try await loadString(forKey: refreshTokenStorageKey) else {
            throw ATCredentialStoreError.valueNotFound(key: refreshTokenStorageKey)
        }

        return value
    }

    /// Replaces the persisted App Password refresh token.
    ///
    /// - Parameter newRefreshToken: The new refresh token.
    ///
    /// - Throws: An error from the secure-value backend.
    public func updateRefreshToken(_ newRefreshToken: String) async throws {
        try await saveString(newRefreshToken, forKey: refreshTokenStorageKey)
    }

    /// Deletes the persisted App Password refresh token.
    ///
    /// - Throws: An error from the secure-value backend.
    public func deleteRefreshToken() async throws {
        try await deleteValue(forKey: refreshTokenStorageKey)
    }

    /// The storage key for the access token.
    private var accessTokenStorageKey: String {
        return "\(identifier.uuidString).accessToken"
    }

    /// The storage key for the App Password credential.
    private var passwordStorageKey: String {
        return "\(identifier.uuidString).password"
    }

    /// The storage key for the refresh token.
    private var refreshTokenStorageKey: String {
        return "\(identifier.uuidString).refreshToken"
    }

    /// Loads a UTF-8 string from the credential store. Optional.
    ///
    /// - Parameter key: The key identifying the stored string.
    /// - Returns: The decoded string, or `nil` when no value exists. Optional.
    ///
    /// - Throws: ``ATCredentialStoreError/invalidStringData`` or a secure-backend error.
    private func loadString(forKey key: String) async throws -> String? {
        guard let data = try await loadValue(forKey: key) else {
            return nil
        }
        guard let value = String(data: data, encoding: .utf8) else {
            throw ATCredentialStoreError.invalidStringData
        }

        return value
    }

    /// Saves a UTF-8 string to the credential store.
    ///
    /// - Parameters:
    ///   - value: The string to save.
    ///   - key: The key identifying the stored string.
    ///
    /// - Throws: An error from the credential store.
    private func saveString(_ value: String, forKey key: String) async throws {
        try await saveValue(Data(value.utf8), forKey: key)
    }
}
