//
//  ComAtprotoServerCreateInviteCodes.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation

extension ComAtprotoLexicon.Server {

    /// The main data model definition for creating invite codes.
    ///
    /// - Note: According to the AT Protocol specifications: "Create invite codes."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.createInviteCodes`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/createInviteCodes.json
    public struct CreateInviteCodes: Codable {

        /// The number of invite codes to create. Defaults to 1.
        public var codeCount: Int = 1

        /// The number of times the invite code(s) can be used.
        public let useCount: Int

        /// An array of decentralized identifiers (DIDs) that can use the invite codes. Optional.
        ///
        /// - Important: The item associated with this property is undocumented in the AT Protocol specifications. The documentation here is based on:\
        ///   \* **For items with some inferable context from property names or references**: its best interpretation, though not with full certainty.\
        ///   \* **For items without enough context for even an educated guess**: a direct acknowledgment of their undocumented status.\
        ///   \
        ///   Clarifications from Bluesky are needed in order to fully understand this item.
        public let forAccounts: [String]?
    }

    /// A data model definition of the output for creating invite codes.
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.createInviteCodes`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/createInviteCodes.json
    public struct CreateInviteCodesOutput: Codable {

        /// An array of invite codes.
        public let codes: [ServerAccountCodes]
    }

    /// A data model definition of the server invite codes generated from
    /// ``ServerCreateInviteCodes``.
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.createInviteCodes`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/createInviteCodes.json
    public struct ServerAccountCodes: Codable {

        /// The account that holds the invite codes.
        ///
        /// - Important: The item associated with this property is undocumented in the AT Protocol specifications. The documentation here is based on:\
        ///   \* **For items with some inferable context from property names or references**: its best interpretation, though not with full certainty.\
        ///   \* **For items without enough context for even an educated guess**: a direct acknowledgment of their undocumented status.\
        ///   \
        ///   Clarifications from Bluesky are needed in order to fully understand this item.
        public let account: String

        /// An array of invite codes.
        public let codes: [String]
    }
}
