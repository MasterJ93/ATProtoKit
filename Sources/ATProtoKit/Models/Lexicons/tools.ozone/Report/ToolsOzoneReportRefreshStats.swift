//
//  ToolsOzoneReportRefreshStats.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-13.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ToolsOzoneLexicon.Report {

    /// A request body model for recomputing report statistics.
    ///
    /// - Note: According to the AT Protocol specifications: "Recompute report statistics for a
    /// date range. Useful for backfilling after failures or data corrections."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.report.refreshStats`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/report/refreshStats.json
    public struct RefreshStatsRequestBody: Sendable, Codable {

        /// The start date for recomputation, inclusive (YYYY-MM-DD).
        ///
        /// - Note: According to the AT Protocol specifications: "Start date for recomputation,
        /// inclusive (YYYY-MM-DD)."
        public let startDate: String

        /// The end date for recomputation, inclusive (YYYY-MM-DD).
        ///
        /// - Note: According to the AT Protocol specifications: "End date for recomputation,
        /// inclusive (YYYY-MM-DD)."
        public let endDate: String

        /// An optional list of queue IDs to recompute. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Optional list of queue IDs to
        /// recompute. Omit to recompute all groups."
        public let queueIDs: [Int]?

        public init(startDate: String, endDate: String, queueIDs: [Int]? = nil) {
            self.startDate = startDate
            self.endDate = endDate
            self.queueIDs = queueIDs
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.startDate = try container.decode(String.self, forKey: .startDate)
            self.endDate = try container.decode(String.self, forKey: .endDate)
            self.queueIDs = try container.decodeIfPresent([Int].self, forKey: .queueIDs)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.startDate, forKey: .startDate)
            try container.encode(self.endDate, forKey: .endDate)
            try container.encodeIfPresent(self.queueIDs, forKey: .queueIDs)
        }

        enum CodingKeys: String, CodingKey {
            case startDate
            case endDate
            case queueIDs = "queueIds"
        }
    }
}
