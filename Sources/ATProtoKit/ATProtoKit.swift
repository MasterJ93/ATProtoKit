import Foundation
import Logging

/// Defines a protocol for configurations in the `ATProtoKit` API library.
///
/// `ATProtoKitConfiguration` defines the basic requirements for any configuration class or
/// structure within `ATProtoKit`. Any class that conforms to this protocol must be geared for
/// sending API calls to the AT Protocol. Creating a class that conforms to this is useful if you
/// have additional lexicons specific to the service you're running.
///
/// For logging-related tasks, make sure you set up the logging instide the `init()` method
/// and attach it to the `logger` property.
/// ```swift
/// public init(session: UserSession? = nil, logIdentifier: String? = nil, logCategory: String?, logLevel: Logger.Level? = .info) {
///     self.session = session
///     self.logIdentifier = logIdentifier ?? Bundle.main.bundleIdentifier ?? "com.cjrriley.ATProtoKit"
///     self.logCategory = logCategory ?? "ATProtoKit"
///     self.logLevel = logLevel
///
/// #if canImport(os)
///     LoggingSystem.bootstrap { label in
///         ATLogHandler(subsystem: label, category: logCategory ?? "ATProtoKit")
///     }
/// #else
///     LoggingSystem.bootstrap(StreamLogHandler.standardOutput)
/// #endif
///
///     logger = Logger(label: logIdentifier ?? "com.cjrriley.ATProtoKit")
///     logger.logLevel = logLevel ?? .info
/// }
/// ```
public protocol ATProtoKitConfiguration {
    /// Represents an authenticated user session within the AT Protocol. Optional.
    var session: UserSession? { get }
    /// Specifies the logger that will be used for emitting log messages.
    ///
    /// - Note: Be sure to create an instance inside the `init()` method. This is important
    var logger: Logger { get }
    /// Specifies the identifier for managing log outputs. Optional.
    ///
    /// This should default to the bundle identifier if it's in an Apple
    /// platform (`CFBundleIdentifier`).
    var logIdentifier: String? { get }
    /// Specifies the category name the logs in the logger within ATProtoKit will be in. Optional.
    var logCategory: String? { get }
    /// Specifies the highest level of logs that will be outputted. Optional.
    ///
    /// This should default to `.info`
    var logLevel: Logger.Level? { get }
    /// Prepares an authorization value for API requests based on `session` and `pdsURL`.
    ///
    /// This determines whether the "Authorization" header will be included in the request payload.
    /// It takes both `shouldAuthenticate` and `pdsURL` into account if the method has them,
    /// as well as the current session. You can use this method as-is, or customize the
    /// implementation as you see fit.
    ///
    /// - Note: Don't use this method if authorization is required or unneeded. This is only for
    /// methods where autheorization is optional.
    ///
    /// - Important:  If `pdsURL` is not `nil`, then authentication will never be considered
    /// since the session's access token wasn't created by the Personal Data Server (PDS).
    ///
    /// - Parameters:
    ///   - methodPDSURL: The URL of the Personal Data Server (PDS). Optional. Defaults to `nil`.
    ///   - shouldAuthenticate: Indicates whether the method call should be authenticated.
    ///   Defaults to `false`.
    ///   - session: The current session used in the class's instance. Optional.
    ///
    /// - Returns: A `String`, containing either `nil` if it's determined that there should be no
    /// authorization header in the request, or  `"Bearer \(accessToken)"` (where `accessToken`
    /// is the session's access token) if it's determined there should be an authorization header.
    func prepareAuthorizationValue(methodPDSURL: String?, shouldAuthenticate: Bool, session: UserSession?) -> String?
}

