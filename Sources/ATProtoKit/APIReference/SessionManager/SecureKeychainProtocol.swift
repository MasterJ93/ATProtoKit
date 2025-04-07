//
//  SecureKeychainProtocol.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-04-06.
//


import Foundation

/// A protocol for managing the keychain in an AT Protcol account.
///
/// ATProtoKit contains a `struct` that can be used for managing tokens on iOS, iPadOS,
/// tvOS, visionOS, and watchOS. You can choose to use that, or use your own implementation.
/// Linux and Windows users will need to implement their own `class` or `struct` to manage
/// the tokens.
///
/// This, coupled with `UserSessionRegistry`, is the best way to manage authentication in the
/// AT Protocol.
public protocol SecureKeychainProtocol {

    /// A unique identifier for linking the instance of `UserSession` to the credentials.
    var identifier: UUID { get }

    /// Retrieves the access token of the account.
    ///
    /// When implementing this method, please be sure to save the access token in-memory.
    /// This is because the access token expires much more often than the refresh token. You can
    /// achieve this by simply creating a `private` property for the access token, then connecting
    /// the property to the method.
    ///
    /// ```swift
    /// var accessToken: String?
    ///
    /// func retrieveAccessToken() -> String? {
    ///     return self.accessToken
    /// }
    /// ```
    ///
    /// - Returns: The access token of the account.
    ///
    /// - Throws: An error if the access token doesn't exist.
    func retrieveAccessToken() throws -> String

    /// Saves the access token of the account.
    ///
    /// When implementing this method, please be sure to save the access token in-memory.
    /// This is because the access token expires much more often than the refresh token. You can
    /// achieve this by simply creating a `private` property for the access token, then connecting
    /// the property to the method.
    ///
    /// ```swift
    /// var accessToken: String?
    ///
    /// func saveAccessToken(_ accessToken: String) throws {
    ///     self.accessToken = accessToken
    /// }
    ///```
    ///
    /// - Parameter accessToken: The token used to authenticate to the service.
    func saveAccessToken(_ accessToken: String) throws

    /// Deletes the access token of the account.
    ///
    /// When implementing this method, please be sure to save the access token in-memory.
    /// This is because the access token expires much more often than the refresh token. You can
    /// achieve this by simply creating a `private` property for the access token, then connecting
    /// the property to the method.
    ///
    /// ```swift
    /// var accessToken: String?
    ///
    /// func deleteAccessToken() throws {
    ///     self.accessToken = nil
    /// }
    ///```
    func deleteAccessToken() throws

    /// Saves the password of the account to the keychain.
    ///
    /// This can be either the user's real password or the App Password.
    ///
    /// - Parameter password: The password of the account.
    func savePassword(_ password: String) throws

    /// Retrieves the password of the account from the keychain.
    ///
    /// - Returns: The password itself.
    ///
    /// - Throws: An error if the password doesn't exist.
    func retrievePassword() throws -> String

    /// Updates the password of the account into the keychain.
    ///
    /// - Parameter newPassword: The new account password.
    func updatePassword(_ newPassword: String) throws

    /// Deletes the password of the account from the keychain.
    func deletePassword() throws

    /// Saves the refresh token of the account to the keychain.
    ///
    /// - Parameter refreshToken: The refresh token of the account.
    func saveRefreshToken(_ refreshToken: String) throws

    /// Retrieves the refresh token of the account to the keychain.
    ///
    /// - Returns: The refresh token of the account.
    ///
    /// - Throws: An error if the refresh token doesn't exist.
    func retrieveRefreshToken() throws -> String

    /// Updates the refresh token of the account to the keychain.
    func updateRefreshToken(_ newRefreshToken: String) throws

    /// Deletes the refresh token of the account to the keychain.
    func deleteRefreshToken() throws
}
