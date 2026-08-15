//
//  ToolsOzoneReportUnassignModerator.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-13.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ToolsOzoneLexicon.Report {

    /// A request body model for removing a report assignment.
    ///
    /// - Note: According to the AT Protocol specifications: "Remove report assignment."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.report.unassignModerator`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/report/unassignModerator.json
    public struct UnassignModeratorRequestBody: Sendable, Codable {

        /// The ID of the report to unassign.
        ///
        /// - Note: According to the AT Protocol specifications: "The ID of the report to unassign."
        public let reportID: Int

        public init(reportID: Int) {
            self.reportID = reportID
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.reportID = try container.decode(Int.self, forKey: .reportID)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.reportID, forKey: .reportID)
        }

        enum CodingKeys: String, CodingKey {
            case reportID = "reportId"
        }
    }
}
