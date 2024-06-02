//
//  ComAtprotoSyncCrawler.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-23.
//

import Foundation

extension ComAtprotoLexicon.Sync {

    /// A request body model for the crawling service.
    ///
    /// - Note: According to the AT Protocol specifications:\
    /// `com.atproto.sync.notifyOfUpdate`: "Notify a crawling service of a recent update, and that
    /// crawling should resume. Intended use is after a gap between repo stream events caused the
    /// crawling service to disconnect. Does not require auth; implemented by Relay." \
    /// \
    /// `com.atproto.sync.requestCrawl`: "Request a service to persistently crawl hosted repos.
    /// Expected use is new PDS instances declaring their existence to Relays. Does not require auth."
    ///
    /// - SeeAlso: This is based on the following lexicons:\
    ///  \- [`com.atproto.sync.notifyOfUpdate`][notifyOfUpdate]\
    ///  \- [`com.atproto.sync.requestCrawl`][requestCrawl]
    ///
    /// [notifyOfUpdate]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/sync/notifyOfUpdate.json
    /// [requestCrawl]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/sync/requestCrawl.json
    public struct Crawler: Codable {

        /// The hostname that the crawling service resides in.
        ///
        /// - Note: According to the AT Protocol specifications: "Hostname of the current service
        /// (usually a PDS) that is notifying of update."
        public let crawlingHostname: URL

        enum CodingKeys: String, CodingKey {
            case crawlingHostname = "hostname"
        }
    }
}