extension ATProtoKitConfiguration {
    /// Prepares an authorization value for API requests based on `session` and `pdsURL`.
    ///
    /// This determines whether the "Authorization" header will be included in the request payload.
    /// It takes both `shouldAuthenticate` and `pdsURL` into account if the method has them,
    /// as well as the current session.
    ///
    /// - Note: Don't use this method if authorization is required or unneeded. This is only for
    /// methods where autheorization is optional.
    ///
    /// - Important:  If `pdsURL` is not `nil`, then authentication will never be considered
    /// since the session's access token wasn't created by the Personal Data Server (PDS).
    ///
    /// - Parameters:
    ///   - methodPDSURL: The URL of the Personal Data Server (PDS). Optional. Defaults to `nil`.
    ///   - shouldAuthenticate: Indicates whether the method call should be authenticated.
    ///   Defaults to `false`.
    ///   - session: The current session used in the class's instance. Optional.
    ///
    /// - Returns: A `String`, containing either `nil` if it's determined that there should be no
    /// authorization header in the request, or  `"Bearer \(accessToken)"`
    /// (where `accessToken` is the session's access token) if it's determined there should be an
    /// authorization header.
    public func prepareAuthorizationValue(methodPDSURL: String? = nil, shouldAuthenticate: Bool = false, session: UserSession?) -> String? {
        guard methodPDSURL == nil else {
            return nil
        }

        // Proceed with authentication only if required and a session exists with a valid access token.
        if shouldAuthenticate,
           let session = session,
           !session.accessToken.isEmpty {
            return "Bearer \(session.accessToken)"
        }

        // Return nil if authentication is not needed or can't be performed.
        return nil
    }
}

/// The base class that handles the main functionality of the `ATProtoKit` API library.
///
/// For methods which require authentication using an access token, instantiating `ATProtoKit` is
/// required. To get the access token, an instance of ``ATProtocolConfiguration`` is required:
/// ```swift
/// let config = ATProtocolConfiguration(handle: "example.bsky.social", appPassword: "hunter2")
/// ```
/// ``ATProtocolConfiguration/authenticate(authenticationFactorToken:)`` should then be
/// used to get information about the session. The result is handed over to the `ATProtoKit`'s instance:
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
    /// Represents an authenticated user session within the AT Protocol. Optional.
    public let session: UserSession?
    /// An array of record lexicon structs created by Bluesky.
    ///
    /// If `canUseBlueskyRecords` is set to `false`, these will not be used.
    private let recordLexicons: [ATRecordProtocol.Type] = [
        FeedGenerator.self, FeedLike.self, FeedPost.self, FeedRepost.self, FeedThreadgate.self, GraphBlock.self, GraphFollow.self, GraphList.self, 
        GraphListBlock.self, GraphListItem.self, LabelerService.self]
    /// Specifies the logger that will be used for emitting log messages.
    public private(set) var logger: Logger
    /// Specifies the identifier for managing log outputs. Optional. Defaults to the
    /// project's `CFBundleIdentifier`.
    public let logIdentifier: String?
    /// Specifies the category name the logs in the logger within ATProtoKit will be in. Optional.
    /// Defaults to `ATProtoKit`.
    ///
    /// - Note: This property is ignored if you're using `StreamLogHandler`.
    public let logCategory: String?
    /// Specifies the highest level of logs that will be outputted. Optional. Defaults to `.info`.
    public let logLevel: Logger.Level?

    /// Initializes a new instance of `ATProtoKit`.
    /// 
    /// This will also handle some of the logging-related setup. The identifier will either be your
    /// project's `CFBundleIdentifier` or an identifier named
    /// `com.cjrriley.ATProtoKit`. However, you can manually override this.
    /// - Parameters:
    ///   - session: The authenticated user session within the AT Protocol. Optional.
    ///   - canUseBlueskyRecords: Indicates whether Bluesky's lexicons should be used.
    ///   Defaults to `true`.
    ///   - logIdentifier: Specifies the identifier for managing log outputs. Optional. Defaults
    ///   to the project's `CFBundleIdentifier`.
    ///   - logCategory: Specifies the category name the logs in the logger within ATProtoKit will
    ///   be in. Optional. Defaults to `ATProtoKit`.
    ///   - logLevel: Specifies the highest level of logs that will be outputted. Optional.
    ///   Defaults to `.info`.
    public init(session: UserSession? = nil, canUseBlueskyRecords: Bool = true, logIdentifier: String? = nil, logCategory: String? = nil,
                logLevel: Logger.Level? = .info) {
        self.session = session
        self.logIdentifier = logIdentifier ?? Bundle.main.bundleIdentifier ?? "com.cjrriley.ATProtoKit"
        self.logCategory = logCategory ?? "ATProtoKit"
        self.logLevel = logLevel

        if canUseBlueskyRecords {
            _ = ATRecordTypeRegistry(types: self.recordLexicons)
        }

        #if canImport(os)
        LoggingSystem.bootstrap { label in
            ATLogHandler(subsystem: label, category: logCategory ?? "ATProtoKit")
        }
        #else
        LoggingSystem.bootstrap(StreamLogHandler.standardOutput)
        #endif

        logger = Logger(label: logIdentifier ?? "com.cjrriley.ATProtoKit")
        logger.logLevel = logLevel ?? .info
    }

    /// Determines the appropriate Personal Data Server (PDS) URL.
    /// - Parameters:
    ///   - customPDSURL: An optional custom PDS URL. If provided, this URL is used regardless of
    ///   the access token's presence.
    /// - Returns: The final PDS URL as a `String`.
    func determinePDSURL(customPDSURL: String? = nil) -> String {
        if let customURL = customPDSURL {
            return customURL
        } else {
            return "https://api.bsky.app"
        }
    }
}

