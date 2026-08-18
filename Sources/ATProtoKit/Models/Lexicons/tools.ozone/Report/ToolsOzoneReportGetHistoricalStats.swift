//
//  ToolsOzoneReportGetHistoricalStats.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-13.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ToolsOzoneLexicon.Report {

    /// An output model for getting historical daily report statistics.
    ///
    /// - Note: According to the AT Protocol specifications: "Get historical daily report statistics.
    /// Returns a paginated list of daily stat snapshots, newest first. Filter by queue, moderator,
    /// or report type."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.report.getHistoricalStats`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/report/getHistoricalStats.json
    public struct GetHistoricalStatsOutput: Sendable, Codable {

        /// An array of daily historical statistics snapshots.
        public let stats: [HistoricalStatisticsDefinition]

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?
    }
}
