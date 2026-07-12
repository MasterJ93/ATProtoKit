//
//  OAuthAuthorizationPresentation.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2026-07-01.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
#if canImport(AuthenticationServices)
import AuthenticationServices
#endif

/// Presents an OAuth authorization URL and returns the redirect URL that completes the flow.
public protocol OAuthAuthorizationPresenting: Sendable {

    /// Presents an authorization URL and waits for the callback URL.
    ///
    /// - Parameters:
    ///   - authorizationURL: The URL the user should authorize in a browser or browser-like surface.
    ///   - callbackURLScheme: The URL scheme expected in the authorization callback.
    /// - Returns: The callback URL returned by the authorization server.
    ///
    /// - Throws: An error if the authorization surface fails or the callback cannot be received.
    func callbackURL(
        for authorizationURL: URL,
        callbackURLScheme: String
    ) async throws -> URL
}

/// Presents OAuth authorization URLs using a caller-provided browser-opening closure.
///
/// Use this presenter on platforms where AuthenticationServices is unavailable, or when your app
/// needs to own the browser, command-line, or server-side callback handling.
final public class CallbackURLAuthorizationPresenter: OAuthAuthorizationPresenting {

    /// Opens the authorization URL in the platform's browser or equivalent authorization surface.
    public let openAuthorizationURL: @Sendable (URL) async throws -> Void

    private let callbackStream: AsyncStream<URL>
    private let callbackContinuation: AsyncStream<URL>.Continuation

    /// Initializes a callback-driven authorization presenter.
    ///
    /// - Parameter openAuthorizationURL: A closure that opens the authorization URL.
    public init(openAuthorizationURL: @escaping @Sendable (URL) async throws -> Void) {
        self.openAuthorizationURL = openAuthorizationURL

        let (stream, continuation) = AsyncStream<URL>.makeStream(bufferingPolicy: .bufferingNewest(1))
        self.callbackStream = stream
        self.callbackContinuation = continuation
    }

    /// Sends a callback URL to the presenter after the app receives it.
    ///
    /// - Parameter callbackURL: The callback URL received from the authorization server.
    public func receiveCallbackURL(_ callbackURL: URL) {
        callbackContinuation.yield(callbackURL)
    }

    /// Opens an authorization URL and waits for a matching callback URL.
    ///
    /// - Parameters:
    ///   - authorizationURL: The URL the user should authorize in a browser or browser-like surface.
    ///   - callbackURLScheme: The URL scheme expected in the authorization callback.
    /// - Returns: The callback URL returned by the authorization server.
    ///
    /// - Throws: An error if the browser-opening closure fails.
    public func callbackURL(
        for authorizationURL: URL,
        callbackURLScheme: String
    ) async throws -> URL {
        try await openAuthorizationURL(authorizationURL)

        var iterator = callbackStream.makeAsyncIterator()
        while let callbackURL = await iterator.next() {
            if callbackURL.scheme == callbackURLScheme {
                return callbackURL
            }
        }

        throw OAuthAuthorizationPresentationError.callbackStreamEnded
    }
}

#if canImport(AuthenticationServices)
/// Presents OAuth authorization URLs with Apple's `ASWebAuthenticationSession`.
final public class AppleOAuthAuthorizationPresenter: OAuthAuthorizationPresenting {

    /// Indicates whether the authorization session should avoid the user's persistent browser data.
    /// Defaults to `false`.
    public let prefersEphemeralWebBrowserSession: Bool

    /// Supplies the window used to present the authorization interface.
    public let presentationAnchorProvider: @MainActor @Sendable () -> ASPresentationAnchor

