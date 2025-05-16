//
//  ChatBskyConvoDefs.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension ChatBskyLexicon.Conversation {

    /// A definition model for a message reference.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/defs.json
    public struct MessageReferenceDefinition: Sendable, Codable {

        /// The decentralized identifier (DID) of the message.
        public let authorDID: String

        /// The ID of the message.
        public let messageID: String

        /// The ID of the conversation.
        public let conversationID: String

        enum CodingKeys: String, CodingKey {
            case authorDID = "did"
            case messageID = "messageId"
            case conversationID = "convoId"
        }
    }

    /// A definition model for a message.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/defs.json
    public struct MessageInputDefinition: Sendable, Codable {

        /// The message text itself.
        ///
        /// - Important: Current maximum length is 1,000 characters.
        public let text: String

        /// An array of facets contained in the message's text. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Annotations of text (mentions,
        /// URLs, hashtags, etc)"
        public let facets: [AppBskyLexicon.RichText.Facet]?

        /// An embed for the message. Optional.
        public let embed: ATUnion.MessageInputEmbedUnion?

        public init(text: String, facets: [AppBskyLexicon.RichText.Facet]? = nil, embed: ATUnion.MessageInputEmbedUnion? = nil) {
            self.text = text
            self.facets = facets
            self.embed = embed
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.truncatedEncode(self.text, forKey: .text, upToCharacterLength: 1_000)
            try container.encodeIfPresent(self.facets, forKey: .facets)
            try container.encodeIfPresent(self.embed, forKey: .embed)
        }

        enum CodingKeys: CodingKey {
            case text
            case facets
            case embed
        }
    }

    /// A definition model for a message view.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/defs.json
    public struct MessageViewDefinition: Sendable, Codable {

        /// The ID of the message.
        public let messageID: String

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

        /// An embed for the message. Optional.
        public let embed: ATUnion.MessageInputEmbedUnion?

        /// An array of reactions. Optional.
        public let reactions: [ChatBskyLexicon.Conversation.ReactionViewDefinition]?

        /// The sender of the message.
        public let sender: MessageViewSenderDefinition

        /// The date and time the message was seen.
        public let sentAt: Date

        public init(messageID: String, revision: String, text: String, facets: [AppBskyLexicon.RichText.Facet]?, embed: ATUnion.MessageInputEmbedUnion?,
                    reactions: [ChatBskyLexicon.Conversation.ReactionViewDefinition]?, sender: MessageViewSenderDefinition, sentAt: Date) {
            self.messageID = messageID
            self.revision = revision
            self.text = text
            self.facets = facets
            self.embed = embed
            self.reactions = reactions
            self.sender = sender
            self.sentAt = sentAt
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.messageID = try container.decode(String.self, forKey: .messageID)
            self.revision = try container.decode(String.self, forKey: .revision)
            self.text = try container.decode(String.self, forKey: .text)
            self.facets = try container.decodeIfPresent([AppBskyLexicon.RichText.Facet].self, forKey: .facets)
            self.embed = try container.decodeIfPresent(ATUnion.MessageInputEmbedUnion.self, forKey: .embed)
            self.reactions = try container.decodeIfPresent([ChatBskyLexicon.Conversation.ReactionViewDefinition].self, forKey: .reactions)
            self.sender = try container.decode(MessageViewSenderDefinition.self, forKey: .sender)
            self.sentAt = try container.decodeDate(forKey: .sentAt)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.messageID, forKey: .messageID)
            try container.encode(self.revision, forKey: .revision)
            try container.truncatedEncode(self.text, forKey: .text, upToCharacterLength: 1_000)
            try container.encodeIfPresent(self.facets, forKey: .facets)
            try container.encodeIfPresent(self.embed, forKey: .embed)
            try container.encodeIfPresent(self.reactions, forKey: .reactions)
            try container.encode(self.sender, forKey: .sender)
            try container.encodeDate(self.sentAt, forKey: .sentAt)
        }

        public enum CodingKeys: String, CodingKey {
            case messageID = "id"
            case revision = "rev"
            case text
            case facets
            case embed
            case reactions
            case sender
            case sentAt
        }
    }

    /// A definition model for a deleted message view.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/defs.json
    public struct DeletedMessageViewDefinition: Sendable, Codable {

        /// The ID of the message.
        public let messageID: String

        /// The revision of the message.
        public let revision: String

        /// The sender of the message.
        public let sender: MessageViewSenderDefinition

        /// The date and time the message was sent.
        public let sentAt: Date

        public init(messageID: String, revision: String, sender: MessageViewSenderDefinition, sentAt: Date) {
            self.messageID = messageID
            self.revision = revision
            self.sender = sender
            self.sentAt = sentAt
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.messageID = try container.decode(String.self, forKey: .messageID)
            self.revision = try container.decode(String.self, forKey: .revision)
            self.sender = try container.decode(MessageViewSenderDefinition.self, forKey: .sender)
            self.sentAt = try container.decodeDate(forKey: .sentAt)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.messageID, forKey: .messageID)
            try container.encode(self.revision, forKey: .revision)
            try container.encode(self.sender, forKey: .sender)
            try container.encodeDate(self.sentAt, forKey: .sentAt)
        }

        enum CodingKeys: String, CodingKey {
            case messageID = "id"
            case revision = "rev"
            case sender
            case sentAt
        }
    }

    /// A definition model for the message view's sender.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/defs.json
    public struct MessageViewSenderDefinition: Sendable, Codable {

        /// The decentralized identifier (DID) of the message.
        public let authorDID: String

        enum CodingKeys: String, CodingKey {
            case authorDID = "did"
        }
    }

    /// A definition model for reaction view.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/defs.json
    public struct ReactionViewDefinition: Sendable, Codable {

        /// The value of the reaction.
        public let value: String

        /// The sender of the reaction.
        public let sender: ChatBskyLexicon.Conversation.ReactionViewSenderDefinition

        /// The date and time of the reaction.
        public let createdAt: Date
    }

    /// A definition model for the sender of the reaction.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/defs.json
    public struct ReactionViewSenderDefinition: Sendable, Codable {

        /// The decentralized identifier (DID) of the user account that sent the reaction.
        public let did: String
    }

    /// A definition model for a view containing a message and reaction.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/defs.json
    public struct MessageAndReactionViewDefinition: Sendable, Codable {

        /// The message itself.
        public let message: ChatBskyLexicon.Conversation.MessageViewDefinition

        /// The reaction attached to the message.
        public let reaction: ChatBskyLexicon.Conversation.ReactionViewDefinition
    }

    /// A definition model for a conversation view.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/defs.json
    public struct ConversationViewDefinition: Sendable, Codable {

        /// The ID of the conversation.
        public let conversationID: String

        /// The revision of the conversation.
        public let revision: String

        /// An array of basic profile views within the conversation.
        public let members: [ChatBskyLexicon.Actor.ProfileViewBasicDefinition]

        /// The last message in the conversation. Optional.
        public let lastMessage: LastMessageUnion?

        /// The last reaction in the conversation. Optional.
        public let lastReaction: LastReactionUnion?

        /// Indicates whether the conversation is muted.
        public let isMuted: Bool

        /// The status of the conversation.
        public let status: Status

        /// The number of messages that haven't been read.
        public let unreadCount: Int

        enum CodingKeys: String, CodingKey {
            case conversationID = "id"
            case revision = "rev"
            case members
            case lastMessage
            case lastReaction
            case isMuted = "muted"
            case status
            case unreadCount
        }

        // Enums
        /// The status of the conversation.
        public enum Status: String, Sendable, Codable {

            /// The conversation is waiting to be accepted.
            case request

            /// The conversation has been accepted.
            case accepted
        }

        // Unions
        /// A reference containing the list of messages.
        public enum LastMessageUnion: Sendable, Codable {

            /// A message view.
            case messageView(ChatBskyLexicon.Conversation.MessageViewDefinition)

            /// A deleted message view.
            case deletedMessageView(ChatBskyLexicon.Conversation.DeletedMessageViewDefinition)

            public init(from decoder: any Decoder) throws {
                let container = try decoder.singleValueContainer()

                if let value = try? container.decode(ChatBskyLexicon.Conversation.MessageViewDefinition.self) {
                    self = .messageView(value)
                } else if let value = try? container.decode(ChatBskyLexicon.Conversation.DeletedMessageViewDefinition.self) {
                    self = .deletedMessageView(value)
                } else {
                    throw DecodingError.typeMismatch(
                        LastMessageUnion.self, DecodingError.Context(
                            codingPath: decoder.codingPath, debugDescription: "Unknown LastMessageUnion type"))
                }
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.singleValueContainer()

                switch self {
                    case .messageView(let messageView):
                        try container.encode(messageView)
                    case .deletedMessageView(let deletedMessageView):
                        try container.encode(deletedMessageView)
                }
            }
        }

        /// A reference containing the list containing a message and reaction.
        public enum LastReactionUnion: Sendable, Codable {

            /// A view containing a message and reaction.
            case messageAndReactionView(ChatBskyLexicon.Conversation.MessageAndReactionViewDefinition)

            public init(from decoder: Decoder) throws {
                let container = try decoder.singleValueContainer()

                if let value = try? container.decode(ChatBskyLexicon.Conversation.MessageAndReactionViewDefinition.self) {
                    self = .messageAndReactionView(value)
                } else {
                    throw DecodingError.typeMismatch(
                        LastReactionUnion.self, DecodingError.Context(
                            codingPath: decoder.codingPath, debugDescription: "Unknown LastReactionUnion type"))
                }
            }
        }
    }

    /// A definition model for a log for beginning the coversation.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/defs.json
    public struct LogBeginConversationDefinition: Sendable, Codable {

        /// The revision of the log.
        public let revision: String

        /// The ID of the conversation.
        public let conversationID: String

        enum CodingKeys: String, CodingKey {
            case revision = "rev"
            case conversationID = "convoID"
        }
    }

    /// A definition model for a log for accepting the conversation.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/defs.json
    public struct LogAcceptConversationDefinition: Sendable, Codable {

        /// The revision of the log.
        public let revision: String

        /// The ID of the conversation.
        public let conversationID: String

        enum CodingKeys: String, CodingKey {
            case revision = "rev"
            case conversationID = "convoID"
        }
    }

    /// A definition model for a log for leaving the conversation.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/defs.json
    public struct LogLeaveConversationDefinition: Sendable, Codable {

        /// The revision of the log.
        public let revision: String

        /// The ID of the conversation.
        public let conversationID: String

        enum CodingKeys: String, CodingKey {
            case revision = "rev"
            case conversationID = "convoID"
        }
    }

    /// A definition model for a log for muting a conversation.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/defs.json
    public struct LogMuteConversationDefinition: Sendable, Codable {

        /// The revision of the log.
        public let revision: String

        /// The ID of the conversation.
        public let conversationID: String

        enum CodingKeys: String, CodingKey {
            case revision = "rev"
            case conversationID = "convoID"
        }
    }

    /// A definition model for a log for unmuting a conversation.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/defs.json
    public struct LogUnmuteConversationDefinition: Sendable, Codable {

        /// The revision of the log.
        public let revision: String

        /// The ID of the conversation.
        public let conversationID: String

        enum CodingKeys: String, CodingKey {
            case revision = "rev"
            case conversationID = "convoID"
        }
    }

    /// A definition model for a log for creating a message.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/defs.json
    public struct LogCreateMessageDefinition: Sendable, Codable {

        /// The revision of the log.
        public let revision: String

        /// The ID of the conversation.
        public let conversationID: String

        /// The message itself.
        public let message: ATUnion.LogCreateMessageUnion

        enum CodingKeys: String, CodingKey {
            case revision = "rev"
            case conversationID = "convoID"
            case message
        }
    }

    /// A definition model for a log for deleting a message.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/defs.json
    public struct LogDeleteMessageDefinition: Sendable, Codable {

        /// The revision of the log.
        public let revision: String

        /// The ID of the conversation.
        public let conversationID: String

        /// The message itself.
        public let message: ATUnion.LogDeleteMessageUnion

        enum CodingKeys: String, CodingKey {
            case revision = "rev"
            case conversationID = "convoID"
            case message
        }
    }

    /// A definition model for a log for reading a message.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/defs.json
    public struct LogReadMessageDefinition: Sendable, Codable {

        /// The revision of the log.
        public let revision: String

        /// The ID of the conversation.
        public let conversationID: String

        /// The message itself.
        public let message: ATUnion.LogReadMessageUnion

        enum CodingKeys: String, CodingKey {
            case revision = "rev"
            case conversationID = "convoID"
            case message
        }
    }

    /// A definition model for a log for adding a reaction.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/defs.json
    public struct LogAddReactionViewDefinition: Sendable, Codable {

        /// The revision of the log.
        public let revision: String

        /// The ID of the conversation.
        public let conversationID: String

        /// The message itself.
        public let message: MessageUnion

        enum CodingKeys: String, CodingKey {
            case revision = "rev"
            case conversationID = "convoID"
            case message
        }

        // Unions
        /// A reference containing the list of messages.
        public enum MessageUnion: Sendable, Codable {

            /// A message view.
            case messageView(ChatBskyLexicon.Conversation.MessageViewDefinition)

            /// A deleted message view.
            case deletedMessageView(ChatBskyLexicon.Conversation.DeletedMessageViewDefinition)

            public init(from decoder: any Decoder) throws {
                let container = try decoder.singleValueContainer()

                if let value = try? container.decode(ChatBskyLexicon.Conversation.MessageViewDefinition.self) {
                    self = .messageView(value)
                } else if let value = try? container.decode(ChatBskyLexicon.Conversation.DeletedMessageViewDefinition.self) {
                    self = .deletedMessageView(value)
                } else {
                    throw DecodingError.typeMismatch(
                        MessageUnion.self, DecodingError.Context(
                            codingPath: decoder.codingPath, debugDescription: "Unknown MessageUnion type"))
                }
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.singleValueContainer()

                switch self {
                    case .messageView(let messageView):
                        try container.encode(messageView)
                    case .deletedMessageView(let deletedMessageView):
                        try container.encode(deletedMessageView)
                }
            }
        }
    }

    /// A definition model for a log for removing a reaction.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/convo/defs.json
    public struct LogRemoveReactionDefinition: Sendable, Codable {

        /// The revision of the log.
        public let revision: String

        /// The ID of the conversation.
        public let conversationID: String

        /// The message itself.
        public let message: ATUnion.LogReadMessageUnion

        enum CodingKeys: String, CodingKey {
            case revision = "rev"
            case conversationID = "convoID"
            case message
        }

        // Unions
        /// A reference containing the list of messages.
        public enum MessageUnion: Sendable, Codable {

            /// A message view.
            case messageView(ChatBskyLexicon.Conversation.MessageViewDefinition)

            /// A deleted message view.
            case deletedMessageView(ChatBskyLexicon.Conversation.DeletedMessageViewDefinition)

            public init(from decoder: any Decoder) throws {
                let container = try decoder.singleValueContainer()

                if let value = try? container.decode(ChatBskyLexicon.Conversation.MessageViewDefinition.self) {
                    self = .messageView(value)
                } else if let value = try? container.decode(ChatBskyLexicon.Conversation.DeletedMessageViewDefinition.self) {
                    self = .deletedMessageView(value)
                } else {
                    throw DecodingError.typeMismatch(
                        MessageUnion.self, DecodingError.Context(
                            codingPath: decoder.codingPath, debugDescription: "Unknown MessageUnion type"))
                }
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.singleValueContainer()

                switch self {
                    case .messageView(let messageView):
                        try container.encode(messageView)
                    case .deletedMessageView(let deletedMessageView):
                        try container.encode(deletedMessageView)
                }
            }
        }
    }
}
