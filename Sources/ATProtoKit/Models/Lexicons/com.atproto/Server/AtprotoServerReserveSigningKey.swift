//
//  AtprotoServerReserveSigningKey.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-25.
//

import Foundation

/// The main data model definition for reversing signing keys.
///
/// - Note: According to the AT Protocol specifications: "Reserve a repo signing key, for use with account creation. Necessary so that a DID PLC update operation can be constructed during an account migraiton. Public and does not require auth; implemented by PDS. NOTE: this endpoint may change when full account migration is implemented."
///
/// - SeeAlso: This is based on the [`com.atproto.server.reserveSigningKey`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/reserveSigningKey.json
public struct ServerReserveSigningKey: Codable {
    /// The decentralized identifier (DID) of the repository that will use the signing key.
    ///
    /// - Note: According to the AT Protocol specifications: "The DID to reserve a key for."
    public let repositoryDID: String

    enum CodingKeys: String, CodingKey {
        case repositoryDID = "did"
    }
}

/// A data model definition for the output of reversing a signing keys.
///
/// - SeeAlso: This is based on the [`com.atproto.server.reserveSigningKey`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/reserveSigningKey.json
public struct ServerReserveSigningKeyOutput: Codable {
    /// The signing key itself.
    ///
    /// - Note: According to the AT Protocol specifications: "The public key for the reserved signing key, in did:key serialization."
    public let signingKey: String
}
