//
//  ToolsOzoneReportQueryActivities.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-13.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ToolsOzoneLexicon.Report {

    /// A definition model for querying report activities.
    ///
    /// - Note: According to the AT Protocol specifications: "Query report activities across all
    /// reports, ordered by createdAt. Used by downstream pollers; for per-report activity history
    /// use listActivities."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.report.queryActivities`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/report/queryActivities.json
    public struct QueryActivities: Sendable, Codable {

        /// The sort direction for the results.
        public enum SortDirection: String, Sendable, Codable {

            /// Ascending order.
            case ascending = "asc"

            /// Descending order.
            case descending = "desc"
        }
    }

    /// An output model for querying report activities.
    ///
    /// - Note: According to the AT Protocol specifications: "Query report activities across
    /// all reports."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.report.queryActivities`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/report/queryActivities.json
    public struct QueryActivitiesOutput: Sendable, Codable {

        /// An array of report activities.
        public let activities: [ReportActivityViewDefinition]

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?
    }
}
