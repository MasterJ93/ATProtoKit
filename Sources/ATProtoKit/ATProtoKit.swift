import Foundation
import Logging

/// Defines a protocol for configurations in the `ATProtoKit` API library.
///
/// `ATProtoKitConfiguration` defines the basic requirements for any class that may hold
/// exicon methods.  Any class that conforms to this protocol must be geared for sending API calls
/// to the AT Protocol. Creating a class that conforms to this is useful if you have additional
/// lexicons specific to the service you're running.
///
/// For logging-related tasks, make sure you set up the logging instide the `init()` method
/// and attach it to the `logger` property.
/// ```swift
/// public init(sessionConfiguration: SessionConfiguration? = nil, logIdentifier: String? = nil, logCategory: String?, logLevel: Logger.Level? = .info) {
///     self.logger = session?.logger ?? logger
/// }
/// ```
public protocol ATProtoKitConfiguration {

    /// Represents an object used for managing sessions.
    var sessionConfiguration: SessionConfiguration? { get }

    /// Represents an authenticated user session within the AT Protocol. Optional.
    ///
    /// This would be received by the ``ATProtoKitConfiguration/sessionConfiguration`` object.
    /// Make this property a computed property when adding this to your class.
    ///
    /// ```swift
    /// public var session: UserSession? {
    ///     return sessionConfiguration.session
    /// }
    /// ```
    var session: UserSession? { get }

    /// Specifies the logger that will be used for emitting log messages. Optional.
    ///
    /// - Note: Be sure to create an instance inside the `init()` method. This is important so
    /// all log events are spread across the entire class.
    var logger: Logger? { get }

    /// Prepares an authorization value for API requests based on `session`.
    ///
    /// This determines whether the "Authorization" header will be included in the request payload.
    /// It takes `shouldAuthenticate` into account if the method has them, as well as the
    /// current session. You can use this method as-is, or customize the implementation as you
    /// see fit.
    ///
    /// - Note: Don't use this method if authorization is required or unneeded. This is only for
    /// methods where authorization is optional.
    ///
    /// - Parameters:
    ///   - shouldAuthenticate: Indicates whether the method call should be authenticated.
    ///   Defaults to `false`.
    ///   - keychain: The instance of `KeychainProtocol`. Optional.
    ///
    /// - Returns: A `String`, containing either `nil` if it's determined that there should be no
    /// authorization header in the request, or  `"Bearer \(accessToken)"` (where `accessToken`
    /// is the session's access token) if it's determined there should be an authorization header.
    func prepareAuthorizationValue(shouldAuthenticate: Bool, keychain: SessionKeychainProtocol?) async -> String?

    /// Determines the appropriate Personal Data Server (PDS) URL.
    ///
    /// - Parameters:
    ///   - customPDSURL: An optional custom PDS URL. If provided, this URL is used regardless of
    ///   the access token's presence.
    /// - Returns: The final PDS URL as a `String`.
    static func determinePDSURL(customPDSURL: String) -> String
}

extension ATProtoKitConfiguration {

    /// Prepares an authorization value for API requests based on `session` and `pdsURL`.
    ///
    /// This determines whether the "Authorization" header will be included in the request payload.
    /// It takes `shouldAuthenticate` into account if the method has them, as well as the
    /// current session.
    ///
    /// - Note: Don't use this method if authorization is required or unneeded. This is only for
    /// methods where authorization is optional.
    ///
    /// - Parameters:
    ///   - shouldAuthenticate: Indicates whether the method call should be authenticated.
    ///   Defaults to `false`.
    ///   - keychain: The instance of `KeychainProtocol`. Optional.
    ///
    /// - Returns: A `String`, containing either `nil` if it's determined that there should be no
    /// authorization header in the request, or  `"Bearer \(accessToken)"`
    /// (where `accessToken` is the session's access token) if it's determined there should be an
    /// authorization header.
    public func prepareAuthorizationValue(shouldAuthenticate: Bool = false, keychain: SessionKeychainProtocol?) async -> String? {
        // If `shouldAuthenticate` is false, return nil regardless of session state.
        guard shouldAuthenticate else {
            return nil
        }

        // If `shouldAuthenticate` is true, check if the session exists and has a valid access token.
        if let sessionConfiguration = sessionConfiguration {
            do {
                let keychain = try sessionConfiguration.keychainProtocol.retrieveAccessToken()
                return "Bearer \(keychain)"
            } catch {
                return nil
            }
        }

        // Return nil if no valid session or access token is found.
        return nil
    }

