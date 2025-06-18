//
//  ComAtprotoServerCreateInviteCode.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ComAtprotoLexicon.Server {

    /// A request body model for creating an invite code.
    ///
    /// - Note: According to the AT Protocol specifications: "Create invite code."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.createInviteCode`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/createInviteCode.json
    public struct CreateInviteCodeRequestBody: Sendable, Codable {

        /// The number of times the invite code(s) can be used.
        public let useCount: Int

        /// The decentralized identifier (DID) of the users that can use the invite code. Optional.
        public let forAccount: String
    }

    /// An output model for creating an invite code.
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.createInviteCode`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/createInviteCode.json
    public struct CreateInviteCodeOutput: Sendable, Codable {

        /// An array of invite codes.
        public let code: [String]
    }
}
