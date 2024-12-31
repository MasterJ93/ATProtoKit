//
//  ComAtprotoSyncNotifyOfUpdate.swift
//
//
//  Created by Christopher Jr Riley on 2024-12-31.
//

import Foundation

extension ComAtprotoLexicon.Sync {

    /// A request body model for notifying the crawling service to re-index or resume crawling.
    ///
    /// - Note: According to the AT Protocol specifications: "Notify a crawling service of a recent
    /// update, and that crawling should resume. Intended use is after a gap between repo stream
    /// events caused the crawling service to disconnect. Does not require auth; implemented
    /// by Relay."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.sync.notifyOfUpdate`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/sync/notifyOfUpdate.json
    public struct NotifyOfUpdateRequestBody: Sendable, Codable {

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
