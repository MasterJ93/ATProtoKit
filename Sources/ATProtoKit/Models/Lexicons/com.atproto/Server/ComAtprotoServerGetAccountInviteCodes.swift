//
//  ComAtprotoServerGetAccountInviteCodes.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation

extension ComAtprotoLexicon.Server {

    /// An output model for getting the invite codes of the user's account.
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.getAccountInviteCodes`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/getAccountInviteCodes.json
    public struct GetAccountInviteCodesOutput: Codable {

        /// An array of the user's invite codes.
        public let code: [ComAtprotoLexicon.Server.InviteCodeDefinition]
    }
}
