//
//  ATProtocolConfiguration.swift
//  
//
//  Created by Christopher Jr Riley on 2024-01-06.
//

import Foundation
import Logging

/// Manages authentication and session operations for the a user account in the ATProtocol.
public class ATProtocolConfiguration: ProtocolConfiguration {

    /// The user's handle identifier in their account.
    public var handle: String

    /// The app password of the user's account.
    public var appPassword: String

    /// The URL of the Personal Data Server (PDS).
    public var pdsURL: String

    /// An instance of `URLSessionConfiguration`.
    public let configuration: URLSessionConfiguration

    /// Specifies the logger that will be used for emitting log messages.
    public private(set) var logger: Logger?

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

    /// Specifies the logger that will be used for emitting log messages.
    private static var sharedLogger: Logger?

    /// Initializes a new instance of `ATProtocolConfiguration`, which assembles a new session
    /// for the user account.
    ///
    /// - Parameters:
    ///   - handle: The user's handle identifier in their account.
    ///   - appPassword: The app password of the user's account.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `nil`.
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
        logIdentifier: String? = nil,
        logCategory: String? = nil,
        logLevel: Logger.Level? = .info) {
            self.handle = handle
            self.appPassword = appPassword
            self.pdsURL = !pdsURL.isEmpty ? pdsURL : "https://bsky.social"
            self.configuration = configuration
            self.logIdentifier = logIdentifier ?? Bundle.main.bundleIdentifier ?? "com.cjrriley.ATProtoKit"
            self.logCategory = logCategory ?? "ATProtoKit"
            self.logLevel = logLevel


            setupLog(logCategory, logLevel)

            Task {
                await APIClientService.shared.configure(with: self.configuration)
            }
    }



    fileprivate func setupLog(_ logCategory: String?, _ logLevel: Logger.Level?) {
        if ATProtocolConfiguration.sharedLogger == nil {
            #if canImport(os)
            LoggingSystem.bootstrap { label in
                ATLogHandler(subsystem: label, category: logCategory ?? "ATProtoKit")
            }
            #else
            LoggingSystem.bootstrap(StreamLogHandler.standardOutput)
            #endif

            ATProtocolConfiguration.sharedLogger = Logger(label: self.logIdentifier ?? "com.cjrriley.ATProtoKit")
            ATProtocolConfiguration.sharedLogger?.logLevel = logLevel ?? .info
        }

        self.logger = ATProtocolConfiguration.sharedLogger
    }
}
