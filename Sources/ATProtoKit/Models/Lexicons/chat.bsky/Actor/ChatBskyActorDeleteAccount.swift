//
//  ChatBskyActorDeleteAccount.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension ChatBskyLexicon.Actor {

    /// A request body model for deleting an account.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.actor.deleteAccount`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/actor/deleteAccount.json
    public struct DeleteAccount: Codable {}
}
