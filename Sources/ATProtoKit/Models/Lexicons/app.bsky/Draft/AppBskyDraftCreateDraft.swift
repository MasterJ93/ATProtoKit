//
//  AppBskyDraftCreateDraft.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-06-21.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Draft {

    /// A request body model for creating a draft.
    ///
    /// - Note: According to the AT Protocol specifications: "Inserts a draft using private storage (stash). An upper limit of drafts might be enforced.
    /// Requires authentication."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.draft.createDraft`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/draft/createDraft.json
    public struct CreateDraftRequestBody: Sendable, Codable {

        /// The draft to be created.
        public let draft: AppBskyLexicon.Draft.DraftDefinition

        public init(draft: AppBskyLexicon.Draft.DraftDefinition) {
            self.draft = draft
        }
    }

    /// An output model for creating a draft.
    ///
    /// - Note: According to the AT Protocol specifications: "Creates a draft.
    /// Requires authentication."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.draft.createDraft`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/draft/createDraft.json
    public struct CreateDraftOutput: Sendable, Codable {

        /// The TID identifier assigned to the newly-created draft.
        public let id: String
    }
}
