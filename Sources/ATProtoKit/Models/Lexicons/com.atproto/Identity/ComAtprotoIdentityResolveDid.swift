//
//  ComAtprotoIdentityResolveDid.swift
//
//
//  Created by Christopher Jr Riley on 2025-02-26.
//

import Foundation

extension ComAtprotoLexicon.Identity {

    /// An output model for resolving the decentralized identifier (DID) to the equivalent
    /// DID document.
    ///
    /// - Note: According to the AT Protocol specifications: "Resolves DID to DID document.
    /// Does not bi-directionally verify handle."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.identity.resolveDid`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/identity/resolveDid.json
    public struct ResolveDIDOutput: Sendable, Codable {

        /// The DID document of the user account.
        ///
        /// - Note: According to the AT Protocol specifications: "The complete DID document for
        /// the identity."
        public let didDocument: UnknownType

        enum CodingKeys: String, CodingKey {
            case didDocument = "didDoc"
        }
    }
}
