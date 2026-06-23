//
//  AppBskyDraftDeleteDraft.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-06-21.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Draft {

    /// A request body model for deleting a draft.
    ///
    /// - Note: According to the AT Protocol specifications: "Deletes a draft by ID.
    /// Requires authentication."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.draft.deleteDraft`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/draft/deleteDraft.json
    public struct DeleteDraftRequestBody: Sendable, Codable {

        /// The TID identifier of the draft to delete.
        public let id: String

        public init(id: String) {
            self.id = id
        }
    }
}
