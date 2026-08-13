//
//  ToolsOzoneReportReassignQueue.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-13.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ToolsOzoneLexicon.Report {

    /// A request body model for reassigning a report to a different queue.
    ///
    /// - Note: According to the AT Protocol specifications: "Manually reassign a report to a
    /// different queue (or unassign it). Records a queueActivity entry on the report."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.report.reassignQueue`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/report/reassignQueue.json
    public struct ReassignQueueRequestBody: Sendable, Codable {

        /// The ID of the report to reassign.
        ///
        /// - Note: According to the AT Protocol specifications: "ID of the report to reassign"
        public let reportID: Int

        /// The target queue ID.
        ///
        /// - Note: According to the AT Protocol specifications: "Target queue ID. Use -1 to
        /// unassign from any queue."
        public let queueID: Int

        /// An optional moderator-only note. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Optional moderator-only note
        /// recorded on the resulting queueActivity as internalNote."
        public let comment: String?

        public init(reportID: Int, queueID: Int, comment: String? = nil) {
            self.reportID = reportID
            self.queueID = queueID
            self.comment = comment
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.reportID = try container.decode(Int.self, forKey: .reportID)
            self.queueID = try container.decode(Int.self, forKey: .queueID)
            self.comment = try container.decodeIfPresent(String.self, forKey: .comment)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.reportID, forKey: .reportID)
            try container.encode(self.queueID, forKey: .queueID)
            try container.encodeIfPresent(self.comment, forKey: .comment)
        }

        enum CodingKeys: String, CodingKey {
            case reportID = "reportId"
            case queueID = "queueId"
            case comment
        }
    }

    /// An output model for reassigning a report to a different queue.
    ///
    /// - Note: According to the AT Protocol specifications: "Manually reassign a report to a
    /// different queue."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.report.reassignQueue`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/report/reassignQueue.json
    public struct ReassignQueueOutput: Sendable, Codable {

        /// The updated report.
        public let report: ReportViewDefinition
    }
}
