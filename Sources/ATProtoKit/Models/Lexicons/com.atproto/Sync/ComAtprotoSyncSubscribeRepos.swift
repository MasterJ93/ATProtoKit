//
//  ComAtprotoSyncSubscribeRepos.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation

extension ComAtprotoLexicon.Sync {

    /// The main data model definition for the firehose service.
    ///
    /// - Note: According to the AT Protocol specifications: "Repository event stream, aka Firehose
    /// endpoint. Outputs repo commits with diff data, and identity update events, for all
    /// repositories on the current server. See the atproto specifications for details around
    /// stream sequencing, repo versioning, CAR diff format, and more. Public and does not require
    /// auth; implemented by PDS and Relay."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.sync.subscribeRepos`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/sync/subscribeRepos.json
    public struct SubscribeRepos: Codable {

    }
}
