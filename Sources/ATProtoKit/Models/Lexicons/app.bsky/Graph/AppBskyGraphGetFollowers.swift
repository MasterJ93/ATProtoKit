//
//  AppBskyGraphGetFollowers.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension AppBskyLexicon.Graph {

    /// An output model for getting all of the user account's followers.
    ///
    /// - Note: According to the AT Protocol specifications: "Enumerates accounts which follow a
    /// specified account (actor)."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.graph.getFollowers`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/getFollowers.json
    public struct GetFollowersOutput: Codable {

        /// The user account itself.
        public let subject: AppBskyLexicon.Actor.ProfileViewDefinition

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of user accounts that follow the user account.
        public let followers: [AppBskyLexicon.Actor.ProfileViewDefinition]
    }
}
