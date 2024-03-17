import Foundation

/// Defines a protocol for configurations in the `ATProtoKit` API library.
///
/// `ATProtoKitConfiguration` defines the basic requirements for any configuration class or structure
/// within `ATProtoKit`. Any class that conforms to this protocol must be geared for sending API calls to the AT Protocol. Creating a class
/// that conforms to this is useful if you have additional lexicons specific to the service you're running.
public protocol ATProtoKitConfiguration {
    /// Represents an authenticated user session within the AT Protocol.
    var session: UserSession { get }
}

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
public class ATProtoKit: ATProtoKitConfiguration {
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

/// A class containing all administrator and moderator functionality of the `ATProtoKit` API library.
///
/// `ATProtoAdmin` works similarly to the ``ATProtoKit/ATProtoKit`` class, but dedicated for API calls related for administrators and moderators. More specifically, API calls that
/// work with the `com.atproto.admin.*` and `com.atproto.ozone.*` lexicons.
///
/// Instantiating `ATProtoAdmin` is required to use any of the methods. To get the access token, an instance of ``ATProtocolConfiguration`` is required:
///
/// ```swift
/// let config = ATProtocolConfiguration(handle: "example.bsky.social", appPassword: "hunter2")
/// ```
/// ``ATProtocolConfiguration/authenticate()`` should then be used to get information about the session. The result is handed over to the `ATProtoAdmin`'s instance:
///
///```swift
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
public class ATProtoAdmin: ATProtoKitConfiguration {
    /// Represents an authenticated user session within the AT Protocol.
    public let session: UserSession

    /// Initializes a new instance of `ATProtoAdmin`.
    /// - Parameters:
    ///   - session: The authenticated user session within the AT Protocol.
    public init(session: UserSession) {
        self.session = session
    }
}


