//
//  AtprotoServerCreateInviteCode.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-24.
//

import Foundation

/// The main data model definition for creating an invite code.
///
/// - Note: According to the AT Protocol specifications: "Create invite code."
///
/// - SeeAlso: This is based on the [`com.atproto.server.createInviteCode`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/createInviteCode.json
public struct ServerCreateInviteCode: Codable {
    /// The number of times the invite code(s) can be used.
    public let useCount: Int
    /// The decentralized identifier (DIDs) of the user that can use the invite code. Optional.
    ///
    /// - Important: The item associated with this property is undocumented in the AT Protocol specifications. The documentation here is based on:\
    ///   \* **For items with some inferable context from property names or references**: its best interpretation, though not with full certainty.\
    ///   \* **For items without enough context for even an educated guess**: a direct acknowledgment of their undocumented status.\
    ///   Clarifications from Bluesky are needed in order to fully understand the this item.
    public let forAccount: [String]?
}

/// A data model definition of the output for creating an invite code.
///
/// - SeeAlso: This is based on the [`com.atproto.server.createInviteCode`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/createInviteCode.json
public struct ServerCreateInviteCodeOutput: Codable {
    /// An array of invite codes.
    public let code: [String]
}
