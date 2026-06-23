//
//  AppBskyDraftGetDrafts.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-06-21.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Draft {

    /// An output model for retrieving drafts.
    ///
    /// - Note: According to the AT Protocol specifications: "Gets views of user drafts.
    /// Requires authentication."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.draft.getDrafts`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/draft/getDrafts.json
    public struct GetDraftsOutput: Sendable, Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of drafts.
        public let drafts: [AppBskyLexicon.Draft.DraftViewDefinition]
    }
}
