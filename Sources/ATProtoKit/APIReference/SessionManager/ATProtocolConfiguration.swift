//
//  ATProtocolConfiguration.swift
//  
//
//  Created by Christopher Jr Riley on 2024-01-06.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Manages App Password authentication and session operations for an AT Protocol account.
///
/// Use ``ATOAuthSessionConfiguration`` or another ``SessionConfiguration`` implementation when an
/// OAuth package owns authentication.
public final class ATProtocolConfiguration: AppPasswordSessionManaging {

    /// The identifier linking this configuration to its visible user session and stored values.
    public let instanceUUID: UUID

    /// The base URL of the Personal Data Server (PDS).
    public let pdsURL: String

    /// The stream that receives authentication-factor codes.
    public let codeStream: AsyncStream<String>

    /// The continuation used to supply authentication-factor codes.
    public let codeContinuation: AsyncStream<String>.Continuation

    /// The secure backend containing this session's credentials.
    public let credentialStore: ATCredentialStore

    /// The in-memory cache containing the short-lived App Password access token.
    private let accessTokenCache = AppPasswordAccessTokenCache()

    /// An instance of `URLSessionConfiguration`.
    public let configuration: URLSessionConfiguration

    /// Determines whether `ATProtocolConfiguration` will automatically resolve the handle.
    public let canResolve: Bool

#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    /// Initializes a new instance of `ATProtocolConfiguration`.
    ///
    /// - Parameters:
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `https://bsky.social`.
    ///   - credentialStore: The backend used to persist credentials. Defaults to a new
    ///     ``AppleSecureKeychain`` instance.
    ///   - sessionIdentifier: The stable identifier used to namespace this account's credentials.
    ///     Defaults to a newly generated identifier.
    ///   - configuration: The URL session configuration. Defaults to `.default`.
    ///   - canResolve: Indicates whether `ATProtocolConfiguration` will automatically resolve
    ///   the handle. Defaults to `true`.
    public init<Store: ATCredentialStore>(
        pdsURL: String = "https://bsky.social",
        credentialStore: Store = AppleSecureKeychain(),
        sessionIdentifier: UUID = UUID(),
        configuration: URLSessionConfiguration = .default,
        canResolve: Bool = true
    ) {
        self.credentialStore = credentialStore
        self.instanceUUID = sessionIdentifier
        self.pdsURL = pdsURL
        let (stream, continuation) = AsyncStream<String>.makeStream()
        self.codeStream = stream
        self.codeContinuation = continuation
        self.configuration = configuration
        self.canResolve = canResolve
    }
#else
    /// Initializes a new instance of `ATProtocolConfiguration`.
    ///
    /// - Parameters:
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `https://bsky.social`.
    ///   - credentialStore: The backend used to persist credentials.
    ///   - sessionIdentifier: The stable identifier used to namespace this account's credentials.
    ///     Defaults to a newly generated identifier.
    ///   - configuration: The URL session configuration. Defaults to `.default`.
    ///   - canResolve: Indicates whether `ATProtocolConfiguration` will automatically resolve
    ///   the handle. Defaults to `true`.
    public init<Store: ATCredentialStore>(
        pdsURL: String = "https://bsky.social",
        credentialStore: Store,
        sessionIdentifier: UUID = UUID(),
        configuration: URLSessionConfiguration = .default,
        canResolve: Bool = true
    ) {
        self.credentialStore = credentialStore
        self.instanceUUID = sessionIdentifier
        self.pdsURL = pdsURL
        let (stream, continuation) = AsyncStream<String>.makeStream()
        self.codeStream = stream
        self.codeContinuation = continuation
        self.configuration = configuration
        self.canResolve = canResolve
    }
#endif

    /// Replaces the App Password access token held in memory.
    ///
    /// - Parameter accessToken: The short-lived access token to cache.
    public func cacheAccessToken(_ accessToken: String) async {
        await accessTokenCache.save(accessToken)
    }

    /// Retrieves the App Password access token held in memory. Optional.
    ///
    /// - Returns: The cached access token, or `nil` when this configuration has not authenticated
    ///   or refreshed during its current lifetime. Optional.
    public func cachedAccessToken() async -> String? {
        return await accessTokenCache.load()
    }

    /// Removes the App Password access token held in memory.
    public func clearCachedAccessToken() async {
        await accessTokenCache.clear()
    }

//    /// Resumes a session.
//    ///  
//    /// This is useful for cases where a user is opening the app and they've already logged in.
//    /// 
//    /// While inserting the access token is optional, the refresh token is not, as it lasts much
//    /// longer than the refresh token.
//    ///
//    /// - Warning: This is an experimental method. This may be removed at a later date if
//    /// it doesn't prove to be helpful.
//    ///
//    /// If the refresh token fails for whatever reason, it's recommended to call
//    /// ``ATProtocolConfiguration/authenticate(authenticationFactorToken:)``
//    /// in the `catch` block.
//    ///
//    /// - Parameters:
//    ///   - accessToken: The access token of the session. Optional.
//    ///   - refreshToken: The refresh token of the session.
//    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `https://bsky.social`.
//    ///
//    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
//    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
//    public func resumeSession(
//        accessToken: String? = nil,
//        refreshToken: String,
//        pdsURL: String = "https://bsky.social"
//    ) async throws {
//        if let sessionToken = accessToken ?? self.session?.accessToken {
//            let expiryDate = try SessionToken(sessionToken: sessionToken).payload.expiresAt
//            let currentDate = Date()
//
//            if currentDate > expiryDate {
//                do {
//                    try await self.checkRefreshToken(refreshToken: refreshToken, pdsURL: pdsURL)
//                } catch {
//                    throw error
//                }
//            }
//
//            _ = try await ATProtoKit(
//                sessionConfiguration: self,
//                pdsURL: pdsURL,
//                canUseBlueskyRecords: false
//            ).getSession()
//        } else {
//            do {
//                try await self.checkRefreshToken(refreshToken: refreshToken)
//            } catch {
//                throw error
//            }
//        }
//    }
}

/// Stores a short-lived App Password access token for one configuration lifetime.
private actor AppPasswordAccessTokenCache {

    /// The cached access token. Optional.
    private var accessToken: String?

    /// Creates an empty access-token cache.
    fileprivate init() {}

    /// Replaces the cached access token.
    ///
    /// - Parameter accessToken: The access token to cache.
    fileprivate func save(_ accessToken: String) {
        self.accessToken = accessToken
    }

    /// Retrieves the cached access token. Optional.
    ///
    /// - Returns: The cached access token. Optional.
    fileprivate func load() -> String? {
        return accessToken
    }

    /// Removes the cached access token.
    fileprivate func clear() {
        accessToken = nil
    }
}
