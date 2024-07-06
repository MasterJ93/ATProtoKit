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
///     self.logger = session?.logger ?? logger
/// }
/// ```
public protocol ATProtoKitConfiguration {

    /// Represents an authenticated user session within the AT Protocol. Optional.
    var session: UserSession? { get }

    /// Specifies the logger that will be used for emitting log messages. Optional.
    ///
    /// - Note: Be sure to create an instance inside the `init()` method. This is important so
    /// all log events are spread across the entire class.
    var logger: Logger? { get }

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
///     do {
///         let session = try await config.authenticate()
///
///         print("Access token: \(session.accessToken)")
///     } catch {
///         print("Error: \(error)")
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
        AppBskyLexicon.Feed.GeneratorRecord.self, AppBskyLexicon.Feed.LikeRecord.self, AppBskyLexicon.Feed.PostRecord.self,
        AppBskyLexicon.Feed.RepostRecord.self, AppBskyLexicon.Feed.ThreadgateRecord.self, AppBskyLexicon.Graph.BlockRecord.self,
        AppBskyLexicon.Graph.FollowRecord.self, AppBskyLexicon.Graph.ListRecord.self, AppBskyLexicon.Graph.ListBlockRecord.self,
        AppBskyLexicon.Graph.ListItemRecord.self, AppBskyLexicon.Graph.StarterpackRecord.self, AppBskyLexicon.Labeler.ServiceRecord.self,
        ChatBskyLexicon.Actor.DeclarationRecord.self]

    /// Specifies the logger that will be used for emitting log messages.
    public private(set) var logger: Logger?

    /// Initializes a new instance of `ATProtoKit`.
    /// 
    /// This will also handle some of the logging-related setup. The identifier will either be your
    /// project's `CFBundleIdentifier` or an identifier named
    /// `com.cjrriley.ATProtoKit`. However, you can manually override this.
    /// 
    /// - Parameters:
    ///   - session: The authenticated user session within the AT Protocol. Optional.
    ///   - canUseBlueskyRecords: Indicates whether Bluesky's lexicons should be used.
    ///   Defaults to `true`.
    ///   - logger: Specifies the identifier for managing log outputs. Optional. Defaults
    ///   to the project's `CFBundleIdentifier`.
    public init(session: UserSession? = nil, canUseBlueskyRecords: Bool = true, logger: Logger? = nil) {
        self.session = session
        self.logger = session?.logger ?? logger

        if canUseBlueskyRecords && !ATRecordTypeRegistry.areBlueskyRecordsRegistered {
            _ = ATRecordTypeRegistry(types: self.recordLexicons)
            ATRecordTypeRegistry.areBlueskyRecordsRegistered = false
        }
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
///     do {
///         let session = try await config.authenticate()
///
///         print("Access token: \(session.accessToken)")
///     } catch {
///         print("Error: \(error)")
///     }
/// }
/// ```
public class ATProtoAdmin: ATProtoKitConfiguration {

    /// Represents an authenticated user session within the AT Protocol. Optional.
    public let session: UserSession?

    /// Specifies the logger that will be used for emitting log messages.
    public private(set) var logger: Logger?

    /// Initializes a new instance of `ATProtoAdmin`.
    /// - Parameters:
    ///   - session: The authenticated user session within the AT Protocol.
    ///   - logger: Specifies the identifier for managing log outputs. Optional.
    ///   Defaults to the project's `CFBundleIdentifier`.
    public init(session: UserSession? = nil, logger: Logger? = nil) {
        self.session = session
        self.logger = session?.logger ?? logger
    }
}

/// The base class that handles all direct Bluesky-related functionality of the ATProtoKit
/// API library.
///
/// This class requires you to first create an instance of ``ATProtoKit/ATProtoKit``. The class
/// will import the session, Bluesky records, and logging information from the instance.
///
/// With some exceptions, the main functionality includes adding, putting, and deleting a record.
public class ATProtoBluesky: ATProtoKitConfiguration {
    
    /// Represents an authenticated user session within the AT Protocol. Optional.
    public private(set) var session: UserSession?

    /// Specifies the logger that will be used for emitting log messages.
    public private(set) var logger: Logger?

    /// Represents the instance of ``ATProtoKit/ATProtoKit``.
    private let atProtoKitInstance: ATProtoKit

    /// Initializes a new instance of `ATProtoBluesky`.
    /// - Parameters:
    ///   - atProtoKitInstance: Represents the instance of ``ATProtoKit/ATProtoKit``.
    ///   - logger: Specifies the identifier for managing log outputs. Optional.
    ///   Defaults to the project's `CFBundleIdentifier`.
    public init(atProtoKitInstance: ATProtoKit, logger: Logger? = nil) {
        self.atProtoKitInstance = atProtoKitInstance
        self.session = self.atProtoKitInstance.session ?? nil
        self.logger = self.atProtoKitInstance.session?.logger ?? logger
    }
}

/// The base class that handles the the Bluesky chat functionality of the ATProtoKit API library.
///
/// This class requires you to first create an instance of ``ATProtoKit/ATProtoKit``. The class
/// will import the session, Bluesky records, and logging information from the instance.
///
/// - Important: Please use an App Password in ``ATProtocolConfiguration`` that has chatting
/// privileges. Failure to do so will result in an error.
public class ATProtoBlueskyChat: ATProtoKitConfiguration {

    /// Represents an authenticated user session within the AT Protocol. Optional.
    public private(set) var session: UserSession?

    /// Specifies the logger that will be used for emitting log messages.
    public private(set) var logger: Logger?

    /// Represents the instance of ``ATProtoKit/ATProtoKit``.
    private let atProtoKitInstance: ATProtoKit

    /// Initializes a new instance of `ATProtoBlueskyChat`.
    /// - Parameters:
    ///   - atProtoKitInstance: Represents the instance of ``ATProtoKit/ATProtoKit``.
    ///   - logger: Specifies the identifier for managing log outputs. Optional.
    ///   Defaults to the project's `CFBundleIdentifier`.
    public init(atProtoKitInstance: ATProtoKit, logger: Logger? = nil) {
        self.atProtoKitInstance = atProtoKitInstance
        self.session = self.atProtoKitInstance.session ?? nil
        self.logger = self.atProtoKitInstance.session?.logger ?? logger
    }
}
