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
