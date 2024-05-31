//
//  ComAtprotoServerDeleteAccount.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation

extension ComAtprotoLexicon.Server {

    /// A request body model for deleting an account.
    ///
    /// - Note: According to the AT Protocol specifications: "Delete an actor's account with a
    /// token and password. Can only be called after requesting a deletion token. Requires auth."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.deleteAccount`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/deleteAccount.json
    public struct DeleteAccountRequestBody: Codable {

        /// The decentralized identifier (DID) of the account.
        public let accountDID: String

        /// The main password of the account.
        ///
        /// - Note: This is not the App Password.
        public let accountPassword: String

        /// - Important: The item associated with this property is undocumented in the AT Protocol specifications. The documentation here is based on:\
        ///   \* **For items with some inferable context from property names or references**: its best interpretation, though not with full certainty.\
        ///   \* **For items without enough context for even an educated guess**: a direct acknowledgment of their undocumented status.\
        ///   \
        ///   Clarifications from Bluesky are needed in order to fully understand this item.
        public let token: String
    }
}