    /// Determines the appropriate Personal Data Server (PDS) URL.
    ///
    /// - Parameters:
    ///   - customPDSURL: An optional custom PDS URL. If provided, this URL is used regardless of
    ///   the access token's presence.
    /// - Returns: The final PDS URL as a `String`.
    public static func determinePDSURL(customPDSURL: String) -> String {
        if customPDSURL != "" {
            return customPDSURL
        } else {
            return "https://api.bsky.app"
        }
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
///         try await config.authenticate()
///
///         print("Access token: \(session.accessToken)")
///
///         let atProtoKit = await ATProtoKit(sessionConfiguration: config)
///     } catch {
///         print("Error: \(error)")
///     }
/// }
/// ```
public class ATProtoKit: ATProtoKitConfiguration, ATRecordConfiguration {

    /// An array of record lexicon structs created by Bluesky.
    ///
    /// If `canUseBlueskyRecords` is set to `false`, these will not be used.
    public let recordLexicons: [any ATRecordProtocol.Type] = [
        AppBskyLexicon.Actor.ProfileRecord.self, AppBskyLexicon.Feed.GeneratorRecord.self, AppBskyLexicon.Feed.LikeRecord.self,
        AppBskyLexicon.Feed.PostRecord.self, AppBskyLexicon.Feed.PostgateRecord.self, AppBskyLexicon.Feed.RepostRecord.self,
        AppBskyLexicon.Feed.ThreadgateRecord.self, AppBskyLexicon.Graph.BlockRecord.self, AppBskyLexicon.Graph.FollowRecord.self,
        AppBskyLexicon.Graph.ListRecord.self, AppBskyLexicon.Graph.ListBlockRecord.self, AppBskyLexicon.Graph.ListItemRecord.self,
        AppBskyLexicon.Graph.StarterpackRecord.self, AppBskyLexicon.Labeler.ServiceRecord.self, ChatBskyLexicon.Actor.DeclarationRecord.self
    ]

    /// Specifies the logger that will be used for emitting log messages.
    public private(set) var logger: Logger?

    /// Internal state to track initialization completion.
    public var initializationTask: Task<Void, Error>?

    /// Represents an object used for managing sessions.
    public let sessionConfiguration: SessionConfiguration?

    /// The URL of the Personal Data Server (PDS).
    public let pdsURL: String

    /// Represents an authenticated user session within the AT Protocol. Optional.
    public var session: UserSession? {
        return sessionConfiguration?.session
    }

    /// Initializes a new instance of `ATProtoKit`.
    /// 
    /// This will also handle some of the logging-related setup. The identifier will either be your
    /// project's `CFBundleIdentifier` or an identifier named
    /// `com.cjrriley.ATProtoKit`. However, you can manually override this.
    ///
    /// If you're using methods such as
    /// ``ATProtoKit/ATProtoKit/createAccount(email:handle:existingDID:inviteCode:verificationCode:verificationPhone:password:recoveryKey:plcOperation:)``
    /// or ``ATProtoKit/ATProtoKit/getSession(by:)``, be sure to set
    /// `canUseBlueskyRecords` to false. While the initializer does check to see if the records
    /// have been added, it's best not to invoke it, esepcially if you're using ATProtoKit for a
    /// generic AT Protocol service that doesn't use Bluesky records.
    ///
    /// - Important: This initializer may potentially block the thread if
    /// `canUseBlueskyRecords` is `true`. In this case, it's a good idea to move the initializer
    /// to a `Task` block in order to prevent that from happening.
    ///
    /// - Parameters:
    ///   - sessionConfiguration: The authenticated user session within the AT Protocol. Optional.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `https://api.bsky.app`.
    ///   - canUseBlueskyRecords: Indicates whether Bluesky's lexicons should be used.
    ///   Defaults to `true`.
    public init(sessionConfiguration: SessionConfiguration? = nil, pdsURL: String = "https://api.bsky.app", canUseBlueskyRecords: Bool = true) {
        self.sessionConfiguration = sessionConfiguration
        self.pdsURL = Self.determinePDSURL(customPDSURL: pdsURL)
        self.logger = session?.logger

        Task { [recordLexicons] in
            if canUseBlueskyRecords && !(ATRecordTypeRegistry.areBlueskyRecordsRegistered) {
                _ = await ATRecordTypeRegistry.shared.register(blueskyLexiconTypes: recordLexicons)
            }
        }
    }

    /// Initializes a new, asyncronous instance of `ATProtoKit`.
    ///
    /// This will also handle some of the logging-related setup. The identifier will either be your
    /// project's `CFBundleIdentifier` or an identifier named
    /// `com.cjrriley.ATProtoKit`. However, you can manually override this.
    ///
    /// If you're using methods such as
    /// ``ATProtoKit/ATProtoKit/createAccount(email:handle:existingDID:inviteCode:verificationCode:verificationPhone:password:recoveryKey:plcOperation:)``
    /// or ``ATProtoKit/ATProtoKit/getSession(by:)``, be sure to set
    /// `canUseBlueskyRecords` to false. While the initializer does check to see if the records
    /// have been added, it's best not to invoke it, esepcially if you're using ATProtoKit for a
    /// generic AT Protocol service that doesn't use Bluesky records.
    ///
    /// - Parameters:
    ///   - sessionConfiguration: The authenticated user session within the AT Protocol. Optional.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `https://api.bsky.app`.
    ///   - canUseBlueskyRecords: Indicates whether Bluesky's lexicons should be used.
    ///   Defaults to `true`.
    public init(sessionConfiguration: SessionConfiguration? = nil, pdsURL: String = "https://api.bsky.app", canUseBlueskyRecords: Bool = true) async {
        self.sessionConfiguration = sessionConfiguration
        self.pdsURL = pdsURL
        self.logger = session?.logger

        if canUseBlueskyRecords && !(ATRecordTypeRegistry.areBlueskyRecordsRegistered) {
            _ = await ATRecordTypeRegistry.shared.register(blueskyLexiconTypes: recordLexicons)
        }
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

    /// An instance of `URLSessionConfiguration`.
    ///
    /// - Note: This class will automatically grab the custom `URLSessionConfiguration` instance
    /// from the `ATProtoKit` instance.
    public var urlSessionConfiguration: URLSessionConfiguration = .default

    /// The ``ATLinkBuilder`` object used to grab the metadata for preview link cards. Optional.
    public let linkBuilder: ATLinkBuilder?

    /// Specifies the logger that will be used for emitting log messages.
    public private(set) var logger: Logger?

    /// Represents an object used for managing sessions.
    public let sessionConfiguration: SessionConfiguration?

    /// The URL of the Personal Data Server (PDS).
    public let pdsURL: String

    /// Represents an authenticated user session within the AT Protocol. Optional.
    public var session: UserSession? {
        return sessionConfiguration?.session
    }

    /// Represents the instance of ``ATProtoKit/ATProtoKit``.
    internal let atProtoKitInstance: ATProtoKit

    /// Initializes a new instance of `ATProtoBluesky`.
    /// - Parameters:
    ///   - atProtoKitInstance: Represents the instance of ``ATProtoKit/ATProtoKit``.
    ///   - linkbuilder: The ``ATLinkBuilder`` object used to grab the metadata for preview
    ///   link cards. Optional.
    public init(atProtoKitInstance: ATProtoKit, linkbuilder: ATLinkBuilder? = nil) {
        self.atProtoKitInstance = atProtoKitInstance
        self.sessionConfiguration = atProtoKitInstance.sessionConfiguration
        self.linkBuilder = linkbuilder
        self.logger = self.atProtoKitInstance.session?.logger ?? logger
        self.pdsURL = "https://api.bsky.app"
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

    /// An instance of `URLSessionConfiguration`.
    ///
    /// - Note: This class will automatically grab the custom `URLSessionConfiguration` instance
    /// from the `ATProtoKit` instance.
    public var urlSessionConfiguration: URLSessionConfiguration = .default

    /// Specifies the logger that will be used for emitting log messages.
    public private(set) var logger: Logger?

    /// Represents an object used for managing sessions.
    public let sessionConfiguration: SessionConfiguration?

    /// The URL of the Personal Data Server (PDS).
    public let pdsURL: String

    /// Represents an authenticated user session within the AT Protocol. Optional.
    public var session: UserSession? {
        return sessionConfiguration?.session
    }

    /// Represents the instance of ``ATProtoKit/ATProtoKit``.
    internal let atProtoKitInstance: ATProtoKit

    /// Initializes a new instance of `ATProtoBlueskyChat`.
    ///
    /// - Parameters:
    ///   - atProtoKitInstance: Represents the instance of ``ATProtoKit/ATProtoKit``.
    ///   Defaults to the project's `CFBundleIdentifier`.
    public init(atProtoKitInstance: ATProtoKit) {
        self.atProtoKitInstance = atProtoKitInstance
        self.sessionConfiguration = atProtoKitInstance.sessionConfiguration
        self.logger = self.atProtoKitInstance.session?.logger
        self.pdsURL = "https://api.bsky.chat"
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
///         try await config.authenticate()
///
///         print("Access token: \(session.accessToken)")
///     } catch {
///         print("Error: \(error)")
///     }
/// }
/// ```
public class ATProtoAdmin: ATProtoKitConfiguration {

    /// An instance of `URLSessionConfiguration`.
    ///
    /// Please directly add the the `URLSessionConfiguration` instance onto the property if it's
    /// a custom value.
    ///
    /// ```swift
    /// let config = ATProtocolConfiguration(handle: "example.bsky.social", appPassword: "hunter2")
    ///
    /// Task {
    ///     do {
    ///         try await config.authenticate()
    /// 
    ///         let atProtoAdmin = ATProtoAdmin(sessionConfiguration: session)
    ///
    ///         atProtoAdmin.urlSessionConfiguration = config.configuration
    ///     } catch {
    ///         // Error...
    ///     }
    /// }
    /// ```
    public var urlSessionConfiguration: URLSessionConfiguration = .default

    /// Specifies the logger that will be used for emitting log messages.
    public private(set) var logger: Logger?

    /// Represents an object used for managing sessions.
    public let sessionConfiguration: SessionConfiguration?

    /// The URL of the Personal Data Server (PDS).
    public let pdsURL: String

    /// Represents an authenticated user session within the AT Protocol. Optional.
    public var session: UserSession? {
        return sessionConfiguration?.session
    }

    /// Initializes a new instance of `ATProtoAdmin`.
    /// - Parameters:
    ///   - sessionConfiguration: The authenticated user session within the AT Protocol. Optional.
    ///   Defaults to the project's `CFBundleIdentifier`.
    public init(sessionConfiguration: SessionConfiguration? = nil) {
        self.sessionConfiguration = sessionConfiguration
        self.pdsURL = "https://api.bsky.app"
        self.logger = session?.logger
    }
}
