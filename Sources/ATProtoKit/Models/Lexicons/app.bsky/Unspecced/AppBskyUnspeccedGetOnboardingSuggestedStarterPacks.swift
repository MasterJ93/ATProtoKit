//
//  AppBskyUnspeccedGetOnboardingSuggestedStarterPacks.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-10-02.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Unspecced {

    /// An output model for retrieving a list of suggested starterpacks for onboarding.
    ///
    /// - Note: According to the AT Protocol specifications: "Get a list of suggested starterpacks
    /// for onboarding."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.getOnboardingSuggestedStarterPacks`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/unspecced/getOnboardingSuggestedStarterPacks.json
    public struct GetOnboardingSuggestedStarterPacksOutput: Sendable, Codable {

        /// An array of starter packs.
        public let starterPacks: [AppBskyLexicon.Graph.StarterPackViewDefinition]
    }
}

