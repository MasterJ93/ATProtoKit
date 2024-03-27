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
