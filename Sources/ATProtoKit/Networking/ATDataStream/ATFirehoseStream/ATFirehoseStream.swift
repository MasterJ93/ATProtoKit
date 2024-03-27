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
    /// The URL of the endpoint.
    internal var namespacedIdentifiertURL: String = "com.atproto.sync.subscribeRepos"
    /// The mark used to indicate the starting point for the next set of results. Optional.
    public var cursor: String?

    required public init(relayURL: String, namespacedIdentifiertURL: String, cursor: String?) {
        self.relayURL = relayURL
        self.namespacedIdentifiertURL = namespacedIdentifiertURL
        self.cursor = cursor
    }

    
}
