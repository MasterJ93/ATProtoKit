//
//  ATFirehoseStream.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-14.
//

import Foundation
import Logging

/// The base class for the AT Protocol's Firehose event stream.
class ATFirehoseStream: ATEventStreamConfiguration {
    internal var logger = Logger(label: "ATFirehoseStream")
    /// Indicates whether the event stream is connected. Defaults to `false`.
    internal var isConnected: Bool = false
    /// The URL of the relay. Defaults to `wss://bsky.network`.
    public var relayURL: String = "wss://bsky.network"

    /// The URL of the endpoint. Defaults to `com.atproto.sync.subscribeRepos`.
    internal var namespacedIdentifiertURL: String = "com.atproto.sync.subscribeRepos"

    /// The number of the last successful message decoded. Optional.
    ///
    /// When a message gets successfully decoded, this property is populated with the number.
    public var sequencePosition: Int64?

    /// The mark used to indicate the starting point for the next set of results. Optional.
    public var cursor: Int64?

    /// The configuration object that defines the behaviours and polices for a URL session in the
    /// event stream.
    internal let urlSession: URLSession

    /// The configuration object that defines behavior and policies for a URL session.
    internal let urlSessionConfiguration: URLSessionConfiguration

    /// The URL session task that communicates over the WebSockets protocol standard.
    internal var webSocketTask: URLSessionWebSocketTask

    /// Creates a new instance to prepare for the event stream.
    ///
    /// - Parameters:
    ///   - relayURL: The URL of the relay.
    ///   - namespacedIdentifiertURL: The Namespaced Identifier (NSID) of the endpoint.
    ///   - cursor: The number of the last successful message decoded. Optional.
    ///   - sequencePosition: The number of the last successful message decoded. Optional.
    ///   - urlSessionConfiguration: The configuration object that defines the behaviours and
    ///   polices for a URL session in the event stream. Defaults
    ///   to `URLSessionConfiguration.default`.
    required init(relayURL: String, namespacedIdentifiertURL: String, cursor: Int64?, sequencePosition: Int64?,
                  urlSessionConfiguration: URLSessionConfiguration = .default, webSocketTask: URLSessionWebSocketTask) async throws {
        logger.trace("In init()")
        logger.trace("Initializing the ATEventStreamConfiguration")
        self.relayURL = relayURL
        self.namespacedIdentifiertURL = namespacedIdentifiertURL
        self.cursor = cursor
        self.sequencePosition = sequencePosition
        self.urlSessionConfiguration = urlSessionConfiguration
        self.urlSession = URLSession(configuration: urlSessionConfiguration)
        self.webSocketTask = webSocketTask
        
        logger.debug("Opening a websocket", metadata: ["relayUrl": "\(relayURL)", "namespacedIdentifiertURL": "\(namespacedIdentifiertURL)"])
        guard let webSocketURL = URL(string: "\(relayURL)/xrpc/\(namespacedIdentifiertURL)") else {
            logger.error("Unable to create the websocket URL due to an invalid format.")
            throw ATRequestPrepareError.invalidFormat
        }
        
        logger.debug("Creating the websocket task")
        self.webSocketTask = urlSession.webSocketTask(with: webSocketURL)
        logger.trace("Exiting init()")
    }
}
