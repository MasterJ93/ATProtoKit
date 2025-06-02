//
//  APIClientConfiguration.swift
//  ATProtoKit
//
//  Created by Michael Freiwald on 30.05.25.
//

import Foundation

/// A configuration container for customizing the behavior of an API client.
///
/// `APIClientConfiguration` enables fine-grained control over the underlying networking stack
/// used by an API client, including session configuration, delegate handling, response execution,
/// and logging.
///
/// - SeeAlso: [URLSessionConfiguration](https://developer.apple.com/documentation/foundation/urlsessionconfiguration), \
/// [URLSessionDelegate](https://developer.apple.com/documentation/foundation/urlsessiondelegate)
public struct APIClientConfiguration: Sendable {

    /// An instance of `URLSessionConfiguration`. Optional. Defaults to `.default`.
    var urlSessionConfiguration: URLSessionConfiguration?

    /// A session delegate object that handles requests for authentication and other session-related events.
    /// Optional. Defaults to `nil`.
    var delegate: (any URLSessionDelegate)? = nil

    /// An operation queue for scheduling the delegate calls and completion handlers. Optional.
    /// Defaults to `nil`.
    var delegateQueue: OperationQueue? = nil

    /// A provider used for the response of the `URLRequest`. Optional. Defaults to `nil`.
    var responseProvider: ATRequestExecutor? = nil

    /// An instance of ``SessionDebuggable`` to attach to `APIClientService`. Optional. Defaults to `nil`.
    var logger: SessionDebuggable? = nil

    /// Creates a new API client configuration with optional customization points.
    ///
    /// - Parameters:
    ///   - urlSessionConfiguration: An instance of `URLSessionConfiguration`. Optional. Defaults to `nil`.
    ///   - delegate: A session delegate object that handles requests for authentication and other
    ///   session-related events. Optional. Defaults to `nil`.
    ///   - delegateQueue: An operation queue for scheduling the delegate calls and completion handlers.
    ///   Optional. Defaults to `nil`.
    ///   - responseProvider: A provider used for the response of the `URLRequest`. Optional.
    ///   Defaults to `nil`.
    ///   - logger: An instance of ``SessionDebuggable`` to attach to `APIClientService`. Optional.
    ///   Defaults to `nil`.
    public init(
        urlSessionConfiguration: URLSessionConfiguration? = nil,
        delegate: (any URLSessionDelegate)? = nil,
        delegateQueue: OperationQueue? = nil,
        responseProvider: ATRequestExecutor? = nil,
        logger: SessionDebuggable? = nil
    ) {
        self.urlSessionConfiguration = urlSessionConfiguration
        self.delegate = delegate
        self.delegateQueue = delegateQueue
        self.responseProvider = responseProvider
        self.logger = logger
    }
}
