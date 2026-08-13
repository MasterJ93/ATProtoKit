//
//  AppBskyContactRemoveData.swift
//  ATProtoKit
//
//  Created by KC-2001MS on 2026-08-02.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Contact {

    /// A request body model for removing contact data.
    ///
    /// - Note: According to the AT Protocol specifications: "Removes all stored hashes used for
    /// contact matching, existing matches, and sync status. Requires authentication."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.contact.removeData`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/contact/removeData.json
    public struct RemoveDataRequestBody: Sendable, Encodable {

        public init() {}
    }
}
