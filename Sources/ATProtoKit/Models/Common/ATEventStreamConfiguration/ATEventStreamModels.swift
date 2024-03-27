//
//  ATEventStreamModels.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-17.
//

import Foundation

/// The base protocol which all data stream-related classes conform to.
///
/// `ATEventStreamConfiguration` contains all of the basic properties, initializers, and methods needed to manage connections in the AT Protocol's event streams. Some of these include directly managing the
/// connection (opening, closing, and reconnecting), creating parameters for allowing and disallowing content, and handling sequences.
public protocol ATEventStreamConfiguration: Decodable {
    /// The URL of the relay.
    ///
    /// The endpoint must begin with `wss://`.
    var relayURL: String { get }
    /// The Namespaced Identifier (NSID) of the endpoint.
    ///
    /// The endpoint must be the lexicon name (example: `com.atproto.sync.subscribeRepos`).
    var namespacedIdentifiertURL: String { get }
    /// The mark used to indicate the starting point for the next set of results. Optional.
    ///
    /// - Note: According to the AT Protocol specifications: "The last known event seq number to backfill from."
    var cursor: String? { get }

    init(relayURL: String, namespacedIdentifiertURL: String, cursor: String?)

    func connect()
    func disconnect()
    func reConnect()
    func receiveMessages()
}

public struct WebSocketFrameHeader: Codable {
    /// Indicates what this frame contains.
    ///
    /// If it contains a `1`, then a normal message will be in the payload and `type` will have a value. If it contains a `-1`, then an error message will be displayed in the payload instead.
    ///
    /// - Note: If `operation` contains a value other than `1` or `-1`, the entire frame will be completely ignored.
    public let operation: Int
    /// Indicates the Lexicon sub-type for this message, in short form.
    public let type: String?
}

public struct WebSocketFrameMessageError: Codable, ATProtoError {
    public let error: String
    public let message: String?
}
