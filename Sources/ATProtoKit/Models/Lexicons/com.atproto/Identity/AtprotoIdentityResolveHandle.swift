//
//  AtprotoIdentityResolveHandle.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-27.
//

import Foundation

// MARK: - Main definition
/// The main data model definition for resolving handles.
///
/// - Note: According to the AT Protocol specifications: "Resolves a handle (domain name) to a DID."
///
/// - SeeAlso: This is based on the [`com.atproto.identity.resolveHandle`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/identity/resolveHandle.json
public struct ResolveHandleQuery: Encodable {
    /// The handle to be resolved.
    ///
    /// - Important: Be sure to remove the "@" before entering the value.
    public let handle: String
}

// MARK: -
/// A data model that represents the output of resolving handles.
///
/// - SeeAlso: This is based on the [`com.atproto.identity.resolveHandle`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/identity/resolveHandle.json
public struct ResolveHandleOutput: Decodable {
    /// The resolved handle's decentralized identifier (DID).
    public let handleDID: String
}
