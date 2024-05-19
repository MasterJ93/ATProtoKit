//
//  ChatBskyConvoDefs.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension ChatBskyLexicon.Conversation {

    /// The main data model definition for a messafe reference.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/defs.json
    public struct MessageReference: Codable {

        /// The decentralized identifier (DID) of the message.
        public let messageDID: String

        /// The ID of the message.
        public let messageID: String

        enum CodingKeys: String, CodingKey {
            case messageDID = "did"
            case messageID = "messageId"
        }
    }

    /// The main data model definition for a message.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/defs.json
    public struct Message: Codable {
        
        /// The ID of the message. Optional.
        public let messageID: String?

        /// The message text itself.
        ///
        /// - Important: Current maximum length is 1,000 characters.
        public let text: String

        /// An array of facets contained in the message's text. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Annotations of text (mentions,
        /// URLs, hashtags, etc)"
        public let facets: [AppBskyLexicon.RichText.Facet]?

        /// An array of embeds for the message. Optional.
        public let embeds: [ATUnion.MessageEmbedUnion]?

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encodeIfPresent(self.messageID, forKey: .messageID)
            // Truncate `tags` to 10000 characters before encoding
            // `maxGraphemes`'s limit is 1000, but `String.count` should respect that limit implictly
            try truncatedEncode(self.text, withContainer: &container, forKey: .text, upToLength: 1_000)
            try container.encodeIfPresent(self.facets, forKey: .facets)
            try container.encodeIfPresent(self.embeds, forKey: .embeds)
        }

        enum CodingKeys: String, CodingKey {
            case messageID = "id"
            case text
            case facets
            case embeds = "embed"
        }
    }

    /// The main data model definition for a message view.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/defs.json
    public struct MessageView: Codable {

        /// The ID of the message. Optional.
        public let messageID: String?

        /// The revision of the message.
        public let revision: String

        /// The message text itself.
        ///
        /// - Important: Current maximum length is 1,000 characters.
        public let text: String

        /// An array of facets contained in the message's text. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Annotations of text (mentions,
        /// URLs, hashtags, etc)"
        public let facets: [AppBskyLexicon.RichText.Facet]?

        /// An array of embeds for the message. Optional.
        public let embeds: [ATUnion.MessageEmbedUnion]?

        /// The sender of the message.
        public let sender: String

        /// The date and time the message was seen.
        @DateFormatting public var seenAt: Date

        public init(messageID: String?, revision: String, text: String, facets: [AppBskyLexicon.RichText.Facet]?, embeds: [ATUnion.MessageEmbedUnion]?, sender: String, seenAt: Date) {
            self.messageID = messageID
            self.revision = revision
            self.text = text
            self.facets = facets
            self.embeds = embeds
            self.sender = sender
            self._seenAt = DateFormatting(wrappedValue: seenAt)
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.messageID = try container.decodeIfPresent(String.self, forKey: .messageID)
            self.revision = try container.decode(String.self, forKey: .revision)
            self.text = try container.decode(String.self, forKey: .text)
            self.facets = try container.decodeIfPresent([AppBskyLexicon.RichText.Facet].self, forKey: .facets)
            self.embeds = try container.decodeIfPresent([ATUnion.MessageEmbedUnion].self, forKey: .embeds)
            self.sender = try container.decode(String.self, forKey: .sender)
            self.seenAt = try container.decode(DateFormatting.self, forKey: .seenAt).wrappedValue
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encodeIfPresent(self.messageID, forKey: .messageID)
            try container.encode(self.revision, forKey: .revision)
            // Truncate `tags` to 10000 characters before encoding
            // `maxGraphemes`'s limit is 1000, but `String.count` should respect that limit implictly
            try truncatedEncode(self.text, withContainer: &container, forKey: .text, upToLength: 1_000)
            try container.encodeIfPresent(self.facets, forKey: .facets)
            try container.encodeIfPresent(self.embeds, forKey: .embeds)
            try container.encode(self.sender, forKey: .sender)
            try container.encode(self._seenAt, forKey: .seenAt)
        }

        public enum CodingKeys: String, CodingKey {
            case messageID = "id"
            case revision = "rev"
            case text
            case facets
            case embeds = "embed"
            case sender
            case seenAt
        }
    }

    /// The main data model definition for a deleted message view.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/defs.json
    public struct DeleteMessageView: Codable {
        
        /// The ID of the message. Optional.
        public let messageID: String?

        /// The revision of the message.
        public let revision: String

        /// The sender of the message.
        public let sender: String

        /// The date and time the message was seen.
        @DateFormatting public var seenAt: Date

        public init(messageID: String?, revision: String, sender: String, seenAt: Date) {
            self.messageID = messageID
            self.revision = revision
            self.sender = sender
            self._seenAt = DateFormatting(wrappedValue: seenAt)
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.messageID = try container.decodeIfPresent(String.self, forKey: .messageID)
            self.revision = try container.decode(String.self, forKey: .revision)
            self.sender = try container.decode(String.self, forKey: .sender)
            self.seenAt = try container.decode(DateFormatting.self, forKey: .seenAt).wrappedValue
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encodeIfPresent(self.messageID, forKey: .messageID)
            try container.encode(self.revision, forKey: .revision)
            try container.encode(self.sender, forKey: .sender)
            try container.encode(self._seenAt, forKey: .seenAt)
        }

        enum CodingKeys: String, CodingKey {
            case messageID = "id"
            case revision = "rev"
            case sender
            case seenAt
        }
    }

    /// The main data model definition for the message view's sender.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/defs.json
    public struct MessageViewSender: Codable {
        
        /// The decentralized identifier (DID) of the message.
        public let messageDID: String

        enum CodingKeys: String, CodingKey {
            case messageDID = "did"
        }
    }

    /// The main data model definition for a conversation view.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/defs.json
    public struct ConversationView: Codable {

        /// The ID of the conversation.
        public let conversationID: String

        /// The revision of the conversation.
        public let revision: String

        /// An array of basic profile views within the conversation.
        public let members: [ChatBskyLexicon.Actor.ProfileViewBasicDefinition]

        /// The last message in the conversation. Optional.
        public let lastMessage: ATUnion.MessageViewUnion?

        /// Indicates whether the conversation is muted.
        public let isMuted: Bool

        /// The number of messages that haven't been read.
        public let unreadCount: Int

        enum CodingKeys: String, CodingKey {
            case conversationID = "id"
            case revision = "rev"
            case members
            case lastMessage
            case isMuted = "muted"
            case unreadCount
        }
    }

    /// The main data model definition for a log for beginning the coversation.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/defs.json
    public struct LogBeginConversation: Codable {

        /// The revision of the log.
        public let revision: String

        /// The ID of the conversation.
        public let conversationID: String

        enum CodingKeys: String, CodingKey {
            case revision = "rev"
            case conversationID = "convoID"
        }
    }

    /// The main data model definition for a log for leaving the conversation.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/defs.json
    public struct LogLeaveConversation: Codable {

        /// The revision of the log.
        public let revision: String

        /// The ID of the conversation.
        public let conversationID: String

        enum CodingKeys: String, CodingKey {
            case revision = "rev"
            case conversationID = "convoID"
        }
    }

    /// The main data model definition for a log for creating a message.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/defs.json
    public struct LogCreateMessage: Codable {

        /// The revision of the log.
        public let revision: String

        /// The ID of the conversation.
        public let conversationID: String

        /// The message itself.
        public let message: ATUnion.MessageViewUnion

        enum CodingKeys: String, CodingKey {
            case revision = "rev"
            case conversationID = "convoID"
            case message
        }
    }

    /// The main data model definition for a log for deleting a message.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/defs.json
    public struct LogDeleteMessage: Codable {

        /// The revision of the log.
        public let revision: String

        /// The ID of the conversation.
        public let conversationID: String

        /// The message itself.
        public let message: ATUnion.MessageViewUnion

        enum CodingKeys: String, CodingKey {
            case revision = "rev"
            case conversationID = "convoID"
            case message
        }
    }
}
