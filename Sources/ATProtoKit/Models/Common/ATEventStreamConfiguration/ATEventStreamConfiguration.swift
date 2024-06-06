//
//  ATEventStreamConfiguration.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-17.
//

import Foundation
import Logging

/// The base protocol which all data stream-related classes conform to.
///
/// `ATEventStreamConfiguration` contains all of the basic properties, initializers, and methods
/// needed to manage connections in the AT Protocol's event streams. Some of these include directly
/// managing the connection (opening, closing, and reconnecting), creating parameters for allowing
/// and disallowing content, and handling sequences.
public protocol ATEventStreamConfiguration: AnyObject {
    var logger: Logger { get }

    /// The URL of the relay.
    ///
    /// The endpoint must begin with `wss://`.
    var relayURL: String { get }

    /// The Namespaced Identifier (NSID) of the endpoint.
    ///
    /// The endpoint must be the lexicon name (example: `com.atproto.sync.subscribeRepos`).
    var namespacedIdentifiertURL: String { get }

    /// The number of the last successful message decoded. Optional.
    ///
    /// When a message gets successfully decoded, this property is populated with the number.
    var sequencePosition: Int64? { get }

    /// Indicates whether the event stream is connected.
    var isConnected: Bool { get set }

    /// The mark used to indicate the starting point for the next set of results. Optional.
    ///
    /// - Note: According to the AT Protocol specifications: "The last known event seq number to
    /// backfill from."
    var cursor: Int64? { get }

    /// The configuration object that defines the behaviours and polices for a URL session in the
    /// event stream.
    var urlSession: URLSession { get }

    /// The configuration object that defines behavior and policies for a URL session.
    var urlSessionConfiguration: URLSessionConfiguration { get }

    /// The URL session task that communicates over the WebSockets protocol standard.
    var webSocketTask: URLSessionWebSocketTask { get }

    /// Creates a new instance to prepare for the event stream.
    ///
    /// It's recommended that you set `urlSessionConfiguration` to
    /// `URLSessionConfiguration.default`.
    ///
    /// - Parameters:
    ///   - relayURL: The URL of the relay.
    ///   - namespacedIdentifiertURL: The Namespaced Identifier (NSID) of the endpoint.
    ///   - cursor: The number of the last successful message decoded. Optional.
    ///   - sequencePosition: The number of the last successful message decoded. Optional.
    ///   - urlSessionConfiguration: The configuration object that defines the behaviours
    ///   and polices for a URL session in the event stream.
    ///   - webSocketTask: The URL session task that communicates over the WebSockets
    ///   protocol standard.
    init(relayURL: String, namespacedIdentifiertURL: String, cursor: Int64?, sequencePosition: Int64?, urlSessionConfiguration: URLSessionConfiguration,
         webSocketTask: URLSessionWebSocketTask) async throws

    /// Connects the client to the event stream.
    ///
    /// Normally, when connecting to the event stream, it will start from the first message the
    /// event stream gets. The client will always look at the last successful `sequencePosition`
    /// and stores it internally. However, the following can occur when `cursor` is invloved:
    /// - If `cursor` is higher than `sequencePosition`, the connection will close after
    /// outputting an error.
    /// - If `cursor` is within the server's rollback window, the server will attempt to give the
    /// client all of the messages it might have missed.
    /// - If `cursor` is outside of the rollback window, then the server will send an info message
    /// saying it's too old, then sends the oldest message it has and continues the stream.
    /// - If `cursor` is `0`, then the server will send the oldest message it has and continues
    /// the stream.
    ///
    /// - Parameter cursor: The mark used to indicate the starting point for the next set of
    /// results. Optional.
    func connect(cursor: Int64?) async

    /// Disconnects the client from the event stream.
    /// 
    /// - Parameters:
    ///   - closeCode: A code that indicates why the event stream connection closed.
    ///   - reason: The reason why the client disconnected from the server.
    func disconnect(with closeCode: URLSessionWebSocketTask.CloseCode, reason: Data)

    /// Attempts to reconnect the client to the event stream after a disconnect.
    /// 
    /// This method can only be used if the client didn't disconnect itself from the server.
    ///
    /// - Parameters:
    ///   - cursor: The mark used to indicate the starting point for the next set
    ///   of results. Optional.
    ///   - retry: The number of times the connection attempts can be retried.
    func reconnect(cursor: Int64?, retry: Int) async

    /// Receives decoded messages and manages the sequence number.
    ///
    /// This will attempt to decode each of the messages that arrive from the event stream.
    /// All of the messages are in a [DAG-CBOR][DAG_CBOR] format and must
    /// be decoded.
    ///
    /// [DAG_CBOR]: https://ipld.io/docs/codecs/known/dag-cbor/
    func receiveMessages() async

    /// Receives decoded messages that were missed since the last disconnection.
    /// 
    /// - Parameter lastCursor: The last cursor number before ATProtoKit was disconnected
    /// from the relay server.
    func fetchMissedMessages(fromSequence lastCursor: Int64) async
}

public struct WebSocketFrameHeader: Decodable {

    /// Indicates what this frame contains.
    ///
    /// If it contains a `1`, then a normal message will be in the payload and `type` will have
    /// a value. If it contains a `-1`, then an error message will be displayed in the
    /// payload instead.
    ///
    /// - Note: If `operation` contains a value other than `1` or `-1`, the entire frame
    /// will be completely ignored.
    public let operation: Int

    /// Indicates the Lexicon sub-type for this message, in short form.
    public let type: String?

    enum CodingKeys: String, CodingKey {
        case operation = "op"
        case type = "t"
    }
}
