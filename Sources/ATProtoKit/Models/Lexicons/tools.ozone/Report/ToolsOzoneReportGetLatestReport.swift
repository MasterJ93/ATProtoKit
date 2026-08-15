//
//  ToolsOzoneReportGetLatestReport.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-13.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ToolsOzoneLexicon.Report {

    /// An output model for getting the most recent moderation report.
    ///
    /// - Note: According to the AT Protocol specifications: "Get the most recent report."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.report.getLatestReport`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/report/getLatestReport.json
    public struct GetLatestReportOutput: Sendable, Codable {

        /// The most recent moderation report.
        public let report: ReportViewDefinition
    }
}
