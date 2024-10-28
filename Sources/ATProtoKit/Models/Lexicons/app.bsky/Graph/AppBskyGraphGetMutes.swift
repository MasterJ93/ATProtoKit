//
//  AppBskyGraphGetMutes.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension AppBskyLexicon.Graph {

    /// An output model for retrieving all accounts the user account is currently muting.
    ///
    /// - Note: According to the AT Protocol specifications: "Enumerates accounts that the
    /// requesting account (actor) currently has muted. Requires auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.graph.getMutes`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/getMutes.json
    public struct GetMutesOutput: Sendable, Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of accounts the user account is muting.
        public let mutes: [AppBskyLexicon.Actor.ProfileViewDefinition]
    }
}
