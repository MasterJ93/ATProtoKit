//
//  ToolsOzoneSafelinkRemoveRule.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-07-11.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ToolsOzoneLexicon.Safelink {

    /// A request body for deleting an existing URL safety rule.
    ///
    /// - Note: According to the AT Protocol specifications: "Remove an existing URL safety rule."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.safelink.removeRule`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/safelink/removeRule.json
    public struct RemoveRuleRequestBody: Sendable, Codable {

        /// The URL or domain related to the rule.
        ///
        /// - Note: According to the AT Protocol specifications: "The URL or domain to remove the rule for."
        public let url: URL

        /// The URL pattern.
        public let pattern: ToolsOzoneLexicon.Safelink.PatternTypeDefinition

        /// A comment attached to the event. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Optional comment about why the rule is
        /// being removed."
        public let comment: String?

        /// The decentralized identitifer (DID) of the user account that deleted the rule. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Optional DID of the user. Only respected
        /// when using admin auth."
        public let createdBy: String?
    }
}
