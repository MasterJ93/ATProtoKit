//
//  AppBskyGraphUnmuteActorList.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Graph {

    /// A request body model for unmuting a list of user accounts.
    ///
    /// - Note: According to the AT Protocol specifications: "Unmutes the specified list of
    /// accounts. Requires auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.graph.unmuteActorList`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/unmuteActorList.json
    public struct UnmuteActorListRequestBody: Sendable, Codable {

        /// The URI of a list.
        public let listURI: String

        enum CodingKeys: String, CodingKey {
            case listURI = "list"
        }
    }
}