    /// Initializes an Apple authentication-services presenter.
    ///
    /// - Parameters:
    ///   - prefersEphemeralWebBrowserSession: Indicates whether the authorization session should
    ///   avoid the user's persistent browser data. Defaults to `false`.
    ///   - presentationAnchorProvider: Supplies the window used to present the authorization
    ///   interface. Defaults to a new platform presentation anchor.
    public init(
        prefersEphemeralWebBrowserSession: Bool = false,
        presentationAnchorProvider: @escaping @MainActor @Sendable () -> ASPresentationAnchor = {
            ASPresentationAnchor()
        }
    ) {
        self.prefersEphemeralWebBrowserSession = prefersEphemeralWebBrowserSession
        self.presentationAnchorProvider = presentationAnchorProvider
    }

    /// Opens an authorization URL with `ASWebAuthenticationSession`.
    ///
    /// - Parameters:
    ///   - authorizationURL: The URL the user should authorize in `ASWebAuthenticationSession`.
    ///   - callbackURLScheme: The URL scheme expected in the authorization callback.
    /// - Returns: The callback URL returned by the authorization server.
    ///
    /// - Throws: An error if `ASWebAuthenticationSession` fails or returns no callback URL.
    public func callbackURL(
        for authorizationURL: URL,
        callbackURLScheme: String
    ) async throws -> URL {
        try await Self.beginAuthenticationSession(
            authorizationURL: authorizationURL,
            callbackURLScheme: callbackURLScheme,
            prefersEphemeralWebBrowserSession: prefersEphemeralWebBrowserSession,
            presentationAnchorProvider: presentationAnchorProvider
        )
    }

    @MainActor
    private static func beginAuthenticationSession(
        authorizationURL: URL,
        callbackURLScheme: String,
        prefersEphemeralWebBrowserSession: Bool,
        presentationAnchorProvider: @escaping @MainActor @Sendable () -> ASPresentationAnchor
    ) async throws -> URL {
        try await withCheckedThrowingContinuation { continuation in
            let contextProvider = AppleOAuthPresentationContextProvider(
                presentationAnchorProvider: presentationAnchorProvider
            )
            let session = ASWebAuthenticationSession(
                url: authorizationURL,
                callbackURLScheme: callbackURLScheme
            ) { callbackURL, error in
                _ = contextProvider
                if let error {
                    continuation.resume(throwing: error)
                    return
                }

                guard let callbackURL else {
                    continuation.resume(throwing: OAuthAuthorizationPresentationError.missingCallbackURL)
                    return
                }

                continuation.resume(returning: callbackURL)
            }

#if os(iOS) || os(macOS) || os(visionOS)
            if #available(iOS 13.0, macOS 10.15, visionOS 1.0, *) {
                session.prefersEphemeralWebBrowserSession = prefersEphemeralWebBrowserSession
            }
#endif

            session.presentationContextProvider = contextProvider
            session.start()
        }
    }
}

/// Supplies the presentation anchor retained for the lifetime of an Apple authorization session.
@MainActor
private final class AppleOAuthPresentationContextProvider: NSObject,
    ASWebAuthenticationPresentationContextProviding {

    /// Supplies the window used to present the authorization interface.
    private let presentationAnchorProvider: @MainActor @Sendable () -> ASPresentationAnchor

    /// Creates a presentation context provider.
    ///
    /// - Parameter presentationAnchorProvider: Supplies the window used to present the authorization
    ///   interface.
    public init(presentationAnchorProvider: @escaping @MainActor @Sendable () -> ASPresentationAnchor) {
        self.presentationAnchorProvider = presentationAnchorProvider
    }

    /// Returns the window used to present an authorization session.
    ///
    /// - Parameter session: The authorization session requesting a presentation window.
    /// - Returns: The window used to present the authorization interface.
    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return presentationAnchorProvider()
    }
}
#endif

/// Errors thrown while presenting OAuth authorization URLs.
public enum OAuthAuthorizationPresentationError: ATProtoError {

    /// The callback stream ended before a matching callback URL was received.
    case callbackStreamEnded

    /// The authorization session completed without a callback URL.
    case missingCallbackURL
}
