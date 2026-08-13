//
//  AppBskyContactGetMatches.swift
//  ATProtoKit
//
//  Created by KC-2001MS on 2026-08-02.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Contact {

    /// An output model for getting matched contacts.
    ///
    /// - Note: According to the AT Protocol specifications: "Returns the matched contacts
    /// (contacts that were mutually imported). Excludes dismissed matches.
    /// Requires authentication."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.contact.getMatches`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/contact/getMatches.json
    public struct GetMatchesOutput: Sendable, Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of matched user profiles.
        public let matches: [AppBskyLexicon.Actor.ProfileViewDefinition]
    }
}
