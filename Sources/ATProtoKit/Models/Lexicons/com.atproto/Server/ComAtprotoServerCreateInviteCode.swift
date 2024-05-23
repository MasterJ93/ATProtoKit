//
//  ComAtprotoServerCreateInviteCode.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation

extension ComAtprotoLexicon.Server {

    /// A request body model for creating an invite code.
    ///
    /// - Note: According to the AT Protocol specifications: "Create invite code."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.createInviteCode`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/createInviteCode.json
    public struct CreateInviteCodeRequestBody: Codable {

        /// The number of times the invite code(s) can be used.
        public let useCount: Int

        /// The decentralized identifier (DIDs) of the user that can use the invite code. Optional.
        ///
        /// - Important: The item associated with this property is undocumented in the AT Protocol specifications. The documentation here is based on:\
        ///   \* **For items with some inferable context from property names or references**: its best interpretation, though not with full certainty.\
        ///   \* **For items without enough context for even an educated guess**: a direct acknowledgment of their undocumented status.\
        ///   \
        ///   Clarifications from Bluesky are needed in order to fully understand this item.
        public let forAccount: [String]?
    }

    /// An output model for creating an invite code.
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.createInviteCode`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/createInviteCode.json
    public struct CreateInviteCodeOutput: Codable {

        /// An array of invite codes.
        public let code: [String]
    }
}
