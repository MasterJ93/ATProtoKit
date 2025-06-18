//
//  ComAtprotoIdentityDefs.swift
//
//
//  Created by Christopher Jr Riley on 2025-02-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ComAtprotoLexicon.Identity {

    /// A definition model for information about a user account.
    ///
    /// - SeeAlso: This is based on the [`com.atproto.identity.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/identity/defs.json
    public struct IdentityInfoDefinition: Sendable, Codable {

        /// The decentralized identifier (DID) of the identity.
        public let did: String

        /// The handle of the identity.
        ///
        /// - Note: According to the AT Protocol specifications: "The validated handle of the account; or 'handle.invalid' if the handle did not bi-directionally match the DID document."
        public let handle: String

        /// The DID document of the identity.
        ///
        /// - Note: According to the AT Protocol specifications: "The complete DID document for the identity."
        public let didDocument: UnknownType

        enum CodingKeys: String, CodingKey {
            case did
            case handle
            case didDocument = "didDoc"
        }
    }
}
