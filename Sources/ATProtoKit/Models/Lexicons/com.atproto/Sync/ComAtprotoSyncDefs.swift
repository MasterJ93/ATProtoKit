//
//  ComAtprotoSyncDefs.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-05-17.
//

import Foundation

extension ComAtprotoLexicon.Sync {

    /// A definition model for a host status.
    ///
    /// - SeeAlso: This is based on the [`com.atproto.sync.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/sync/defs.json
    public enum HostStatusDefinition: String, Sendable, Codable {

        /// The host is active.
        case active

        /// The host is idle.
        case idle

        /// The host is offline.
        case offline

        /// The host has been throttled.
        case throttled

        /// The host has been banned.
        case banned
    }
}
