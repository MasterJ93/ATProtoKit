//
//  ChatBskyGroupDefs.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-19.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ChatBskyLexicon.Group {

    /// A definition model for a string declaring the enabled status of a join link.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.group.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/group/defs.json
    public enum LinkEnabledStatusDefinition: Sendable, Codable, ExpressibleByStringLiteral {

        /// The join link is enabled.
        case enabled

        /// The join link is disabled.
        case disabled

        /// An unknown value that the object may contain.
        case unknown(String)

        public var rawValue: String {
            switch self {
                case .enabled:
                    return "enabled"
                case .disabled:
                    return "disabled"
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
                case "enabled":
                    self = .enabled
                case "disabled":
                    self = .disabled
                default:
                    self = .unknown(value)
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(self.rawValue)
        }
    }

    /// A definition model for a string declaring the rule for joining a group conversation.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.group.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/group/defs.json
    public enum JoinRuleDefinition: Sendable, Codable, ExpressibleByStringLiteral {

        /// Anyone can join the group conversation.
        case anyone

        /// Only user accounts followed by the owner can join the group conversation.
        case followedByOwner

        /// An unknown value that the object may contain.
        case unknown(String)

        public var rawValue: String {
            switch self {
                case .anyone:
                    return "anyone"
                case .followedByOwner:
                    return "followedByOwner"
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
                case "anyone":
                    self = .anyone
                case "followedByOwner":
                    self = .followedByOwner
                default:
                    self = .unknown(value)
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(self.rawValue)
        }
    }

    /// A definition model for a join link view.
    ///
    /// - Note: According to the AT Protocol specifications: "Join link view to be used within a
    /// group view, so the convo is surrounding, not specified inside this view."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.group.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/group/defs.json
    public struct JoinLinkViewDefinition: Sendable, Codable {

        /// The code of the join link.
        public let code: String

        /// The enabled status of the join link.
        public let enabledStatus: LinkEnabledStatusDefinition

        /// Indicates whether joining through the join link requires approval.
        public let isApprovalRequired: Bool

        /// The rule for joining the group conversation.
        public let joinRule: JoinRuleDefinition

        /// The date and time the join link was created.
        public let createdAt: Date

        public init(code: String, enabledStatus: LinkEnabledStatusDefinition, isApprovalRequired: Bool, joinRule: JoinRuleDefinition,
                    createdAt: Date) {
            self.code = code
            self.enabledStatus = enabledStatus
            self.isApprovalRequired = isApprovalRequired
            self.joinRule = joinRule
            self.createdAt = createdAt
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.code = try container.decode(String.self, forKey: .code)
            self.enabledStatus = try container.decode(LinkEnabledStatusDefinition.self, forKey: .enabledStatus)
            self.isApprovalRequired = try container.decode(Bool.self, forKey: .isApprovalRequired)
            self.joinRule = try container.decode(JoinRuleDefinition.self, forKey: .joinRule)
            self.createdAt = try container.decodeDate(forKey: .createdAt)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.code, forKey: .code)
            try container.encode(self.enabledStatus, forKey: .enabledStatus)
            try container.encode(self.isApprovalRequired, forKey: .isApprovalRequired)
            try container.encode(self.joinRule, forKey: .joinRule)
            try container.encodeDate(self.createdAt, forKey: .createdAt)
        }

        enum CodingKeys: String, CodingKey {
            case code
            case enabledStatus
            case isApprovalRequired = "requireApproval"
            case joinRule
            case createdAt
        }
    }

    /// A definition model for a join link preview view.
    ///
    /// - Note: According to the AT Protocol specifications: "Preview that can be shown in feeds,
    /// including to unauthenticated viewers."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.group.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/group/defs.json
    public struct JoinLinkPreviewViewDefinition: Sendable, Codable {

        /// The ID of the conversation.
        public let conversationID: String

        /// The code of the join link.
        public let code: String

        /// The name of the group conversation.
        public let name: String

        /// The owner of the group conversation.
        public let owner: ChatBskyLexicon.Actor.ProfileViewBasicDefinition

        /// The number of members in the group conversation.
        public let memberCount: Int

        /// The maximum number of members in the group conversation.
        public let memberLimit: Int

        /// Indicates whether joining through the join link requires approval.
        public let isApprovalRequired: Bool

        /// The rule for joining the group conversation.
        public let joinRule: JoinRuleDefinition

        /// The group conversation. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Present only if the request is
        /// authenticated and the user is a member of the group."
        public let conversation: ChatBskyLexicon.Conversation.ConversationViewDefinition?

        /// The viewer state of the join link. Optional.
        public let viewer: JoinLinkViewerStateDefinition?

        enum CodingKeys: String, CodingKey {
            case conversationID = "convoId"
            case code
            case name
            case owner
            case memberCount
            case memberLimit
            case isApprovalRequired = "requireApproval"
            case joinRule
            case conversation = "convo"
            case viewer
        }
    }

    /// A definition model for a disabled join link preview view.
    ///
    /// - Note: According to the AT Protocol specifications: "Preview for a disabled join link.
    /// Carries only the code so clients can correlate with the input and render a disabled state."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.group.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/group/defs.json
    public struct DisabledJoinLinkPreviewViewDefinition: Sendable, Codable {

        /// The code of the join link.
        public let code: String
    }

    /// A definition model for an invalid join link preview view.
    ///
    /// - Note: According to the AT Protocol specifications: "Preview for a join link code that
    /// does not map to an existing link. Carries only the code so clients can correlate with the
    /// input and render an invalid state."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.group.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/group/defs.json
    public struct InvalidJoinLinkPreviewViewDefinition: Sendable, Codable {

        /// The code of the join link.
        public let code: String
    }

    /// A definition model for the viewer state of a join link.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.group.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/group/defs.json
    public struct JoinLinkViewerStateDefinition: Sendable, Codable {

        /// The date and time the user account requested to join the group conversation. Optional.
        public let requestedAt: Date?

        public init(requestedAt: Date?) {
            self.requestedAt = requestedAt
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.requestedAt = try container.decodeDateIfPresent(forKey: .requestedAt)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encodeDateIfPresent(self.requestedAt, forKey: .requestedAt)
        }

        enum CodingKeys: CodingKey {
            case requestedAt
        }
    }

    /// A definition model for a join request view.
    ///
    /// - Note: According to the AT Protocol specifications: "A join request from the perspective
    /// of the group owner."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.group.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/group/defs.json
    public struct JoinRequestViewDefinition: Sendable, Codable {

        /// The ID of the conversation.
        public let conversationID: String

        /// The user account that requested to join the group conversation.
        public let requestedBy: ChatBskyLexicon.Actor.ProfileViewBasicDefinition

        /// The date and time the user account requested to join the group conversation.
        public let requestedAt: Date

        public init(conversationID: String, requestedBy: ChatBskyLexicon.Actor.ProfileViewBasicDefinition, requestedAt: Date) {
            self.conversationID = conversationID
            self.requestedBy = requestedBy
            self.requestedAt = requestedAt
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.conversationID = try container.decode(String.self, forKey: .conversationID)
            self.requestedBy = try container.decode(ChatBskyLexicon.Actor.ProfileViewBasicDefinition.self, forKey: .requestedBy)
            self.requestedAt = try container.decodeDate(forKey: .requestedAt)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.conversationID, forKey: .conversationID)
            try container.encode(self.requestedBy, forKey: .requestedBy)
            try container.encodeDate(self.requestedAt, forKey: .requestedAt)
        }

        enum CodingKeys: String, CodingKey {
            case conversationID = "convoId"
            case requestedBy
            case requestedAt
        }
    }

    /// A definition model for a join request's conversation view.
    ///
    /// - Note: According to the AT Protocol specifications: "A join request from the perspective
    /// of the requester, including enough group context to render the request in a list (e.g.
    /// group name, owner, member count)."
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.group.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/chat/bsky/group/defs.json
    public struct JoinRequestConversationViewDefinition: Sendable, Codable {

        /// The ID of the conversation.
        public let conversationID: String

        /// The name of the group conversation.
        public let name: String

        /// The owner of the group conversation.
        public let owner: ChatBskyLexicon.Actor.ProfileViewBasicDefinition

        /// The number of members in the group conversation.
        public let memberCount: Int

        /// The maximum number of members in the group conversation.
        public let memberLimit: Int

        /// The viewer state of the join link.
        public let viewer: JoinLinkViewerStateDefinition

        enum CodingKeys: String, CodingKey {
            case conversationID = "convoId"
            case name
            case owner
            case memberCount
            case memberLimit
            case viewer
        }
    }
}
