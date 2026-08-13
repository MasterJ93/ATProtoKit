//
//  ToolsOzoneReportGetLiveStats.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-13.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ToolsOzoneLexicon.Report {

    /// An output model for getting live report statistics.
    ///
    /// - Note: According to the AT Protocol specifications: "Get live report statistics from the
    /// past 24 hours. Filter by queue, moderator, or report type. Omit all parameters for
    /// aggregate stats."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.report.getLiveStats`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/report/getLiveStats.json
    public struct GetLiveStatsOutput: Sendable, Codable {

        /// Statistics for the requested filter.
        ///
        /// - Note: According to the AT Protocol specifications: "Statistics for the
        /// requested filter."
        public let stats: LiveStatisticsDefinition
    }
}
