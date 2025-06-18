//
//  AppBskyUnspeccedGetSuggestedStarterPacks.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-05-14.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Unspecced {

    /// An output model for getting an array of suggested starter packs.
    ///
    /// - Note: According to the AT Protocol specifications: "Get a list of suggested starterpacks."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.getSuggestedStarterPacks`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/unspecced/getSuggestedStarterPacks.json
    public struct GetSuggestedStarterPacksOutput: Sendable, Codable {

        /// An array of starter packs.
        public let starterPacks: [AppBskyLexicon.Graph.StarterPackViewDefinition]
    }
}
