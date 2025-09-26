//
//  AppBskyGraphGetListsWithMembership.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-09-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Graph {

    /// A definition model for enumerating lists created by the session user that includes membership
    /// information about the specified `actor` and supports only curation and moderation lists
    /// (not reference lists used in starter packs).
    ///
    /// - Note: According to the AT Protocol specifications: "Enumerates the lists created by the session
    /// user, and includes membership information about `actor` in those lists. Only supports curation and
    /// moderation lists (no reference lists, used in starter packs). Requires auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.graph.getListsWithMembership`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/getListsWithMembership.json
    public struct GetListsWithMembership: Sendable, Codable {

        /// The purpose of the list.
        public enum Purpose: String, Sendable, Codable {

            /// Determines the list is a moderation list.
            case moderationList = "modlist"

            /// Determines the list is a curation list.
            case curatationList = "curatelist"
        }

        /// A list with an optional membership of a target user account to that list.
        ///
        /// - Note: According to the AT Protocol specifications: "A list and an optional list item
        /// indicating membership of a target user to that list."
        ///
        /// - SeeAlso: This is based on the [`app.bsky.graph.getListsWithMembership`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/getListsWithMembership.json
        public struct ListWithMembership: Sendable, Codable {

            /// The list itself.
            public let list: AppBskyLexicon.Graph.ListViewDefinition

            /// The membership of the target user account to that list. Optional.
            public let listItem: AppBskyLexicon.Graph.ListItemViewDefinition?
        }
    }

    /// An output model for enumerating lists created by the session user that includes membership
    /// information about the specified `actor` and supports only curation and moderation lists
    /// (not reference lists used in starter packs).
    ///
    /// - Note: According to the AT Protocol specifications: "Enumerates the lists created by the session
    /// user, and includes membership information about `actor` in those lists. Only supports curation and
    /// moderation lists (no reference lists, used in starter packs). Requires auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.graph.getListsWithMembership`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/getListsWithMembership.json
    public struct GetListsWithMembershipOutput: Sendable, Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of lists with membership.
        public let listsWithMembership: [AppBskyLexicon.Graph.GetListsWithMembership.ListWithMembership]
    }
}
