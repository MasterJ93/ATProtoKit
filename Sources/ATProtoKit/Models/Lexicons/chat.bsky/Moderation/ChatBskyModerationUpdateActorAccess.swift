//
//  ChatBskyModerationUpdateActorAccess.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension ChatBskyLexicon.Moderation {

    /// A request body model for updating the user account's access to direct messages.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.moderation.updateActorAccess`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/moderation/updateActorAccess.json
    public struct UpdateActorAccessRequestBody: Codable {

        /// The user account to change access to direct messages.
        public let actorDID: String

        /// Indicates whether the user account has access to direct messages.
        public let doesAllowAccess: Bool

        /// A reference object for the action taken.
        public let reference: String?

        enum CodingKeys: String, CodingKey {
            case actorDID = "did"
            case doesAllowAccess = "allowAccess"
            case reference = "ref"
        }
    }
}
