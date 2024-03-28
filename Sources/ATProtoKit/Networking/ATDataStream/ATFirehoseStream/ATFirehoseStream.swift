//
//  ATFirehoseStream.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-14.
//

import Foundation

/// The base class for the AT Protocol's Firehose event stream.
class ATFirehoseStream: ATEventStreamConfiguration {
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
    /// The configuration object that defines the behaviours and polices for a URL session in the event stream.
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
    ///   - urlSessionConfiguration: The configuration object that defines the behaviours and polices for a URL session in the event stream. Defaults
    ///   to `URLSessionConfiguration.default`.
    required init(relayURL: String, namespacedIdentifiertURL: String, cursor: Int64?, sequencePosition: Int64?,
                  urlSessionConfiguration: URLSessionConfiguration = .default, webSocketTask: URLSessionWebSocketTask) throws {
        self.relayURL = relayURL
        self.namespacedIdentifiertURL = namespacedIdentifiertURL
        self.cursor = cursor
        self.sequencePosition = sequencePosition
        self.urlSessionConfiguration = urlSessionConfiguration
        self.urlSession = URLSession(configuration: urlSessionConfiguration)
        self.webSocketTask = webSocketTask

        guard let webSocketURL = URL(string: "\(relayURL)/xrpc/\(namespacedIdentifiertURL)") else { throw ATRequestPrepareError.invalidFormat }
        self.webSocketTask = urlSession.webSocketTask(with: webSocketURL)
        webSocketTask.resume()

        self.connect()
    }
}
