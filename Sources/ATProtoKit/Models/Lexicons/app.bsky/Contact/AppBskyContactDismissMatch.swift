//
//  AppBskyContactDismissMatch.swift
//  ATProtoKit
//
//  Created by KC-2001MS on 2026-08-02.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Contact {

    /// A request body model for dismissing a contact match.
    ///
    /// - Note: According to the AT Protocol specifications: "Removes a match that was found via
    /// contact import. It shouldn't appear again if the same contact is re-imported.
    /// Requires authentication."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.contact.dismissMatch`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/contact/dismissMatch.json
    public struct DismissMatchRequestBody: Sendable, Codable {

        /// The decentralized identifier (DID) of the subject to dismiss the match with.
        public let subjectDID: String

        public init(subjectDID: String) {
            self.subjectDID = subjectDID
        }

        enum CodingKeys: String, CodingKey {
            case subjectDID = "subject"
        }
    }
}
