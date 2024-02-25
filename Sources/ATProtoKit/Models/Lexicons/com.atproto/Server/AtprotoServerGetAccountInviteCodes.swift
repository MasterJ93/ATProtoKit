//
//  AtprotoServerGetAccountInviteCodes.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-25.
//

import Foundation

/// A data model definition for the output of getting the invite codes of the user's account.
///
/// - SeeAlso: This is based on the [`com.atproto.server.getAccountInviteCodes`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/getAccountInviteCodes.json
public struct ServerGetAccountInviteCodesOutput: Codable {
    /// An array of the user's invite codes.
    public let code: [ServerInviteCode]
}
