//
//  ToolsOzoneReportGetAssignments.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-13.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ToolsOzoneLexicon.Report {

    /// An output model for getting assignments for reports.
    ///
    /// - Note: According to the AT Protocol specifications: "Get assignments for reports."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.report.getAssignments`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/report/getAssignments.json
    public struct GetAssignmentsOutput: Sendable, Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of report moderator assignments.
        public let assignments: [ReportAssignmentViewDefinition]
    }
}
