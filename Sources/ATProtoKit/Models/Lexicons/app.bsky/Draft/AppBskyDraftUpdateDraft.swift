//
//  AppBskyDraftUpdateDraft.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-06-21.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Draft {

    /// A request body model for updating an existing draft.
    ///
    /// - Note: According to the AT Protocol specifications: "Updates a draft using private storage (stash). If the draft ID points to a non-existing ID, the update will be silently ignored. This is done because updates don't enforce draft limit, so it accepts all writes, but will ignore invalid ones.
    /// Requires authentication."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.draft.updateDraft`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/draft/updateDraft.json
    public struct UpdateDraftRequestBody: Sendable, Codable {

        /// The draft to be updated, containing its identifier.
        public let draft: AppBskyLexicon.Draft.DraftWithIdDefinition

        public init(draft: AppBskyLexicon.Draft.DraftWithIdDefinition) {
            self.draft = draft
        }
    }
}
