//
//  ToolsOzoneSafelinkQueryEvents.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-07-11.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ToolsOzoneLexicon.Safelink {

    /// The main data model definition for querying URL safety audit events.
    public struct QueryEvents: Sendable, Codable {

        /// Sets the sorting direction of the audit array.
        public enum SortDirection: String, Sendable, Codable {

            /// Indicates the URL events will be sorted in ascending order.
            case ascending = "asc"

            /// Indicates the URL events will be sorted in descending order.
            case descending = "desc"
        }
    }

    /// A request body for querying URL safety audit events.
    ///
    /// - Note: According to the AT Protocol specifications: "Query URL safety audit events."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.safelink.queryEvents`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/safelink/queryEvents.json
    public struct QueryEventsRequestBody: Sendable, Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Cursor for pagination."
        public let cursor: String?

        /// The number of events in the array. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Maximum number of results to return."
        public let limit: Int?

        /// An array of URLs listed for auditing. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Filter by specific URLs or domains."
        public let urls: [URL]?

        /// Filter results based on the selected pattern type. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Filter by pattern type."
        public let patternType: String?

        /// Sets the sorting direction of the audit array. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Sort direction."
        public let sortDirection: ToolsOzoneLexicon.Safelink.QueryEvents.SortDirection?
    }

    /// An output model for querying URL safety audit events.
    ///
    /// - Note: According to the AT Protocol specifications: "Query URL safety audit events."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.safelink.queryEvents`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/safelink/queryEvents.json
    public struct QueryEventsOutput: Sendable, Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of URL rule events.
        public let events: [ToolsOzoneLexicon.Safelink.EventDefinition]
    }
}
