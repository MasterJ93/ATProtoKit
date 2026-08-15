//
//  ToolsOzoneReportQueryReports.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-13.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ToolsOzoneLexicon.Report {

    /// A definition model for querying moderation reports.
    ///
    /// - Note: According to the AT Protocol specifications: "View moderation reports. Reports are
    /// individual instances of content being reported, as opposed to subject statuses which
    /// aggregate reports at the subject level."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.report.queryReports`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/report/queryReports.json
    public struct QueryReports: Sendable, Codable {

        /// The sort field for the results.
        public enum SortField: String, Sendable, Codable {

            /// Sort by creation date.
            case createdAt

            /// Sort by last update date.
            case updatedAt
        }

        /// The sort direction for the results.
        public enum SortDirection: String, Sendable, Codable {

            /// Ascending order.
            case ascending = "asc"

            /// Descending order.
            case descending = "desc"
        }
    }

    /// An output model for querying moderation reports.
    ///
    /// - Note: According to the AT Protocol specifications: "View moderation reports."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.report.queryReports`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/report/queryReports.json
    public struct QueryReportsOutput: Sendable, Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of moderation reports.
        public let reports: [ReportViewDefinition]
    }
}
