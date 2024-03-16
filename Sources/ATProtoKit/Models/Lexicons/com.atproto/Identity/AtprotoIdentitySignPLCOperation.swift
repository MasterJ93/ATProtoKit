//
//  AtprotoIdentitySignPLCOperation.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-16.
//

import Foundation

/// The main data model definition for signing a PLC operation to a DID document.
///
/// - Note: According to the AT Protocol specifications: "Signs a PLC operation to update some value(s) in the requesting DID's document."
///
/// - SeeAlso: This is based on the [`com.atproto.identity.signPlcOperation`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/identity/signPlcOperation.json
public struct IdentitySignPLCOperation: Codable {
    /// A token received from ``ATProtoKit/ATProtoKit/requestPLCOperationSignature()``. Optional.
    ///
    /// - Note: According to the AT Protocol specifications: "A token received through com.atproto.identity.requestPlcOperationSignature"
    public let token: String?
    /// The rotation keys recommended to be added in the DID document. Optional.
    public let rotationKeys: [String]?
    /// An array of aliases of the user account. Optional.
    public let alsoKnownAs: [String]?
    /// A verification method recommeneded to be added in the DID document. Optional.
    public let verificationMethods: VerificationMethod?
    /// The service endpoint recommended in the DID document. Optional.
    public let service: ATService?
}

/// The main data model definition for the output of signing a PLC operation to a DID document.
///
/// - Note: According to the AT Protocol specifications: "Signs a PLC operation to update some value(s) in the requesting DID's document."
///
/// - SeeAlso: This is based on the [`com.atproto.identity.signPlcOperation`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/identity/signPlcOperation.json
public struct IdentitySignPLCOperationOutput: Codable {
    public let operation: UnknownType
}
