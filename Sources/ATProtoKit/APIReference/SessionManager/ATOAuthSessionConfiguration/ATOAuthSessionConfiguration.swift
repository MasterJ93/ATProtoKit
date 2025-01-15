//
//  ATOAuthSessionConfiguration.swift
//
//
//  Created by Christopher Jr Riley on 2025-01-14.
//

import Foundation
import Logging

public class ATOAuthSessionConfiguration: SessionConfiguration {

    /// The user's handle identifier in their account.
    public var handle: String

    /// The password of the user's account.
    public var password: String

    /// The URL of the Personal Data Server (PDS).
    public var pdsURL: String

    /// An instance of `URLSessionConfiguration`.
    public let configuration: URLSessionConfiguration

    /// Specifies the logger that will be used for emitting log messages. Optional.
    private static let loggerManager = LogBootstrapConfiguration()

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

    /// The number of times a request can be attempted before it's considered a failure.
    ///
    /// By default, ATProtoKit will retry a request attempt for 1 second.
    public var maxRetryCount: Int?

    /// The length of time to wait before attempting to retry a request.
    ///
    /// By default, ATProtoKit will wait for 1 second before attempting to retry a request.
    /// ATProtoKit will change the number exponentally in order to help prevent overloading
    /// the server.
    public var retryTimeDelay: TimeInterval?

    /// The session attached to the configuration. Optional.
    public var session: UserSession?

    /// Initializes a new instance of `ATProtocolConfiguration`, which assembles a new session
    /// for the user account.
    ///
    /// - Parameters:
    ///   - handle: The user's handle identifier in their account.
    ///   - appPassword: The app password of the user's account.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `https://bsky.social`.
    ///   - configuration: An instance of `URLSessionConfiguration`. Optional.
    ///   - logIdentifier: Specifies the identifier for managing log outputs. Optional. Defaults
    ///   to the project's `CFBundleIdentifier`.
    ///   - logCategory: Specifies the category name the logs in the logger within ATProtoKit will
    ///   be in. Optional. Defaults to `ATProtoKit`.
    ///   - logLevel: Specifies the highest level of logs that will be outputted. Optional.
    ///   Defaults to `.info`.
    public init(
        handle: String,
        appPassword: String,
        pdsURL: String = "https://bsky.social",
        configuration: URLSessionConfiguration = .default,
        //        userAgent: ATProtoTools.UserAgent = .default,
        logIdentifier: String? = nil,
        logCategory: String? = nil,
        logLevel: Logger.Level? = .info
    ) {
        self.handle = handle
        self.password = appPassword
        self.pdsURL = !pdsURL.isEmpty ? pdsURL : "https://bsky.social"
        self.configuration = configuration
        //        self.userAgent = userAgent
        self.logIdentifier = logIdentifier ?? Bundle.main.bundleIdentifier ?? "com.cjrriley.ATProtoKit"
        self.logCategory = logCategory ?? "ATProtoKit"
        self.logLevel = logLevel

        Task { [configuration] in
            await ATOAuthSessionConfiguration.loggerManager.setupLog(logCategory: logCategory, logLevel: logLevel, logIdentifier: logIdentifier)
            await APIClientService.shared.configure(with: configuration)
        }
    }

    public func authenticate(authenticationFactorToken: String?) async throws {
        print("Not implement yet.")
    }


}
