//
//  ChatBskyNotificationGetPreferences.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-12.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ChatBskyLexicon.Notification {

    /// An output model for getting chat notification preferences for a user account.
    ///
    /// - Note: According to the AT Protocol specifications: "Get the requesting account's chat
    /// notification preferences. Defaults are returned for accounts that have not set any
    /// preferences. Requires auth."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.notification.getPreferences`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/notification/getPreferences.json
    public struct GetPreferencesOutput: Sendable, Codable {

        /// The chat notification preferences for the user account.
        public let preferences: ChatBskyLexicon.Notification.PreferencesDefinition
    }
}
