//
//  ToolsOzoneSafelinkQueryRules.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-07-11.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ToolsOzoneLexicon.Safelink {

    /// The main data model definition for querying URL rules events.
    ///
    /// - Note: According to the AT Protocol specifications: "Query URL safety rules."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.safelink.queryRules`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/safelink/queryRules.json
    public struct QueryRules: Sendable, Codable {

        /// Sets the sorting direction of the audit array.
        public enum SortDirection: String, Sendable, Codable {

            /// Indicates the URL events will be sorted in ascending order.
            case ascending = "asc"

            /// Indicates the URL events will be sorted in descending order.
            case descending = "desc"
        }
    }

    /// A request body model for querying URL rules events.
    ///
    /// - Note: According to the AT Protocol specifications: "Query URL safety rules."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.safelink.queryRules`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/safelink/queryRules.json
    public struct QueryRulesRequestBody: Sendable, Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Cursor for pagination."
        public let cursor: String?

        /// The number of rules in the array. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Maximum number of results to return."
        public let limit: Int?

        /// An array of filtered results based on URL or domain.
        ///
        /// - Note: According to the AT Protocol specifications: "Filter by specific URLs or domains."
        public let urls: [URL]?

        /// Filter results based on the pattern type of the URL rule.
        ///
        /// - Note: According to the AT Protocol specifications: "Filter by pattern type."
        public let patternType: String?

        /// An array of filtered results based on the actions of the URL rule.
        ///
        /// - Note: According to the AT Protocol specifications: "Filter by action types."
        public let actions: [String]?

        /// Filter results based on the reason for the URL rule.
        ///
        /// - Note: According to the AT Protocol specifications: "Filter by reason type."
        public let reason: String?

        /// Filter results based on the decentralized identifier (DID) of the user account that created
        /// the URL rules.
        ///
        /// - Note: According to the AT Protocol specifications: "Filter by rule creator."
        public let createdBy: String?

        /// Sets the sorting direction of the rules array. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Sort direction."
        public let sortDirection: ToolsOzoneLexicon.Safelink.QueryRules.SortDirection?
    }

    /// An output model for querying URL rules events.
    ///
    /// - Note: According to the AT Protocol specifications: "Query URL safety rules."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.safelink.queryRules`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/safelink/queryRules.json
    public struct QueryRulesOutput: Sendable, Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Next cursor for pagination. Only present
        /// if there are more results."
        public let cursor: String?

        /// An array of rules based on the filters given.
        public let rules: ToolsOzoneLexicon.Safelink.URLRuleDefinition
    }
}
