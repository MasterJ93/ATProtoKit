//
//  AppleSecureKeychain.swift
//
//
//  Created by Christopher Jr Riley on 2025-03-01.
//

import Foundation

#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
import Security

/// Stores opaque credential values in Apple Keychain.
///
/// Use this type as the default ``ATCredentialStore`` on Apple platforms.
public actor AppleSecureKeychain: ATCredentialStore {

    /// The identifier used by the deprecated App Password storage interface.
    ///
    /// New code supplies its account identifier to ``ATProtocolConfiguration`` instead.
    public nonisolated let identifier: UUID

    /// The Keychain service name used to namespace stored values.
    public nonisolated let serviceName: String

    /// Creates an Apple Keychain-backed secure store.
    ///
    /// - Parameters:
    ///   - identifier: The identifier used by the deprecated App Password storage interface.
    ///     Defaults to a newly generated identifier.
    ///   - serviceName: The Keychain service name. Defaults to `ATProtoKit`.
    public init(
        identifier: UUID = UUID(),
        serviceName: String = "ATProtoKit"
    ) {
        self.identifier = identifier
        self.serviceName = serviceName
    }

    /// Loads data associated with a Keychain account key.
    ///
    /// - Parameter key: The Keychain account key.
    /// - Returns: The stored data, or `nil` when no value exists. Optional.
    ///
    /// - Throws: ``ApplSecureKeychainError/unhandledStatus(status:)`` when Keychain fails.
    public func loadValue(forKey key: String) async throws -> Data? {
        let query: [CFString: CFTypeRef] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key as CFString,
            kSecAttrService: serviceName as CFString,
            kSecReturnData: kCFBooleanTrue,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        if status == errSecItemNotFound {
            return nil
        }
        guard status == errSecSuccess else {
            throw ApplSecureKeychainError.unhandledStatus(status: status)
        }
        guard let data = item as? Data else {
            throw ApplSecureKeychainError.invalidData
        }

        return data
    }

    /// Saves or replaces data under a Keychain account key.
    ///
    /// Values use an after-first-unlock, device-only accessibility policy so background refresh can
    /// read credentials without allowing them to migrate through backups or synchronized Keychain.
    ///
    /// - Parameters:
    ///   - value: The data to persist.
    ///   - key: The Keychain account key.
    ///
    /// - Throws: ``ApplSecureKeychainError/unhandledStatus(status:)`` when Keychain fails.
    public func saveValue(_ value: Data, forKey key: String) async throws {
        let query: [CFString: CFTypeRef] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key as CFString,
            kSecAttrService: serviceName as CFString
        ]
        let updateAttributes: [CFString: CFTypeRef] = [
            kSecValueData: value as CFData,
            kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        ]
        let updateStatus = SecItemUpdate(
            query as CFDictionary,
            updateAttributes as CFDictionary
        )

        if updateStatus == errSecSuccess {
            return
        }
        guard updateStatus == errSecItemNotFound else {
            throw ApplSecureKeychainError.unhandledStatus(status: updateStatus)
        }

        var insertionQuery = query
        insertionQuery[kSecValueData] = value as CFData
        insertionQuery[kSecAttrAccessible] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        let insertionStatus = SecItemAdd(insertionQuery as CFDictionary, nil)
        guard insertionStatus == errSecSuccess else {
            throw ApplSecureKeychainError.unhandledStatus(status: insertionStatus)
        }
    }

    /// Deletes data associated with a Keychain account key.
    ///
    /// - Parameter key: The Keychain account key.
    ///
    /// - Throws: ``ApplSecureKeychainError/unhandledStatus(status:)`` when Keychain fails.
    public func deleteValue(forKey key: String) async throws {
        let query: [CFString: CFTypeRef] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key as CFString,
            kSecAttrService: serviceName as CFString
        ]
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw ApplSecureKeychainError.unhandledStatus(status: status)
        }
    }

    /// Saves or updates a UTF-8 string in Keychain.
    ///
    /// - Parameters:
    ///   - value: The string to persist.
    ///   - key: The Keychain account key.
    ///
    /// - Throws: An error from Keychain.
    public func saveOrUpdateItem(_ value: String, forKey key: String) async throws {
        try await saveValue(Data(value.utf8), forKey: key)
    }

    /// Reads a UTF-8 string from Keychain.
    ///
    /// - Parameter key: The Keychain account key.
    /// - Returns: The stored string.
    ///
    /// - Throws: ``ApplSecureKeychainError`` when the item is missing, invalid, or inaccessible.
    public func readItem(forKey key: String) async throws -> String {
        guard let data = try await loadValue(forKey: key) else {
            throw ApplSecureKeychainError.itemNotFound(key: key)
        }
        guard let value = String(data: data, encoding: .utf8) else {
            throw ApplSecureKeychainError.invalidData
        }

        return value
    }

    /// Deletes a Keychain item.
    ///
    /// - Parameter key: The Keychain account key.
    ///
    /// - Throws: An error from Keychain.
    public func deleteItem(forKey key: String) async throws {
        try await deleteValue(forKey: key)
    }
}

@available(*, deprecated, message: "Use AppleSecureKeychain through ATCredentialStore instead.")
extension AppleSecureKeychain: SecureKeychainProtocol {}

/// Errors related to Apple Keychain storage.
public enum ApplSecureKeychainError: Error, LocalizedError {

    /// The Keychain item was not found.
    ///
    /// - Parameter key: The key for the item.
    case itemNotFound(key: String)

    /// The access token could not be found.
    case accessTokenNotFound

    /// The retrieved value was invalid.
    case invalidData

    /// Keychain returned an unsuccessful status.
    ///
    /// - Parameter status: The Security framework status code.
    case unhandledStatus(status: OSStatus)

    public var errorDescription: String? {
        switch self {
        case .itemNotFound(let key):
            return "No item was found for key: \(key)"
        case .accessTokenNotFound:
            return "No access token was found."
        case .invalidData:
            return "The data retrieved from Keychain was invalid."
        case .unhandledStatus(let status):
            return "The Keychain operation failed with status: \(status)"
        }
    }
}
#endif
