//
//  ComAtprotoServerCreateInviteCodes.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation

extension ComAtprotoLexicon.Server {

    /// A definition model for creating invite codes.
    public struct CreateInviteCodes: Sendable, Codable {

        /// The server invite codes generated from ``ComAtprotoLexicon/Server/CreateInviteCodesOutput``.
        ///
        /// - SeeAlso: This is based on the [`com.atproto.server.createInviteCodes`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/createInviteCodes.json
        public struct AccountCodes: Sendable, Codable {

            /// The user account that holds the invite codes.
            public let account: String

            /// An array of invite codes.
            public let codes: [String]
        }
    }

    /// A request body model for creating invite codes.
    ///
    /// - Note: According to the AT Protocol specifications: "Create invite codes."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.createInviteCodes`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/createInviteCodes.json
    public struct CreateInviteCodesRequestBody: Sendable, Codable {

        /// The number of invite codes to create. Defaults to 1.
        public var codeCount: Int = 1

        /// The number of times the invite code(s) can be used.
        public let useCount: Int

        /// An array of decentralized identifiers (DIDs) that can use the invite codes. Optional.
        public let forAccounts: [String]?
    }

    /// An output model for creating invite codes.
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.createInviteCodes`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/createInviteCodes.json
    public struct CreateInviteCodesOutput: Sendable, Codable {

        /// An array of invite codes.
        public let codes: [CreateInviteCodes.AccountCodes]
    }
}
