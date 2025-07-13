//
//  ToolsOzoneSafelinkDefs.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-07-11.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ToolsOzoneLexicon.Safelink {

    /// A definition model for events concerning decisions about the safety of URLs.
    ///
    /// - Note: According to the AT Protocol specifications: "An event for URL safety decisions."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.safelink.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/safelink/defs.json
    public struct EventDefinition: Sendable, Codable {

        /// The ID of the event.
        ///
        /// - Note: According to the AT Protocol specifications: "Auto-incrementing row ID."
        public let id: Int

        /// A string declaring the type of event.
        public let eventType: EventTypeDefinition

        /// The URL related to the event.
        ///
        /// - Note: According to the AT Protocol specifications: "The URL that this rule applies to."
        public let url: URL

        /// A string declaring the the URL pattern.
        public let urlPattern: PatternTypeDefinition

        /// A string declaring the action taken to the URL.
        public let action: ActionTypeDefinition

        /// A string declaring the reason for the action against the URL.
        public let reason: ReasonTypeDefinition

        /// The decentralized identifier (DID) of the user account that created this event.
        ///
        /// - Note: According to the AT Protocol specifications: "DID of the user who created this rule."
        public let createdBy: String

        /// The date and time the event was created.
        public let createdAt: Date

        /// A comment attached to the event. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Optional comment about the decision."
        public let comment: String?

        public init(id: Int, eventType: EventTypeDefinition, url: URL, urlPattern: PatternTypeDefinition,
                    action: ActionTypeDefinition, reason: ReasonTypeDefinition, createdBy: String,
                    createdAt: Date, comment: String?) {
            self.id = id
            self.eventType = eventType
            self.url = url
            self.urlPattern = urlPattern
            self.action = action
            self.reason = reason
            self.createdBy = createdBy
            self.createdAt = createdAt
            self.comment = comment
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.id = try container.decode(Int.self, forKey: .id)
            self.eventType = try container.decode(ToolsOzoneLexicon.Safelink.EventTypeDefinition.self, forKey: .eventType)
            self.url = try container.decode(URL.self, forKey: .url)
            self.urlPattern = try container.decode(ToolsOzoneLexicon.Safelink.PatternTypeDefinition.self, forKey: .urlPattern)
            self.action = try container.decode(ToolsOzoneLexicon.Safelink.ActionTypeDefinition.self, forKey: .action)
            self.reason = try container.decode(ToolsOzoneLexicon.Safelink.ReasonTypeDefinition.self, forKey: .reason)
            self.createdBy = try container.decode(String.self, forKey: .createdBy)
            self.createdAt = try container.decodeDate(forKey: .createdAt)
            self.comment = try container.decodeIfPresent(String.self, forKey: .comment)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.id, forKey: .id)
            try container.encode(self.eventType, forKey: .eventType)
            try container.encode(self.url, forKey: .url)
            try container.encode(self.urlPattern, forKey: .urlPattern)
            try container.encode(self.action, forKey: .action)
            try container.encode(self.reason, forKey: .reason)
            try container.encode(self.createdBy, forKey: .createdBy)
            try container.encodeDate(self.createdAt, forKey: .createdAt)
            try container.encodeIfPresent(self.comment, forKey: .comment)
        }

        enum CodingKeys: String, CodingKey {
            case id
            case eventType
            case url
            case urlPattern = "pattern"
            case action
            case reason
            case createdBy
            case createdAt
            case comment
        }
    }

    /// A definition model for a string declaring the type of event.
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.safelink.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/safelink/defs.json
    public enum EventTypeDefinition: Sendable, Codable, ExpressibleByStringLiteral {

        /// The event is for adding a rule.
        case addRule

        /// The event is for updating a rule.
        case updateRule

        /// The event is for removing a rule.
        case removeRule

        /// An unknown value that the object may contain.
        case unknown(String)

        public var rawValue: String {
            switch self {
                case .addRule:
                    return "addRule"
                case .updateRule:
                    return "updateRule"
                case .removeRule:
                    return "removeRule"
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
                case "addRule":
                    self = .addRule
                case "updateRule":
                    self = .updateRule
                case "removeRule":
                    self = .removeRule
                default:
                    self = .unknown(value)
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(self.rawValue)
        }
    }

    /// A definition model for the URL pattern.
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.safelink.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/safelink/defs.json
    public enum PatternTypeDefinition: Sendable, Codable, ExpressibleByStringLiteral {

        /// The URL is the entire domain.
        case domain

        /// The URL is a specific webpage.
        case url

        /// An unknown value that the object may contain.
        case unknown(String)

        public init(stringLiteral value: String) {
            self = .unknown(value)
        }

        public var rawValue: String {
            switch self {
                case .domain:
                    return "domain"
                case .url:
                    return "url"
                case .unknown(let value):
                    return value
            }
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let value = try container.decode(String.self)

            switch value {
                case "domain":
                    self = .domain
                case "url":
                    self = .url
                default:
                    self = .unknown(value)
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(self.rawValue)
        }
    }

    /// The action taken in the event.
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.safelink.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/safelink/defs.json
    public enum ActionTypeDefinition: Sendable, Codable, ExpressibleByStringLiteral {

        /// The URL will be blocked.
        case block

        /// The user account will be warned before viewing the link.
        case warn

        /// The URL will be exempt from any negative actions taken.
        case whitelist

        /// An unknown value that the object may contain.
        case unknown(String)

        public init(stringLiteral value: String) {
            self = .unknown(value)
        }

        public var rawValue: String {
            switch self {
                case .block:
                    return "block"
                case .warn:
                    return "warn"
                case .whitelist:
                    return "whitelist"
                case .unknown(let value):
                    return value
            }
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let value = try container.decode(String.self)

            switch value {
                case "block":
                    self = .block
                case "warn":
                    self = .warn
                case "whitelist":
                    self = .whitelist
                default:
                    self = .unknown(value)
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(self.rawValue)
        }
    }

    /// The reason the URL has been added.
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.safelink.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/safelink/defs.json
    public enum ReasonTypeDefinition: Sendable, Codable, ExpressibleByStringLiteral {

        /// The URL is a CSAM website.
        case csam

        /// The URL is spam.
        case spam

        /// The URL is a phishing link.
        case phishing

        /// No reason was provided.
        case none

        /// An unknown value that the object may contain.
        case unknown(String)

        public init(stringLiteral value: String) {
            self = .unknown(value)
        }

        public var rawValue: String {
            switch self {
                case .csam:
                    return "csam"
                case .spam:
                    return "spam"
                case .phishing:
                    return "phishing"
                case .none:
                    return "none"
                case .unknown(let value):
                    return value
            }
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let value = try container.decode(String.self)

            switch value {
                case "csam":
                    self = .csam
                case "spam":
                    self = .spam
                case "phishing":
                    self = .phishing
                case "none":
                    self = .none
                default:
                    self = .unknown(value)
            }
        }
    }

    /// A definition model for a URL safety rule structure.
    ///
    /// - Note: According to the AT Protocol specifications: "Input for creating a URL safety rule."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.safelink.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/safelink/defs.json
    public struct URLRuleDefinition: Sendable, Codable {

        /// The URL related to the rule.
        ///
        /// - Note: According to the AT Protocol specifications: "The URL or domain to apply the rule to."
        public let url: URL

        /// A string declaring the URL pattern.
        public let urlPattern: PatternTypeDefinition

        /// A string declaring the action taken to the URL.
        public let action: ActionTypeDefinition

        /// A string declaring the reason for the action against the URL.
        public let reason: ReasonTypeDefinition

        /// A comment attached to the event. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Optional comment about the decision."
        public let comment: String?

        /// The decentralized identifier (DID) of the user account that created this URL rule.
        ///
        /// - Note: According to the AT Protocol specifications: "DID of the user added the rule."
        public let createdBy: String

        /// The date and time the URL rule was created.
        ///
        /// - Note: According to the AT Protocol specifications: "Timestamp when the rule was created."
        public let createdAt: Date

        /// The date and time the URL rule was updated.
        ///
        /// - Note: According to the AT Protocol specifications: "Timestamp when the rule was last updated."
        public let updatedAt: Date

        public init(url: URL, urlPattern: PatternTypeDefinition, action: ActionTypeDefinition,
                    reason: ReasonTypeDefinition, comment: String?, createdBy: String, createdAt: Date,
                    updatedAt: Date) {
            self.url = url
            self.urlPattern = urlPattern
            self.action = action
            self.reason = reason
            self.comment = comment
            self.createdBy = createdBy
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.url = try container.decode(URL.self, forKey: .url)
            self.urlPattern = try container.decode(ToolsOzoneLexicon.Safelink.PatternTypeDefinition.self, forKey: .urlPattern)
            self.action = try container.decode(ToolsOzoneLexicon.Safelink.ActionTypeDefinition.self, forKey: .action)
            self.reason = try container.decode(ToolsOzoneLexicon.Safelink.ReasonTypeDefinition.self, forKey: .reason)
            self.comment = try container.decodeIfPresent(String.self, forKey: .comment)
            self.createdBy = try container.decode(String.self, forKey: .createdBy)
            self.createdAt = try container.decodeDate(forKey: .createdAt)
            self.updatedAt = try container.decodeDate(forKey: .updatedAt)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: ToolsOzoneLexicon.Safelink.URLRuleDefinition.CodingKeys.self)
            try container.encode(self.url, forKey: ToolsOzoneLexicon.Safelink.URLRuleDefinition.CodingKeys.url)
            try container.encode(self.urlPattern, forKey: ToolsOzoneLexicon.Safelink.URLRuleDefinition.CodingKeys.urlPattern)
            try container.encode(self.action, forKey: ToolsOzoneLexicon.Safelink.URLRuleDefinition.CodingKeys.action)
            try container.encode(self.reason, forKey: ToolsOzoneLexicon.Safelink.URLRuleDefinition.CodingKeys.reason)
            try container.encodeIfPresent(self.comment, forKey: ToolsOzoneLexicon.Safelink.URLRuleDefinition.CodingKeys.comment)
            try container.encode(self.createdBy, forKey: ToolsOzoneLexicon.Safelink.URLRuleDefinition.CodingKeys.createdBy)
            try container.encode(self.createdAt, forKey: ToolsOzoneLexicon.Safelink.URLRuleDefinition.CodingKeys.createdAt)
            try container.encode(self.updatedAt, forKey: ToolsOzoneLexicon.Safelink.URLRuleDefinition.CodingKeys.updatedAt)
        }

        enum CodingKeys: String, CodingKey {
            case url
            case urlPattern = "pattern"
            case action
            case reason
            case comment
            case createdBy
            case createdAt
            case updatedAt
        }
    }
}