/// A class containing all administrator and moderator functionality of the `ATProtoKit`
/// API library.
///
/// `ATProtoAdmin` works similarly to the ``ATProtoKit/ATProtoKit`` class, but dedicated for
/// API calls related for administrators and moderators. More specifically,
/// API calls that work with the `com.atproto.admin.*` and `com.atproto.ozone.*` lexicons.
///
/// Instantiating `ATProtoAdmin` is required to use any of the methods. To get the access token, an
/// instance of ``ATProtocolConfiguration`` is required:
///
/// ```swift
/// let config = ATProtocolConfiguration(handle: "example.bsky.social", appPassword: "hunter2")
/// ```
/// ``ATProtocolConfiguration/authenticate(authenticationFactorToken:)`` should then be used to
/// get information about the session. The result is handed over to the `ATProtoAdmin`'s instance:
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
    /// Represents an authenticated user session within the AT Protocol. Optional.
    public let session: UserSession?
    /// Specifies the logger that will be used for emitting log messages.
    public private(set) var logger: Logger
    /// Specifies the identifier for managing log outputs. Optional. Defaults to the
    /// project's `CFBundleIdentifier`.
    public let logIdentifier: String?
    /// Specifies the category name the logs in the logger within ATProtoKit will be in.
    /// Optional. Defaults to `ATProtoKit`.
    ///
    /// - Note: This property is ignored if you're using `StreamLogHandler`.
    public let logCategory: String?
    /// Specifies the highest level of logs that will be outputted. Optional. Defaults to `.info`.
    public let logLevel: Logger.Level?

    /// Initializes a new instance of `ATProtoAdmin`.
    /// - Parameters:
    ///   - session: The authenticated user session within the AT Protocol.
    ///   - logIdentifier: Specifies the identifier for managing log outputs. Optional.
    ///   Defaults to the project's `CFBundleIdentifier`.
    ///   - logCategory: Specifies the category name the logs in the logger within ATProtoKit
    ///   will be in. Optional. Defaults to `ATProtoKit`.
    ///   - logLevel: Specifies the highest level of logs that will be outputted. Optional.
    ///   Defaults to `.info`.
    public init(session: UserSession? = nil, logIdentifier: String? = nil, logCategory: String? = nil, logLevel: Logger.Level? = .info) {
        self.session = session
        self.logIdentifier = logIdentifier ?? Bundle.main.bundleIdentifier ?? "com.cjrriley.ATProtoKit"
        self.logCategory = logCategory ?? "ATProtoKit"
        self.logLevel = logLevel

        #if canImport(os)
        LoggingSystem.bootstrap { label in
            ATLogHandler(subsystem: label, category: logCategory ?? "ATProtoKit")
        }
        #else
        LoggingSystem.bootstrap(StreamLogHandler.standardOutput)
        #endif

        logger = Logger(label: logIdentifier ?? "com.cjrriley.ATProtoKit")
        logger.logLevel = logLevel ?? .info
    }
}


