//
//  AtprotoIdentitySubmitPLCOperation.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-16.
//

import Foundation

/// The main data model definition for the output of validating a PLC operation.
///
/// - Note: According to the AT Protocol specifications: "Validates a PLC operation to ensure that it doesn't violate a service's constraints
/// or get the identity into a bad state, then submits it to the PLC registry."
///
/// - SeeAlso: This is based on the [`com.atproto.identity.submitPlcOperation`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/identity/submitPlcOperation.json
public struct IdentitySubmitPLCOperationOutput: Codable {
    /// The operation itself.
    public let operation: UnknownType
}
