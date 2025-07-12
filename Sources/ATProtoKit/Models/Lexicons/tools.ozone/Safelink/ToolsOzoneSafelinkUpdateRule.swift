//
//  ToolsOzoneSafelinkUpdateRule.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-07-11.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ToolsOzoneLexicon.Safelink {

    /// A request body for updating an existing URL safety rule.
    ///
    /// - Note: According to the AT Protocol specifications: "Update an existing URL safety rule."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.safelink.updateRule`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/safelink/updateRule.json
    public struct UpdateRuleRequestBody: Sendable, Codable {

        /// The URL or domain attached to the event.
        ///
        /// - Note: According to the AT Protocol specifications: "The URL or domain to update the rule for."
        public let url: URL

        /// The URL pattern.
        public let urlPattern: ToolsOzoneLexicon.Safelink.PatternTypeDefinition

        /// The action taken to the URL.
        public let action: ToolsOzoneLexicon.Safelink.ActionTypeDefinition

        /// The reason for the action against the URL.
        public let reason: ToolsOzoneLexicon.Safelink.ReasonTypeDefinition

        /// A comment attached to the event. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Optional comment about the update."
        public let comment: String?

        /// The decentralized identifier (DID) of the user account that updated this event. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Optional DID to credit as the creator.
        /// Only respected for admin_token authentication."
        public let createdBy: String?

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
