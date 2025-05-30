//
//  APIClientConfiguration.swift
//  ATProtoKit
//
//  Created by Michael Freiwald on 30.05.25.
//

import Foundation

/// A configuration container for customizing the behavior of an API client.
///
/// `APIClientConfiguration` enables fine-grained control over the underlying networking stack used by an API client, including session configuration, delegate handling, response execution, and logging.
///
/// You can use this type to inject custom dependencies or modify default behaviors. All properties are optional, and reasonable defaults are provided where possible.
///
/// - Parameters:
///   - urlSessionConfiguration: The configuration object that defines behavior and policies for a URL session. If `nil`, uses `URLSessionConfiguration.default`.
///   - delegate: The delegate object that handles session-level events, such as authentication challenges or background events. If `nil`, no delegate is used.
///   - delegateQueue: The operation queue on which the delegate callbacks are dispatched. If `nil`, the system provides a default delegate queue.
///   - responseProvider: An object responsible for executing requests and providing responses. Useful for dependency injection and testing. If `nil`, the default executor is used.
///   - logger: An object conforming to `SessionDebuggable` for capturing debug information and logging session activity. If `nil`, logging is disabled.
///
/// - SeeAlso: [URLSessionConfiguration](https://developer.apple.com/documentation/foundation/urlsessionconfiguration), [URLSessionDelegate](https://developer.apple.com/documentation/foundation/urlsessiondelegate)
public struct APIClientConfiguration: Sendable {
    var urlSessionConfiguration: URLSessionConfiguration? = .default
    var delegate: (any URLSessionDelegate)? = nil
    var delegateQueue: OperationQueue? = nil
    var responseProvider: ATRequestExecutor? = nil
    var logger: SessionDebuggable? = nil

    /// Creates a new API client configuration with optional customization points.
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
