//
//  AppBskyUnspeccedGetOnboardingSuggestedStarterPacksSkeleton.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-10-02.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Unspecced {

    /// An output model for retrieving the skeleton of suggested starterpacks for onboarding, intended to be
    /// called and hydrated by `app.bsky.unspecced.getOnboardingSuggestedStarterPacks`.
    ///
    /// - Note: According to the AT Protocol specifications: "Get a skeleton of suggested starterpacks
    /// for onboarding. Intended to be called and hydrated
    /// by app.bsky.unspecced.getOnboardingSuggestedStarterPacks"
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.getOnboardingSuggestedStarterPacksSkeleton`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/unspecced/getOnboardingSuggestedStarterPacksSkeleton.json
    public struct GetOnboardingSuggestedStarterPacksSkeletonOutput: Sendable, Codable {

        /// An array of starter packs.
        public let starterPacks: [AppBskyLexicon.Graph.StarterPackViewDefinition]
    }
}

