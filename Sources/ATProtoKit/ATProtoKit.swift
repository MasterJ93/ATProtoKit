import Foundation

/// The base class that handles the main functionality of the `ATProtoKit` API library.
///
/// For methods which require authentication using an access token, instantiating `ATProtoKit` is required. To get the access token,
/// an instance of ``ATProtocolConfiguration`` is required:
///
/// ```swift
/// let config = ATProtocolConfiguration(handle: "example.bsky.social", appPassword: "hunter2")
/// ```
/// ``ATProtocolConfiguration/authenticate()`` should then be used to get information about the session. The result is handed over to the `ATProtoKit`'s instance:
///
/// ```swift
/// Task {
///     let result = try await config.authenticate()
///
///     switch result {
///         case .success(let result):
///             print("Access token: \(result.accessToken)")
///         case .failure(let error):
///             print("Error: \(error)")
///     }
/// }
/// ```
public class ATProtoKit {
    /// Represents an authenticated user session within the AT Protocol.
    public let session: UserSession

    /// Initializes a new instance of `ATProtoKit`.
    /// - Parameters:
    ///   - session: The authenticated user session within the AT Protocol.
    public init(session: UserSession) {
        self.session = session
    }

    /// Determines the appropriate Personal Data Server (PDS) URL.
    /// - Parameters:
    ///   - accessToken: The access token for authenticated requests. If `nil` or empty, defaults to unauthenticated URL.
    ///   - customPDSURL: An optional custom PDS URL. If provided, this URL is used regardless of the access token's presence.
    /// - Returns: The final PDS URL as a `String`.
    static func determinePDSURL(accessToken: String? = nil, customPDSURL: String? = nil) -> String {
        if let customURL = customPDSURL {
            return customURL
        } else if let token = accessToken, !token.isEmpty {
            return "https://bsky.social"
        } else {
            return "https://api.bsky.app"
        }
    }
}
