//
//  ToolsOzoneQueueRouteReports.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-13.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ToolsOzoneLexicon.Queue {

    /// A request body model for routing reports to matching queues.
    ///
    /// - Note: According to the AT Protocol specifications: "Route reports within an ID range to
    /// matching queues based."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.queue.routeReports`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/queue/routeReports.json
    public struct RouteReportsRequestBody: Sendable, Codable {

        /// The start of the report ID range (inclusive).
        ///
        /// - Note: According to the AT Protocol specifications: "Start of report ID range (inclusive)."
        public let startReportID: Int

        /// The end of the report ID range (inclusive).
        ///
        /// - Note: According to the AT Protocol specifications: "End of report ID range (inclusive).
        /// Difference between start and end must be less than 5,000."
        public let endReportID: Int

        public init(startReportID: Int, endReportID: Int) {
            self.startReportID = startReportID
            self.endReportID = endReportID
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.startReportID = try container.decode(Int.self, forKey: .startReportID)
            self.endReportID = try container.decode(Int.self, forKey: .endReportID)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.startReportID, forKey: .startReportID)
            try container.encode(self.endReportID, forKey: .endReportID)
        }

        enum CodingKeys: String, CodingKey {
            case startReportID = "startReportId"
            case endReportID = "endReportId"
        }
    }

    /// An output model for routing reports to matching queues.
    ///
    /// - Note: According to the AT Protocol specifications: "Route reports within an ID range to
    /// matching queues based."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.queue.routeReports`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/queue/routeReports.json
    public struct RouteReportsOutput: Sendable, Codable {

        /// The number of reports assigned to a queue.
        ///
        /// - Note: According to the AT Protocol specifications: "The number of reports assigned
        /// to a queue."
        public let assigned: Int

        /// The number of reports with no matching queue.
        ///
        /// - Note: According to the AT Protocol specifications: "The number of reports with no
        /// matching queue."
        public let unmatched: Int
    }
}
