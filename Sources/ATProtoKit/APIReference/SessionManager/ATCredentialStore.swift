//
//  ATCredentialStore.swift
//  ATProtoKit
//

import Foundation

/// A low-level protocol for storing opaque credential data in a secure, persistent backend.
///
/// This is the common storage boundary for both App Password and OAuth sessions. ATProtoKit uses
/// it to persist the App Password and refresh token, while keeping the short-lived access token
/// in-memory (via ``ATProtocolConfiguration``). An application can use the same store for an OAuth
/// sessionby encoding the OAuth library's complete restorable session and assigning it a
/// separate key.
///
/// The protocol deliberately does not define token types, lifecycle behaviors, or a session
/// identifier. Callers own their value format and key namespace, while the conforming store owns
/// secure persistence.
///
/// ## Conforming types
///
/// ATProtoKit includes one public conforming type: ``AppleSecureKeychain``. It stores each value
/// as a generic-password item in Apple Keychain and is available on iOS, iPadOS, macOS, tvOS,
/// visionOS, and watchOS. `ATProtocolConfiguration` consumes a store but does not itself conform
/// to this protocol.
/// 
/// - Note: ATProtoKit does not include a Linux or Windows backend because the application must
/// choose the protected credential service appropriate to its deployment environment.
///
/// A custom backend implements only the three opaque-data operations. It does not need separate
/// App Password methods, access token caching, or OAuth token knowledge:
///
/// ```swift
/// public actor ApplicationCredentialStore: ATCredentialStore {
///     private let protectedVault: ApplicationProtectedVault
///
///     public init(protectedVault: ApplicationProtectedVault) {
///         self.protectedVault = protectedVault
///     }
///
///     public func loadValue(forKey key: String) async throws -> Data? {
///         return try await protectedVault.loadValue(forKey: key)
///     }
///
///     public func saveValue(_ value: Data, forKey key: String) async throws {
///         try await protectedVault.saveValue(value, forKey: key)
///     }
///
///     public func deleteValue(forKey key: String) async throws {
///         try await protectedVault.deleteValue(forKey: key)
///     }
/// }
/// ```
///
/// ```swift
/// let store = AppleSecureKeychain(serviceName: "com.example.application.credentials")
/// let sessionData = try JSONEncoder().encode(oauthSession)
///
/// try await store.saveValue(sessionData, forKey: "oauth.current-session")
///
/// if let restoredData = try await store.loadValue(forKey: "oauth.current-session") {
///     let restoredSession = try JSONDecoder().decode(
///         OAuthSession.self,
///         from: restoredData
///     )
///     // Revalidate the restored session before using it.
/// }
/// ```
///
/// To use a custom store for an App Password session, pass it directly to
/// ``ATProtocolConfiguration``:
///
/// ```swift
/// let configuration = ATProtocolConfiguration(
///     credentialStore: applicationCredentialStore,
///     sessionIdentifier: persistedAccountIdentifier
/// )
/// ```
public protocol ATCredentialStore: Sendable {

    /// Loads data associated with a storage key. Optional.
    ///
    /// - Parameter key: The key identifying the stored value.
    /// - Returns: The stored data, or `nil` when no value exists. Optional.
    ///
    /// - Throws: An error when the secure storage operation fails.
    func loadValue(forKey key: String) async throws -> Data?

    /// Saves or replaces data under a storage key.
    ///
    /// - Parameters:
    ///   - value: The opaque data to save.
    ///   - key: The key identifying the stored value.
    ///
    /// - Throws: An error when the secure storage operation fails.
    func saveValue(_ value: Data, forKey key: String) async throws

    /// Deletes data associated with a storage key.
    ///
    /// Implementations should treat a missing value as already deleted.
    ///
    /// - Parameter key: The key identifying the stored value.
    ///
    /// - Throws: An error when the secure storage operation fails.
    func deleteValue(forKey key: String) async throws
}
