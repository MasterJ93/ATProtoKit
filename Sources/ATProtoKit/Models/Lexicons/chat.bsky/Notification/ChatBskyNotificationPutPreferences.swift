//
//  ChatBskyNotificationPutPreferences.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-12.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ChatBskyLexicon.Notification {

    /// A request body model for setting chat notification preferences for a user account.
    ///
    /// - Note: According to the AT Protocol specifications: "Set the requesting account's chat
    /// notification preferences. Only the provided preferences are updated; omitted preferences
    /// are left unchanged."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.notification.putPreferences`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/notification/putPreferences.json
    public struct PutPreferencesRequestBody: Sendable, Codable {

        /// Notification preferences for accepted conversations. Optional.
        public let chat: ChatBskyLexicon.Notification.ChatPreferenceDefinition?

        /// Notification preferences for conversation requests. Optional.
        public let chatRequest: ChatBskyLexicon.Notification.ChatPreferenceDefinition?
    }

    /// An output model for setting chat notification preferences for a user account.
    ///
    /// - Note: According to the AT Protocol specifications: "Set the requesting account's chat
    /// notification preferences. Only the provided preferences are updated; omitted preferences
    /// are left unchanged."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.notification.putPreferences`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/notification/putPreferences.json
    public struct PutPreferencesOutput: Sendable, Codable {

        /// The updated chat notification preferences.
        public let preferences: ChatBskyLexicon.Notification.PreferencesDefinition
    }
}
