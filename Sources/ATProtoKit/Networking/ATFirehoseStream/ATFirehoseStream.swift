//
//  ATFirehoseStream.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-14.
//

import Foundation

/// The base class for the AT Protocol's Firehose event stream.
class ATFirehoseStream {
    /// The URL of the relay. Defaults to `https://bsky.network`.
    public var relayURL: URL = URL(string: "https://bsky.network")

    public init(relayURL: URL) {
        self.relayURL = relayURL
    }
}
