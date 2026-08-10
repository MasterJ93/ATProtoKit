//
//  AppBskyGraphGetStarterPacksWithMembership.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-10.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Graph {

    /// A definition model for enumerating starter packs created by the session user that includes
    /// membership information about the specified `actor`.
    ///
    /// - Note: According to the AT Protocol specifications: "Enumerates the starter packs created
    /// by the session user, and includes membership information about `actor` in those starter
    /// packs. Requires auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.graph.getStarterPacksWithMembership`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/getStarterPacksWithMembership.json
    public struct GetStarterPacksWithMembership: Sendable, Codable {

        /// A starter pack with an optional membership of a target user account.
        ///
        /// - Note: According to the AT Protocol specifications: "A starter pack and an optional
        /// list item indicating membership of a target user to that starter pack."
        ///
        /// - SeeAlso: This is based on the [`app.bsky.graph.getStarterPacksWithMembership`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/getStarterPacksWithMembership.json
        public struct StarterPackWithMembership: Sendable, Codable {

            /// The starter pack itself.
            public let starterPack: AppBskyLexicon.Graph.StarterPackViewDefinition

            /// The membership of the target user account to that starter pack's list. Optional.
            public let listItem: AppBskyLexicon.Graph.ListItemViewDefinition?
        }
    }

    /// An output model for enumerating starter packs created by the session user that includes
    /// membership information about the specified `actor`.
    ///
    /// - Note: According to the AT Protocol specifications: "Enumerates the starter packs created
    /// by the session user, and includes membership information about `actor` in those starter
    /// packs. Requires auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.graph.getStarterPacksWithMembership`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/getStarterPacksWithMembership.json
    public struct GetStarterPacksWithMembershipOutput: Sendable, Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of starter packs with membership.
        public let starterPacksWithMembership: [AppBskyLexicon.Graph.GetStarterPacksWithMembership.StarterPackWithMembership]
    }
}
