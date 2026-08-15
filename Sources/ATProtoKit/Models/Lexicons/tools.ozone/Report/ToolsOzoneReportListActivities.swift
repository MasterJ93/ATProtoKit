//
//  ToolsOzoneReportListActivities.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-13.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ToolsOzoneLexicon.Report {

    /// An output model for listing all activities for a report.
    ///
    /// - Note: According to the AT Protocol specifications: "List all activities for a report,
    /// sorted most-recent-first."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.report.listActivities`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/report/listActivities.json
    public struct ListActivitiesOutput: Sendable, Codable {

        /// An array of report activities.
        public let activities: [ReportActivityViewDefinition]

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?
    }
}
