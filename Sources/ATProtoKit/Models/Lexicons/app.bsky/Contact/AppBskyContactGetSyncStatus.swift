//
//  AppBskyContactGetSyncStatus.swift
//  ATProtoKit
//
//  Created by KC-2001MS on 2026-08-02.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Contact {

    /// An output model for getting the contact sync status.
    ///
    /// - Note: According to the AT Protocol specifications: "Gets the user's current contact
    /// import status. Requires authentication."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.contact.getSyncStatus`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/contact/getSyncStatus.json
    public struct GetSyncStatusOutput: Sendable, Codable {

        /// The user's current contact sync status. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "If present, indicates the user
        /// has imported their contacts. If not present, indicates the user never used the feature
        /// or called `app.bsky.contact.removeData` and didn't import again since."
        public let syncStatus: AppBskyLexicon.Contact.SyncStatusDefinition?
    }
}
