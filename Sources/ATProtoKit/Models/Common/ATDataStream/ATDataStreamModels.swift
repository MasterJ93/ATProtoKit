//
//  ATDataStreamModels.swift
//  
//
//  Created by Christopher Jr Riley on 2024-03-17.
//

import Foundation

/// The base protocol which all data stream-related classes conform to.
///
/// `ATDataStreamConfiguration` contains all of the basic properties, initializers, and methods needed to manage connections in the AT Protocol's event streams. Some of these include directly managing the connection (opening, clousing, and reconnecting), creating parameters for allowing and disallowing content, handling sequences, and
public protocol ATDataStreamConfiguration: Decodable {
    /// The URL of the relay.
    ///
    /// The endpoint must begin with `wss://`.
    var relayURL: String { get }
    /// The URL of the endpoint.
    ///
    /// The endpoint must be the lexicon name (example: `com.atproto.sync.subscribeRepos`).
    var endpointURL: String { get }

    /// The mark used to indicate the starting point for the next set of results. Optional.
    ///
    /// - Note: According to the AT Protocol specifications: "The last known event seq number to backfill from."
    var cursor: String? { get }

    func connect()

    func disconnect()

    func reConnect()

    func receiveMessages()
}

/// A protocol used for the basic skeleton of the model definitions.
public protocol DataStreamSkeleton: Decodable {
    ///
    ///
    /// - Note: According to the AT Protocol specifications: "The stream sequence number of this message."
    var sequence: Int? { get }
    /// The date and time the object was sent to the stream.
    ///
    /// - Note: According to the AT Protocol specifications: "Timestamp of when this message was originally broadcast."
    var timeStamp: Date { get }
}
