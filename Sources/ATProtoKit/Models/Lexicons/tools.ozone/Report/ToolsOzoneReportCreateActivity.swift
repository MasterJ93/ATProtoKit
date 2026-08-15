//
//  ToolsOzoneReportCreateActivity.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-13.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ToolsOzoneLexicon.Report {

    /// A request body model for registering an activity on a report.
    ///
    /// - Note: According to the AT Protocol specifications: "Register an activity on a report. For
    /// state-change activity types, validates the transition and updates report.status atomically."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.report.createActivity`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/report/createActivity.json
    public struct CreateActivityRequestBody: Sendable, Codable {

        /// The ID of the report to record activity on. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "ID of the report to record activity
        /// on. Exactly one of reportId or eventId must be provided."
        public let reportID: Int?

        /// The ID of the report moderation event. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "ID of the report moderation event.
        /// Resolves to the report created from that event. Exactly one of reportId or eventId
        /// must be provided."
        public let eventID: Int?

        /// The type of activity to record.
        ///
        /// - Note: According to the AT Protocol specifications: "The type of activity to record."
        public let activity: ActivityUnion

        /// An optional moderator-only note. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Optional moderator-only note.
        /// Not visible to reporters."
        public let internalNote: String?

        /// An optional public-facing note. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Optional public-facing note,
        /// potentially visible to the reporter."
        public let publicNote: String?

        /// Whether this activity is triggered by an automated process. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Set true when this activity is
        /// triggered by an automated process. Defaults to false."
        public let isAutomated: Bool?

        public init(reportID: Int? = nil, eventID: Int? = nil, activity: ActivityUnion,
                    internalNote: String? = nil, publicNote: String? = nil,
                    isAutomated: Bool? = nil) {
            self.reportID = reportID
            self.eventID = eventID
            self.activity = activity
            self.internalNote = internalNote
            self.publicNote = publicNote
            self.isAutomated = isAutomated
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.reportID = try container.decodeIfPresent(Int.self, forKey: .reportID)
            self.eventID = try container.decodeIfPresent(Int.self, forKey: .eventID)
            self.activity = try container.decode(ActivityUnion.self, forKey: .activity)
            self.internalNote = try container.decodeIfPresent(String.self, forKey: .internalNote)
            self.publicNote = try container.decodeIfPresent(String.self, forKey: .publicNote)
            self.isAutomated = try container.decodeIfPresent(Bool.self, forKey: .isAutomated)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encodeIfPresent(self.reportID, forKey: .reportID)
            try container.encodeIfPresent(self.eventID, forKey: .eventID)
            try container.encode(self.activity, forKey: .activity)
            try container.encodeIfPresent(self.internalNote, forKey: .internalNote)
            try container.encodeIfPresent(self.publicNote, forKey: .publicNote)
            try container.encodeIfPresent(self.isAutomated, forKey: .isAutomated)
        }

        enum CodingKeys: String, CodingKey {
            case reportID = "reportId"
            case eventID = "eventId"
            case activity
            case internalNote
            case publicNote
            case isAutomated
        }
    }

    /// An output model for registering an activity on a report.
    ///
    /// - Note: According to the AT Protocol specifications: "Register an activity on a report."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.report.createActivity`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/report/createActivity.json
    public struct CreateActivityOutput: Sendable, Codable {

        /// The recorded activity.
        public let activity: ReportActivityViewDefinition
    }
}
