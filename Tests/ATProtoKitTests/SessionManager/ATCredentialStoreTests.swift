//
//  ATCredentialStoreTests.swift
//  ATProtoKitTests
//
//  Created by Christopher Jr Riley on 2026-08-17.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Testing
@testable import ATProtoKit

@Suite("Credential storage")
internal struct ATCredentialStoreTests {

    @Test("Opaque credentials survive store reuse")
    internal func opaqueCredentialsSurviveStoreReuse() async throws {
        let store = InMemoryCredentialStore()
        let data = Data("oauth-session".utf8)

        try await store.saveValue(data, forKey: "oauth.current-session")

        #expect(try await store.loadValue(forKey: "oauth.current-session") == data)
    }

    @Test("Account namespaces remain separated")
    internal func accountNamespacesRemainSeparated() async throws {
        let store = InMemoryCredentialStore()
        let firstIdentifier = UUID()
        let secondIdentifier = UUID()

        try await store.saveValue(
            Data("first".utf8),
            forKey: "\(firstIdentifier.uuidString).refreshToken"
        )
        try await store.saveValue(
            Data("second".utf8),
            forKey: "\(secondIdentifier.uuidString).refreshToken"
        )

        #expect(
            try await store.loadValue(forKey: "\(firstIdentifier.uuidString).refreshToken")
                == Data("first".utf8)
        )
        #expect(
            try await store.loadValue(forKey: "\(secondIdentifier.uuidString).refreshToken")
                == Data("second".utf8)
        )
    }

    @Test("Configuration keeps storage and session identity separate")
    internal func configurationKeepsStorageAndSessionIdentitySeparate() {
        let identifier = UUID()
        let store = InMemoryCredentialStore()
        let configuration = ATProtocolConfiguration(
            credentialStore: store,
            sessionIdentifier: identifier
        )

        #expect(configuration.instanceUUID == identifier)
    }

    @Test("App Password access tokens remain in configuration memory")
    internal func appPasswordAccessTokensRemainInConfigurationMemory() async throws {
        let identifier = UUID()
        let store = InMemoryCredentialStore()
        let configuration = ATProtocolConfiguration(
            credentialStore: store,
            sessionIdentifier: identifier
        )

        await configuration.cacheAccessToken("access")
        try await configuration.saveRefreshTokenCredential("refresh")
        try await configuration.savePasswordCredential("password")

        #expect(await configuration.cachedAccessToken() == "access")
        #expect(try await configuration.storedRefreshToken() == "refresh")
        #expect(try await configuration.retrieveRefreshTokenCredential() == "refresh")
        #expect(try await configuration.retrievePasswordCredential() == "password")
        #expect(try await store.loadValue(forKey: "\(identifier.uuidString).accessToken") == nil)

        let restoredConfiguration = ATProtocolConfiguration(
            credentialStore: store,
            sessionIdentifier: identifier
        )
        #expect(await restoredConfiguration.cachedAccessToken() == nil)
        #expect(try await restoredConfiguration.storedRefreshToken() == "refresh")
        #expect(try await restoredConfiguration.retrieveRefreshTokenCredential() == "refresh")
        #expect(try await restoredConfiguration.retrievePasswordCredential() == "password")

        await configuration.clearCachedAccessToken()
        #expect(await configuration.cachedAccessToken() == nil)
    }

    @Test("Missing refresh token is exposed as nil")
    internal func missingRefreshTokenIsExposedAsNil() async throws {
        let configuration = ATProtocolConfiguration(
            credentialStore: InMemoryCredentialStore()
        )

        #expect(try await configuration.storedRefreshToken() == nil)
    }

    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @Test("Apple Keychain preserves a supplied service name")
    internal func appleKeychainPreservesSuppliedServiceName() {
        let serviceName = "com.example.credentials"
        let store = AppleSecureKeychain(serviceName: serviceName)

        #expect(store.serviceName == serviceName)
    }
    #endif
}
