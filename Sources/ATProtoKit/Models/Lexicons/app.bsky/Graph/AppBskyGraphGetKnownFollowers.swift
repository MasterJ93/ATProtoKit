//
//  AppBskyGraphGetKnownFollowers.swift
//
//
//  Created by Christopher Jr Riley on 2024-06-12.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Graph {

    /// An output model for identifying mutual followers.
    ///
    /// - Note: According to the AT Protocol specifications: "Enumerates accounts which follow a
    /// specified account (actor) and are followed by the viewer."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.graph.getKnownFollowers`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/getKnownFollowers.json
    public struct GetKnownFollowersOutput: Sendable, Codable {

        /// The user account that mutually follows ``followers``.
        public let subject: AppBskyLexicon.Actor.ProfileViewDefinition

        /// The number of the last successful message decoded. Optional.
        public let cursor: String?

        /// An array of mutual followers.
        public let followers: [AppBskyLexicon.Actor.ProfileViewDefinition]
    }
}
