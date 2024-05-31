//
//  AppBskyGraphGetRelationships.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension AppBskyLexicon.Graph {

    /// An output model for the public relationship between two user accounts.
    ///
    /// - Note: According to the AT Protocol specifications: "Enumerates public relationships between
    /// one account, and a list of other accounts. Does not require auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.graph.getRelationships`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/getRelationships.json
    public struct GetRelationshipsOutput: Codable {

        /// The decentralized identifier (DID) of the user account.
        public let actor: String?

        /// The metadata containing the relationship between mutliple user accounts.
        public let relationships: [ATUnion.GetRelationshipsOutputRelationshipUnion]
    }
}
