//
//  ATFirehoseStream.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-14.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// The base class for Bluesky's Firehose event stream.
public class ATFirehoseStream: ATEventStreamConfiguration {

    /// Indicates whether the event stream is connected. Defaults to `false`.
    public var isConnected: Bool = false

    /// The URL of the relay. Defaults to `wss://bsky.network`.
    public var relayURL: String = "wss://bsky.network"

    /// The URL of the endpoint. Defaults to `com.atproto.sync.subscribeRepos`.
    public var namespacedIdentifiertURL: String = "com.atproto.sync.subscribeRepos"

    /// The number of the last successful message decoded. Optional.
    ///
    /// When a message gets successfully decoded, this property is populated with the number.
    public var sequencePosition: Int64?

    /// The mark used to indicate the starting point for the next set of results. Optional.
    public var cursor: Int64?

    /// The configuration object that defines the behaviours and polices for a URL session in the
    /// event stream.
    public let urlSession: URLSession

    /// The configuration object that defines behavior and policies for a URL session.
    public let urlSessionConfiguration: URLSessionConfiguration

    /// The URL session task that communicates over the WebSockets protocol standard.
    public var webSocketTask: URLSessionWebSocketTask

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
    ///   - webSocketTask: The URL session task that communicates over the WebSockets
    ///  protocol standard.
    public required init(relayURL: String, namespacedIdentifiertURL: String, cursor: Int64?, sequencePosition: Int64?,
                  urlSessionConfiguration: URLSessionConfiguration = .default, webSocketTask: URLSessionWebSocketTask) async throws {
        self.relayURL = relayURL
        self.namespacedIdentifiertURL = namespacedIdentifiertURL
        self.cursor = cursor
        self.sequencePosition = sequencePosition
        self.urlSessionConfiguration = urlSessionConfiguration
        self.urlSession = URLSession(configuration: urlSessionConfiguration)
        self.webSocketTask = webSocketTask

        guard let webSocketURL = URL(string: "\(relayURL)/xrpc/\(namespacedIdentifiertURL)") else { throw ATRequestPrepareError.invalidFormat }
        self.webSocketTask = urlSession.webSocketTask(with: webSocketURL)
    }
}
