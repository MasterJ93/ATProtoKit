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
            forKey: "\(firstIdentifier.uuidString).accessToken"
        )
        try await store.saveValue(
            Data("second".utf8),
            forKey: "\(secondIdentifier.uuidString).accessToken"
        )

        #expect(
            try await store.loadValue(forKey: "\(firstIdentifier.uuidString).accessToken")
                == Data("first".utf8)
        )
        #expect(
            try await store.loadValue(forKey: "\(secondIdentifier.uuidString).accessToken")
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

    @Test("App Password credentials use the canonical store")
    internal func appPasswordCredentialsUseCanonicalStore() async throws {
        let identifier = UUID()
        let store = InMemoryCredentialStore()
        let configuration = CredentialConfiguration(
            credentialStore: store,
            instanceUUID: identifier
        )

        try await configuration.saveAccessTokenCredential("access")
        try await configuration.saveRefreshTokenCredential("refresh")
        try await configuration.savePasswordCredential("password")

        #expect(try await configuration.retrieveAccessTokenCredential() == "access")
        #expect(try await configuration.retrieveRefreshTokenCredential() == "refresh")
        #expect(try await configuration.retrievePasswordCredential() == "password")
        #expect(
            try await store.loadValue(forKey: "\(identifier.uuidString).accessToken")
                == Data("access".utf8)
        )
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

private actor InMemoryCredentialStore: ATCredentialStore {

    private var values: [String: Data] = [:]

    fileprivate func loadValue(forKey key: String) async throws -> Data? {
        return values[key]
    }

    fileprivate func saveValue(_ value: Data, forKey key: String) async throws {
        values[key] = value
    }

    fileprivate func deleteValue(forKey key: String) async throws {
        values[key] = nil
    }
}

private final class CredentialConfiguration: AppPasswordCredentialStoring {
    fileprivate let credentialStore: ATCredentialStore
    fileprivate let pdsURL = "https://bsky.social"
    fileprivate let configuration = URLSessionConfiguration.ephemeral
    fileprivate let instanceUUID: UUID

    fileprivate init(credentialStore: ATCredentialStore, instanceUUID: UUID) {
        self.credentialStore = credentialStore
        self.instanceUUID = instanceUUID
    }

    fileprivate func authorization(for request: URLRequest) async throws -> SessionAuthorization? {
        return nil
    }
}
