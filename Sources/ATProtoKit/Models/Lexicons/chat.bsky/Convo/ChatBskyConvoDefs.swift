//
//  ChatBskyConvoDefs.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ChatBskyLexicon.Conversation {

    /// A definition model for a string declaring the lock status of a conversation.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/convo/defs.json
    public enum ConversationLockStatusDefinition: Sendable, Codable, ExpressibleByStringLiteral {

        /// The conversation is unlocked.
        case unlocked

        /// The conversation is locked.
        case locked

        /// The conversation is permanently locked.
        case lockedPermanently

        /// An unknown value that the object may contain.
        case unknown(String)

        public var rawValue: String {
            switch self {
                case .unlocked:
                    return "unlocked"
                case .locked:
                    return "locked"
                case .lockedPermanently:
                    return "locked-permanently"
                case .unknown(let value):
                    return value
            }
        }

        public init(stringLiteral value: String) {
            self = .unknown(value)
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let value = try container.decode(String.self)

            switch value {
                case "unlocked":
                    self = .unlocked
                case "locked":
                    self = .locked
                case "locked-permanently":
                    self = .lockedPermanently
                default:
                    self = .unknown(value)
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(self.rawValue)
        }
    }

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
        public let embed: EmbedUnion?

        /// A reference to the message this message is replying to. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "If set, the message this message
        /// is replying to. The referenced message must be in the same convo."
        public let replyTo: ReplyReferenceDefinition?

        public init(text: String, facets: [AppBskyLexicon.RichText.Facet]? = nil, embed: EmbedUnion? = nil,
                    replyTo: ReplyReferenceDefinition? = nil) {
            self.text = text
            self.facets = facets
            self.embed = embed
            self.replyTo = replyTo
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.truncatedEncode(self.text, forKey: .text, upToCharacterLength: 1_000)
            try container.encodeIfPresent(self.facets, forKey: .facets)
            try container.encodeIfPresent(self.embed, forKey: .embed)
            try container.encodeIfPresent(self.replyTo, forKey: .replyTo)
        }

        enum CodingKeys: CodingKey {
            case text
            case facets
            case embed
            case replyTo
        }

        // Unions
        /// An embed for the message.
        public enum EmbedUnion: ATUnionProtocol {

            /// A record within the embed.
            case record(AppBskyLexicon.Embed.RecordDefinition)

            /// A join link within the embed.
            case joinLink(ChatBskyLexicon.Embed.JoinLinkDefinition)

            /// An unknown case.
            case unknown(String, [String: CodableValue])

            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let type = try container.decodeIfPresent(String.self, forKey: .type)

                switch type {
                    case "app.bsky.embed.record":
                        self = .record(try AppBskyLexicon.Embed.RecordDefinition(from: decoder))
                    case "chat.bsky.embed.joinLink":
                        self = .joinLink(try ChatBskyLexicon.Embed.JoinLinkDefinition(from: decoder))
                    default:
                        let singleValueDecodingContainer = try decoder.singleValueContainer()
                        let dictionary = try Self.decodeDictionary(from: singleValueDecodingContainer, decoder: decoder)

                        self = .unknown(type ?? "unknown", dictionary)
                }
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.singleValueContainer()

                switch self {
                    case .record(let record):
                        try container.encode(record)
                    case .joinLink(let joinLink):
                        try container.encode(joinLink)
                    default:
                        break
                }
            }

            enum CodingKeys: String, CodingKey {
                case type = "$type"
            }
        }
    }

    /// A definition model for a reply reference.
    ///
    /// - Note: According to the AT Protocol specifications: "A reference to another message within
    /// the same convo, used to indicate that a message is a reply to it."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/convo/defs.json
    public struct ReplyReferenceDefinition: Sendable, Codable {

        /// The ID of the message.
        public let messageID: String

        public init(messageID: String) {
            self.messageID = messageID
        }

        enum CodingKeys: String, CodingKey {
            case messageID = "messageId"
        }
    }

    /// A definition model for a message view.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/convo/defs.json
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
        public let embed: EmbedUnion?

        /// An array of reactions. Optional.
        public let reactions: [ChatBskyLexicon.Conversation.ReactionViewDefinition]?

        /// The message this message is replying to. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "If set, the message this message
        /// is replying to. The full view of the referenced message is embedded so the client can
        /// render it inline. Only a single level is embedded: the embedded message will not itself
        /// have a populated 'replyTo' field even if it was also a reply."
        public let replyTo: ReplyToUnion?

        /// The sender of the message.
        public let sender: MessageViewSenderDefinition

        /// The date and time the message was seen.
        public let sentAt: Date

        public init(messageID: String, revision: String, text: String, facets: [AppBskyLexicon.RichText.Facet]?, embed: EmbedUnion?,
                    reactions: [ChatBskyLexicon.Conversation.ReactionViewDefinition]?, replyTo: ReplyToUnion? = nil,
                    sender: MessageViewSenderDefinition, sentAt: Date) {
            self.messageID = messageID
            self.revision = revision
            self.text = text
            self.facets = facets
            self.embed = embed
            self.reactions = reactions
            self.replyTo = replyTo
            self.sender = sender
            self.sentAt = sentAt
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.messageID = try container.decode(String.self, forKey: .messageID)
            self.revision = try container.decode(String.self, forKey: .revision)
            self.text = try container.decode(String.self, forKey: .text)
            self.facets = try container.decodeIfPresent([AppBskyLexicon.RichText.Facet].self, forKey: .facets)
            self.embed = try container.decodeIfPresent(EmbedUnion.self, forKey: .embed)
            self.reactions = try container.decodeIfPresent([ChatBskyLexicon.Conversation.ReactionViewDefinition].self, forKey: .reactions)
            self.replyTo = try container.decodeIfPresent(ReplyToUnion.self, forKey: .replyTo)
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
            try container.encodeIfPresent(self.replyTo, forKey: .replyTo)
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
            case replyTo
            case sender
            case sentAt
        }

        // Unions
        /// An embed for the message.
        public enum EmbedUnion: ATUnionProtocol {

            /// A record within the embed.
            case recordView(AppBskyLexicon.Embed.RecordDefinition.View)

            /// A join link within the embed.
            case joinLinkView(ChatBskyLexicon.Embed.JoinLinkDefinition.View)

            /// An unknown case.
            case unknown(String, [String: CodableValue])

            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let type = try container.decodeIfPresent(String.self, forKey: .type)

                switch type {
                    case "app.bsky.embed.record", "app.bsky.embed.record#view":
                        self = .recordView(try AppBskyLexicon.Embed.RecordDefinition.View(from: decoder))
                    case "chat.bsky.embed.joinLink#view":
                        self = .joinLinkView(try ChatBskyLexicon.Embed.JoinLinkDefinition.View(from: decoder))
                    default:
                        let singleValueDecodingContainer = try decoder.singleValueContainer()
                        let dictionary = try Self.decodeDictionary(from: singleValueDecodingContainer, decoder: decoder)

                        self = .unknown(type ?? "unknown", dictionary)
                }
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.singleValueContainer()

                switch self {
                    case .recordView(let value):
                        try container.encode(value)
                    case .joinLinkView(let value):
                        try container.encode(value)
                    default:
                        break
                }
            }

            enum CodingKeys: String, CodingKey {
                case type = "$type"
            }
        }

        /// A reference containing the list of messages being replied to.
        public indirect enum ReplyToUnion: ATUnionProtocol {

            /// A message view.
            case messageView(ChatBskyLexicon.Conversation.MessageViewDefinition)

            /// A deleted message view.
            case deletedMessageView(ChatBskyLexicon.Conversation.DeletedMessageViewDefinition)

            /// A placeholder for a message sent before the user account joined
            /// the group conversation.
            case messageBeforeUserJoinedGroupView(ChatBskyLexicon.Conversation.MessageBeforeUserJoinedGroupViewDefinition)

            /// An unknown case.
            case unknown(String, [String: CodableValue])

            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let type = try container.decodeIfPresent(String.self, forKey: .type)

                switch type {
                    case "chat.bsky.convo.defs#messageView":
                        self = .messageView(try ChatBskyLexicon.Conversation.MessageViewDefinition(from: decoder))
                    case "chat.bsky.convo.defs#deletedMessageView":
                        self = .deletedMessageView(try ChatBskyLexicon.Conversation.DeletedMessageViewDefinition(from: decoder))
                    case "chat.bsky.convo.defs#messageBeforeUserJoinedGroupView":
                        self = .messageBeforeUserJoinedGroupView(try ChatBskyLexicon.Conversation.MessageBeforeUserJoinedGroupViewDefinition(from: decoder))
                    default:
                        let singleValueDecodingContainer = try decoder.singleValueContainer()
                        let dictionary = try Self.decodeDictionary(from: singleValueDecodingContainer, decoder: decoder)

                        self = .unknown(type ?? "unknown", dictionary)
                }
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.singleValueContainer()

                switch self {
                    case .messageView(let value):
                        try container.encode(value)
                    case .deletedMessageView(let value):
                        try container.encode(value)
                    case .messageBeforeUserJoinedGroupView(let value):
                        try container.encode(value)
                    default:
                        break
                }
            }

            enum CodingKeys: String, CodingKey {
                case type = "$type"
            }
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

    /// A definition model for a placeholder of a message sent before the user account joined the
    /// group conversation.
    ///
    /// - Note: According to the AT Protocol specifications: "Placeholder embedded in place of a
    /// reply's parent message when that parent was sent before the viewer joined the group convo.
    /// The viewer has no access to that history, so no message data is carried."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/convo/defs.json
    public struct MessageBeforeUserJoinedGroupViewDefinition: Sendable, Codable {}

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

        public init(value: String, sender: ChatBskyLexicon.Conversation.ReactionViewSenderDefinition, createdAt: Date) {
            self.value = value
            self.sender = sender
            self.createdAt = createdAt
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.value = try container.decode(String.self, forKey: .value)
            self.sender = try container.decode(ChatBskyLexicon.Conversation.ReactionViewSenderDefinition.self, forKey: .sender)
            self.createdAt = try container.decodeDate(forKey: .createdAt)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.value, forKey: .value)
            try container.encode(self.sender, forKey: .sender)
            try container.encodeDate(self.createdAt, forKey: .createdAt)
        }

        enum CodingKeys: CodingKey {
            case value
            case sender
            case createdAt
        }
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

        /// The data specific to the kind of conversation. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Union field that has data
        /// specific to different kinds of convos."
        public let kind: KindUnion?

        enum CodingKeys: String, CodingKey {
            case conversationID = "id"
            case revision = "rev"
            case members
            case lastMessage
            case lastReaction
            case isMuted = "muted"
            case status
            case unreadCount
            case kind
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
        public enum LastMessageUnion: ATUnionProtocol {

            /// A message view.
            case messageView(ChatBskyLexicon.Conversation.MessageViewDefinition)

            /// A deleted message view.
            case deletedMessageView(ChatBskyLexicon.Conversation.DeletedMessageViewDefinition)

            /// An unknown case.
            case unknown(String, [String: CodableValue])

            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let type = try container.decodeIfPresent(String.self, forKey: .type)

                switch type {
                    case "chat.bsky.convo.defs#messageView":
                        self = .messageView(try ChatBskyLexicon.Conversation.MessageViewDefinition(from: decoder))
                    case "chat.bsky.convo.defs#deletedMessageView":
                        self = .deletedMessageView(try ChatBskyLexicon.Conversation.DeletedMessageViewDefinition(from: decoder))
                    default:
                        let singleValueDecodingContainer = try decoder.singleValueContainer()
                        let dictionary = try Self.decodeDictionary(from: singleValueDecodingContainer, decoder: decoder)

                        self = .unknown(type ?? "unknown", dictionary)
                }
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.singleValueContainer()

                switch self {
                    case .messageView(let value):
                        try container.encode(value)
                    case .deletedMessageView(let value):
                        try container.encode(value)
                    default:
                        break
                }
            }

            enum CodingKeys: String, CodingKey {
                case type = "$type"
            }
        }

        /// A reference containing the list containing a message and reaction.
        public enum LastReactionUnion: ATUnionProtocol {

            /// A view containing a message and reaction.
            case messageAndReactionView(ChatBskyLexicon.Conversation.MessageAndReactionViewDefinition)

            /// An unknown case.
            case unknown(String, [String: CodableValue])

            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let type = try container.decodeIfPresent(String.self, forKey: .type)

                switch type {
                    case "chat.bsky.convo.defs#messageAndReactionView":
                        self = .messageAndReactionView(try ChatBskyLexicon.Conversation.MessageAndReactionViewDefinition(from: decoder))
                    default:
                        let singleValueDecodingContainer = try decoder.singleValueContainer()
                        let dictionary = try Self.decodeDictionary(from: singleValueDecodingContainer, decoder: decoder)

                        self = .unknown(type ?? "unknown", dictionary)
                }
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.singleValueContainer()

                switch self {
                    case .messageAndReactionView(let value):
                        try container.encode(value)
                    default:
                        break
                }
            }

            enum CodingKeys: String, CodingKey {
                case type = "$type"
            }
        }

        /// A reference containing the list of conversation kinds.
        public enum KindUnion: ATUnionProtocol {

            /// A direct conversation.
            case directConversation(ChatBskyLexicon.Conversation.DirectConversationDefinition)

            /// A group conversation.
            case groupConversation(ChatBskyLexicon.Conversation.GroupConversationDefinition)

            /// An unknown case.
            case unknown(String, [String: CodableValue])

            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let type = try container.decodeIfPresent(String.self, forKey: .type)

                switch type {
                    case "chat.bsky.convo.defs#directConvo":
                        self = .directConversation(try ChatBskyLexicon.Conversation.DirectConversationDefinition(from: decoder))
                    case "chat.bsky.convo.defs#groupConvo":
                        self = .groupConversation(try ChatBskyLexicon.Conversation.GroupConversationDefinition(from: decoder))
                    default:
                        let singleValueDecodingContainer = try decoder.singleValueContainer()
                        let dictionary = try Self.decodeDictionary(from: singleValueDecodingContainer, decoder: decoder)

                        self = .unknown(type ?? "unknown", dictionary)
                }
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.singleValueContainer()

                switch self {
                    case .directConversation(let value):
                        try container.encode(value)
                    case .groupConversation(let value):
                        try container.encode(value)
                    default:
                        break
                }
            }

            enum CodingKeys: String, CodingKey {
                case type = "$type"
            }
        }
    }

    /// A definition model for a direct conversation.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/convo/defs.json
    public struct DirectConversationDefinition: Sendable, Codable {}

    /// A definition model for a group conversation.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.convo.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/convo/defs.json
    public struct GroupConversationDefinition: Sendable, Codable {

        /// The date and time the group conversation was created.
        public let createdAt: Date

        /// The join link of the group conversation. Optional.
        public let joinLink: ChatBskyLexicon.Group.JoinLinkViewDefinition?

        /// The number of pending join requests for the group conversation. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "The total number of pending join
        /// requests for the group conversation. Only present for the owner. Capped at 21."
        public let joinRequestCount: Int?

        /// The lock status of the group conversation.
        ///
        /// - Note: According to the AT Protocol specifications: "The lock status of
        /// the conversation."
        public let lockStatus: ConversationLockStatusDefinition

        /// Indicates whether the lock status is overridden by moderation.
        ///
        /// - Note: According to the AT Protocol specifications: "Whether the lock status is being
        /// forced by a moderation override (account inactivation or convo takedown) rather than
        /// the owner's own setting."
        public let isLockStatusOverriddenByModeration: Bool

        /// The number of members in the group conversation.
        ///
        /// - Note: According to the AT Protocol specifications: "The total number of members in
        /// the group conversation."
        public let memberCount: Int

        /// The maximum number of members in the group conversation.
        ///
        /// - Note: According to the AT Protocol specifications: "The maximum number of members
        /// allowed in the group conversation."
        public let memberLimit: Int

        /// The name of the group conversation.
        ///
        /// - Important: Current maximum length is 50 characters.
        ///
        /// - Note: According to the AT Protocol specifications: "The display name of the
        /// group conversation."
        public let name: String

        /// The number of unread join requests for the group conversation. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "The number of unread join
        /// requests for the group conversation. Only present for the owner."
        public let unreadJoinRequestCount: Int?

        public init(createdAt: Date, joinLink: ChatBskyLexicon.Group.JoinLinkViewDefinition?, joinRequestCount: Int?,
                    lockStatus: ConversationLockStatusDefinition, isLockStatusOverriddenByModeration: Bool, memberCount: Int, memberLimit: Int,
                    name: String, unreadJoinRequestCount: Int?) {
            self.createdAt = createdAt
            self.joinLink = joinLink
            self.joinRequestCount = joinRequestCount
            self.lockStatus = lockStatus
            self.isLockStatusOverriddenByModeration = isLockStatusOverriddenByModeration
            self.memberCount = memberCount
            self.memberLimit = memberLimit
            self.name = name
            self.unreadJoinRequestCount = unreadJoinRequestCount
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.createdAt = try container.decodeDate(forKey: .createdAt)
            self.joinLink = try container.decodeIfPresent(ChatBskyLexicon.Group.JoinLinkViewDefinition.self, forKey: .joinLink)
            self.joinRequestCount = try container.decodeIfPresent(Int.self, forKey: .joinRequestCount)
            self.lockStatus = try container.decode(ConversationLockStatusDefinition.self, forKey: .lockStatus)
            self.isLockStatusOverriddenByModeration = try container.decode(Bool.self, forKey: .isLockStatusOverriddenByModeration)
            self.memberCount = try container.decode(Int.self, forKey: .memberCount)
            self.memberLimit = try container.decode(Int.self, forKey: .memberLimit)
            self.name = try container.decode(String.self, forKey: .name)
            self.unreadJoinRequestCount = try container.decodeIfPresent(Int.self, forKey: .unreadJoinRequestCount)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encodeDate(self.createdAt, forKey: .createdAt)
            try container.encodeIfPresent(self.joinLink, forKey: .joinLink)
            try container.encodeIfPresent(self.joinRequestCount, forKey: .joinRequestCount)
            try container.encode(self.lockStatus, forKey: .lockStatus)
            try container.encode(self.isLockStatusOverriddenByModeration, forKey: .isLockStatusOverriddenByModeration)
            try container.encode(self.memberCount, forKey: .memberCount)
            try container.encode(self.memberLimit, forKey: .memberLimit)
            try container.truncatedEncode(self.name, forKey: .name, upToCharacterLength: 50)
            try container.encodeIfPresent(self.unreadJoinRequestCount, forKey: .unreadJoinRequestCount)
        }

        enum CodingKeys: String, CodingKey {
            case createdAt
            case joinLink
            case joinRequestCount
            case lockStatus
            case isLockStatusOverriddenByModeration = "lockStatusModerationOverride"
            case memberCount
            case memberLimit
            case name
            case unreadJoinRequestCount
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
        public let message: MessageUnion

        enum CodingKeys: String, CodingKey {
            case revision = "rev"
            case conversationID = "convoID"
            case message
        }

        // Unions
        /// The message itself.
        public enum MessageUnion: ATUnionProtocol {

            /// A message view.
            case messageView(ChatBskyLexicon.Conversation.MessageViewDefinition)

            /// A deleted message view.
            case deletedMessageView(ChatBskyLexicon.Conversation.DeletedMessageViewDefinition)

            /// An unknown case.
            case unknown(String, [String: CodableValue])

            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let type = try container.decodeIfPresent(String.self, forKey: .type)

                switch type {
                    case "chat.bsky.convo.defs#messageView":
                        self = .messageView(try ChatBskyLexicon.Conversation.MessageViewDefinition(from: decoder))
                    case "chat.bsky.convo.defs#deletedMessageView":
                        self = .deletedMessageView(try ChatBskyLexicon.Conversation.DeletedMessageViewDefinition(from: decoder))
                    default:
                        let singleValueDecodingContainer = try decoder.singleValueContainer()
                        let dictionary = try Self.decodeDictionary(from: singleValueDecodingContainer, decoder: decoder)

                        self = .unknown(type ?? "unknown", dictionary)
                }
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.singleValueContainer()

                switch self {
                    case .messageView(let value):
                        try container.encode(value)
                    case .deletedMessageView(let value):
                        try container.encode(value)
                    default:
                        break
                }
            }

            enum CodingKeys: String, CodingKey {
                case type = "$type"
            }
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
        public let message: MessageUnion

        enum CodingKeys: String, CodingKey {
            case revision = "rev"
            case conversationID = "convoID"
            case message
        }

        // Unions
        /// The message itself.
        public enum MessageUnion: ATUnionProtocol {

            /// A message view.
            case messageView(ChatBskyLexicon.Conversation.MessageViewDefinition)

            /// A deleted message view.
            case deletedMessageView(ChatBskyLexicon.Conversation.DeletedMessageViewDefinition)

            /// An unknown case.
            case unknown(String, [String: CodableValue])

            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let type = try container.decodeIfPresent(String.self, forKey: .type)

                switch type {
                    case "chat.bsky.convo.defs#messageView":
                        self = .messageView(try ChatBskyLexicon.Conversation.MessageViewDefinition(from: decoder))
                    case "chat.bsky.convo.defs#deletedMessageView":
                        self = .deletedMessageView(try ChatBskyLexicon.Conversation.DeletedMessageViewDefinition(from: decoder))
                    default:
                        let singleValueDecodingContainer = try decoder.singleValueContainer()
                        let dictionary = try Self.decodeDictionary(from: singleValueDecodingContainer, decoder: decoder)

                        self = .unknown(type ?? "unknown", dictionary)
                }
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.singleValueContainer()

                switch self {
                    case .messageView(let value):
                        try container.encode(value)
                    case .deletedMessageView(let value):
                        try container.encode(value)
                    default:
                        break
                }
            }

            enum CodingKeys: String, CodingKey {
                case type = "$type"
            }
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
        public let message: MessageUnion

        enum CodingKeys: String, CodingKey {
            case revision = "rev"
            case conversationID = "convoID"
            case message
        }

        // Unions
        /// The message itself.
        public enum MessageUnion: ATUnionProtocol {

            /// A message view.
            case messageView(ChatBskyLexicon.Conversation.MessageViewDefinition)

            /// A deleted message view.
            case deletedMessageView(ChatBskyLexicon.Conversation.DeletedMessageViewDefinition)

            /// An unknown case.
            case unknown(String, [String: CodableValue])

            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let type = try container.decodeIfPresent(String.self, forKey: .type)

                switch type {
                    case "chat.bsky.convo.defs#messageView":
                        self = .messageView(try ChatBskyLexicon.Conversation.MessageViewDefinition(from: decoder))
                    case "chat.bsky.convo.defs#deletedMessageView":
                        self = .deletedMessageView(try ChatBskyLexicon.Conversation.DeletedMessageViewDefinition(from: decoder))
                    default:
                        let singleValueDecodingContainer = try decoder.singleValueContainer()
                        let dictionary = try Self.decodeDictionary(from: singleValueDecodingContainer, decoder: decoder)

                        self = .unknown(type ?? "unknown", dictionary)
                }
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.singleValueContainer()

                switch self {
                    case .messageView(let value):
                        try container.encode(value)
                    case .deletedMessageView(let value):
                        try container.encode(value)
                    default:
                        break
                }
            }

            enum CodingKeys: String, CodingKey {
                case type = "$type"
            }
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
        /// The message itself.
        public enum MessageUnion: ATUnionProtocol {

            /// A message view.
            case messageView(ChatBskyLexicon.Conversation.MessageViewDefinition)

            /// A deleted message view.
            case deletedMessageView(ChatBskyLexicon.Conversation.DeletedMessageViewDefinition)

            /// An unknown case.
            case unknown(String, [String: CodableValue])

            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let type = try container.decodeIfPresent(String.self, forKey: .type)

                switch type {
                    case "chat.bsky.convo.defs#messageView":
                        self = .messageView(try ChatBskyLexicon.Conversation.MessageViewDefinition(from: decoder))
                    case "chat.bsky.convo.defs#deletedMessageView":
                        self = .deletedMessageView(try ChatBskyLexicon.Conversation.DeletedMessageViewDefinition(from: decoder))
                    default:
                        let singleValueDecodingContainer = try decoder.singleValueContainer()
                        let dictionary = try Self.decodeDictionary(from: singleValueDecodingContainer, decoder: decoder)

                        self = .unknown(type ?? "unknown", dictionary)
                }
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.singleValueContainer()

                switch self {
                    case .messageView(let value):
                        try container.encode(value)
                    case .deletedMessageView(let value):
                        try container.encode(value)
                    default:
                        break
                }
            }

            enum CodingKeys: String, CodingKey {
                case type = "$type"
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
        public let message: MessageUnion

        enum CodingKeys: String, CodingKey {
            case revision = "rev"
            case conversationID = "convoID"
            case message
        }

        // Unions
        /// The message itself.
        public enum MessageUnion: ATUnionProtocol {

            /// A message view.
            case messageView(ChatBskyLexicon.Conversation.MessageViewDefinition)

            /// A deleted message view.
            case deletedMessageView(ChatBskyLexicon.Conversation.DeletedMessageViewDefinition)

            /// An unknown case.
            case unknown(String, [String: CodableValue])

            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let type = try container.decodeIfPresent(String.self, forKey: .type)

                switch type {
                    case "chat.bsky.convo.defs#messageView":
                        self = .messageView(try ChatBskyLexicon.Conversation.MessageViewDefinition(from: decoder))
                    case "chat.bsky.convo.defs#deletedMessageView":
                        self = .deletedMessageView(try ChatBskyLexicon.Conversation.DeletedMessageViewDefinition(from: decoder))
                    default:
                        let singleValueDecodingContainer = try decoder.singleValueContainer()
                        let dictionary = try Self.decodeDictionary(from: singleValueDecodingContainer, decoder: decoder)

                        self = .unknown(type ?? "unknown", dictionary)
                }
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.singleValueContainer()

                switch self {
                    case .messageView(let value):
                        try container.encode(value)
                    case .deletedMessageView(let value):
                        try container.encode(value)
                    default:
                        break
                }
            }

            enum CodingKeys: String, CodingKey {
                case type = "$type"
            }
        }
    }
}
