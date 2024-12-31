//
//  ComAtprotoSyncRequestCrawl.swift
//
//
//  Created by Christopher Jr Riley on 2024-12-31.
//

import Foundation

extension ComAtprotoLexicon.Sync {

    /// A request body model for requesting the crawling service to begin crawling
    /// the repositories.
    ///
    /// - Note: According to the AT Protocol specifications: "Request a service to persistently
    /// crawl hosted repos. Expected use is new PDS instances declaring their existence to Relays.
    /// Does not require auth."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.sync.requestCrawl`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/sync/requestCrawl.json
    public struct RequestCrawlRequestBody: Sendable, Codable {

        /// The hostname that the crawling service resides in.
        ///
        /// - Note: According to the AT Protocol specifications: "Hostname of the current service
        /// (eg, PDS) that is requesting to be crawled."
        public let crawlingHostname: URL

        enum CodingKeys: String, CodingKey {
            case crawlingHostname = "hostname"
        }
    }
}
