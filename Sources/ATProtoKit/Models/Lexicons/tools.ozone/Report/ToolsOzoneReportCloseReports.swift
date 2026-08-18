//
//  ToolsOzoneReportCloseReports.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-13.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ToolsOzoneLexicon.Report {

    /// A request body model for closing all reports on a subject matching the given criteria.
    ///
    /// - Note: According to the AT Protocol specifications: "Close all reports on a subject
    /// matching the given criteria. Reports whose current status does not permit a transition
    /// to closed are skipped silently. Intended for automated flows that resolve reports
    /// without taking action on the subject."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.report.closeReports`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/report/closeReports.json
    public struct CloseReportsRequestBody: Sendable, Codable {

        /// The subject whose reports should be closed.
        ///
        /// - Note: According to the AT Protocol specifications: "Subject DID (account-level
        /// reports) or AT-URI (record-level reports) whose reports should be closed."
        public let subject: String

        /// A filter of report types to close. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "If specified, only reports of
        /// the given report types (fully qualified reason NSIDs) are closed. When omitted, all
        /// non-closed reports on the subject are targeted."
        public let reportTypes: [String]?

        /// A moderator-only note recorded on each close activity. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Optional moderator-only note
        /// recorded on each close activity. Not visible to reporters."
        public let internalNote: String?

        /// Determines whether this action is triggered by an automated process. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Set true when this action is
        /// triggered by an automated process. Defaults to false."
        public let isAutomated: Bool?

        public init(subject: String, reportTypes: [String]? = nil, internalNote: String? = nil, isAutomated: Bool? = nil) {
            self.subject = subject
            self.reportTypes = reportTypes
            self.internalNote = internalNote
            self.isAutomated = isAutomated
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.subject = try container.decode(String.self, forKey: .subject)
            self.reportTypes = try container.decodeIfPresent([String].self, forKey: .reportTypes)
            self.internalNote = try container.decodeIfPresent(String.self, forKey: .internalNote)
            self.isAutomated = try container.decodeIfPresent(Bool.self, forKey: .isAutomated)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.subject, forKey: .subject)
            try container.encodeIfPresent(self.reportTypes, forKey: .reportTypes)
            try container.encodeIfPresent(self.internalNote, forKey: .internalNote)
            try container.encodeIfPresent(self.isAutomated, forKey: .isAutomated)
        }

        enum CodingKeys: String, CodingKey {
            case subject
            case reportTypes
            case internalNote
            case isAutomated
        }
    }

    /// An output model for closing all reports on a subject matching the given criteria.
    ///
    /// - Note: According to the AT Protocol specifications: "Close all reports on a subject
    /// matching the given criteria. Reports whose current status does not permit a transition
    /// to closed are skipped silently. Intended for automated flows that resolve reports
    /// without taking action on the subject."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.report.closeReports`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/report/closeReports.json
    public struct CloseReportsOutput: Sendable, Codable {

        /// The number of reports that were transitioned to closed.
        ///
        /// - Note: According to the AT Protocol specifications: "Number of reports that were
        /// transitioned to closed."
        public let closedCount: Int

        /// The IDs of the reports that were closed.
        ///
        /// - Note: According to the AT Protocol specifications: "IDs of the reports that
        /// were closed."
        public let reportIDs: [Int]

        enum CodingKeys: String, CodingKey {
            case closedCount
            case reportIDs = "reportIds"
        }
    }
}
