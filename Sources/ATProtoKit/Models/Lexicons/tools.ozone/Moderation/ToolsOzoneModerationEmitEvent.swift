//
//  ToolsOzoneModerationEmitEvent.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-21.
//

import Foundation

extension ToolsOzoneLexicon.Moderation {

    /// A request body model for enacting on an action against a user's account.
    ///
    /// - Note: According to the AT Protocol specifications: "Take a moderation action on an actor."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.emitEvent`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/emitEvent.json
    public struct EmitEventRequestBody: Codable {

        /// The type of event the moderator is taking,
        public let event: ATUnion.EmitEventUnion

        /// The type of repository reference.
        public let subject: ATUnion.EmitEventSubjectUnion

        /// An array of CID hashes related to blobs for the moderator's event view. Optional.
        public let subjectBlobCIDHashes: [String]?

        /// The decentralized identifier (DID) of the moderator taking this action.
        public let createdBy: String

        enum CodingKeys: String, CodingKey {
            case event
            case subject
            case subjectBlobCIDHashes = "subjectBlobCids"
            case createdBy
        }
    }
}
