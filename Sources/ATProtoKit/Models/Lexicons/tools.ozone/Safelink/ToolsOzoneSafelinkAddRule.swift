//
//  ToolsOzoneSafelinkAddRule.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-07-11.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ToolsOzoneLexicon.Safelink {

    /// A request body model for adding a safety rule for a URL.
    ///
    /// - Note: According to the AT Protocol specifications: "Add a new URL safety rule."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.safelink.addRule`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/safelink/addRule.json
    public struct AddRuleRequestBody: Sendable, Codable {

        /// The URL or domain the rule applies to.
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

        /// The decentralized identifier (DID) of the user account that created this event.
        ///
        /// - Note: According to the AT Protocol specifications: "Author DID. Only respected when using admin auth."
        public let createdBy: String

        public init(url: URL, urlPattern: PatternTypeDefinition, action: ActionTypeDefinition,
                    reason: ReasonTypeDefinition, comment: String?, createdBy: String) {
            self.url = url
            self.urlPattern = urlPattern
            self.action = action
            self.reason = reason
            self.comment = comment
            self.createdBy = createdBy
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.url = try container.decode(URL.self, forKey: .url)
            self.urlPattern = try container.decode(ToolsOzoneLexicon.Safelink.PatternTypeDefinition.self, forKey: .urlPattern)
            self.action = try container.decode(ToolsOzoneLexicon.Safelink.ActionTypeDefinition.self, forKey: .action)
            self.reason = try container.decode(ToolsOzoneLexicon.Safelink.ReasonTypeDefinition.self, forKey: .reason)
            self.comment = try container.decodeIfPresent(String.self, forKey: ToolsOzoneLexicon.Safelink.AddRuleRequestBody.CodingKeys.comment)
            self.createdBy = try container.decode(String.self, forKey: ToolsOzoneLexicon.Safelink.AddRuleRequestBody.CodingKeys.createdBy)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(self.url, forKey: .url)
            try container.encode(self.urlPattern, forKey: .urlPattern)
            try container.encode(self.action, forKey: .action)
            try container.encode(self.reason, forKey: .reason)
            try container.encodeIfPresent(self.comment, forKey: .comment)
            try container.encode(self.createdBy, forKey: .createdBy)
        }

        enum CodingKeys: String, CodingKey {
            case url
            case urlPattern = "pattern"
            case action
            case reason
            case comment
            case createdBy
        }
    }
}
