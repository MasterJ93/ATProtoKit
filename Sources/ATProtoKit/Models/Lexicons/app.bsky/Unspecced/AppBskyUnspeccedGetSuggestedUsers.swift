//
//  AppBskyUnspeccedGetSuggestedUsers.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-05-14.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Unspecced {

    /// An output model for getting an array of suggested user accounts.
    ///
    /// - Note: According to the AT Protocol specifications: "Category of users to get suggestions for."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.getSuggestedUsers`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/unspecced/getSuggestedUsers.json
    public struct GetSuggestedUsersOutput: Sendable, Codable {

        /// An array of user accounts.
        public let actors: [AppBskyLexicon.Actor.ProfileViewDefinition]
    }
}
