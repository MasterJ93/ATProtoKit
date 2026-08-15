//
//  ToolsOzoneReportAssignModerator.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-13.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ToolsOzoneLexicon.Report {

    /// A request body model for assigning a moderator to a report.
    ///
    /// - Note: According to the AT Protocol specifications: "Assign a report to a user. Defaults
    /// to the caller. Admins may assign to any moderator."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.report.assignModerator`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/report/assignModerator.json
    public struct AssignModeratorRequestBody: Sendable, Codable {

        /// The ID of the report to assign.
        ///
        /// - Note: According to the AT Protocol specifications: "The ID of the report to assign."
        public let reportID: Int

        /// An optional queue ID to associate the assignment with. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Optional queue ID to associate the
        /// assignment with. If not provided and the report has been assigned on a queue before,
        /// it will stay on that queue."
        public let queueID: Int?

        /// The decentralized identifier (DID) of the moderator to assign. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "DID to be assigned. Defaults to
        /// the caller's DID. Admins may assign to any moderator."
        public let did: String?

        /// Whether the assignment has no expiry. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "When true, the assignment has no
        /// expiry (endAt is null). Throws AlreadyAssigned if another user already has a permanent
        /// assignment on this report."
        public let isPermanent: Bool?

        public init(reportID: Int, queueID: Int? = nil, did: String? = nil,
                    isPermanent: Bool? = nil) {
            self.reportID = reportID
            self.queueID = queueID
            self.did = did
            self.isPermanent = isPermanent
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.reportID = try container.decode(Int.self, forKey: .reportID)
            self.queueID = try container.decodeIfPresent(Int.self, forKey: .queueID)
            self.did = try container.decodeIfPresent(String.self, forKey: .did)
            self.isPermanent = try container.decodeIfPresent(Bool.self, forKey: .isPermanent)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.reportID, forKey: .reportID)
            try container.encodeIfPresent(self.queueID, forKey: .queueID)
            try container.encodeIfPresent(self.did, forKey: .did)
            try container.encodeIfPresent(self.isPermanent, forKey: .isPermanent)
        }

        enum CodingKeys: String, CodingKey {
            case reportID = "reportId"
            case queueID = "queueId"
            case did
            case isPermanent
        }
    }
}
