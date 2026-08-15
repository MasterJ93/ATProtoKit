//
//  ToolsOzoneReportDefs.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-13.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ToolsOzoneLexicon.Report {

    /// The current status of a moderation report.
    public enum ReportStatus: String, Sendable, Codable {

        /// The report is open and awaiting action.
        case open

        /// The report has been closed.
        case closed

        /// The report has been escalated.
        case escalated

        /// The report has been placed into a queue.
        case queued

        /// The report has been assigned to a moderator.
        case assigned
    }

    /// A definition model for a report moderator assignment.
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.report.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/report/defs.json
    public struct ReportAssignmentDefinition: Sendable, Codable {

        /// The decentralized identifier (DID) of the assigned moderator.
        ///
        /// - Note: According to the AT Protocol specifications: "DID of the assigned moderator"
        public let did: String

        /// The full member record of the assigned moderator. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Full member record of the
        /// assigned moderator"
        public let moderator: ToolsOzoneLexicon.Team.MemberDefinition?

        /// The date and time the report was assigned.
        ///
        /// - Note: According to the AT Protocol specifications: "When the report was assigned"
        public let assignedAt: Date

        public init(did: String, moderator: ToolsOzoneLexicon.Team.MemberDefinition? = nil,
                    assignedAt: Date) {
            self.did = did
            self.moderator = moderator
            self.assignedAt = assignedAt
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.did = try container.decode(String.self, forKey: .did)
            self.moderator = try container.decodeIfPresent(ToolsOzoneLexicon.Team.MemberDefinition.self, forKey: .moderator)
            self.assignedAt = try container.decodeDate(forKey: .assignedAt)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.did, forKey: .did)
            try container.encodeIfPresent(self.moderator, forKey: .moderator)
            try container.encodeDate(self.assignedAt, forKey: .assignedAt)
        }

        enum CodingKeys: CodingKey {
            case did
            case moderator
            case assignedAt
        }
    }

    /// A definition model for a moderation report view.
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.report.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/report/defs.json
    public struct ReportViewDefinition: Sendable, Codable {

        /// The ID of the report.
        ///
        /// - Note: According to the AT Protocol specifications: "Report ID"
        public let id: Int

        /// The ID of the moderation event that created this report.
        ///
        /// - Note: According to the AT Protocol specifications: "ID of the moderation event that
        /// created this report"
        public let eventID: Int

        /// The current status of the report.
        ///
        /// - Note: According to the AT Protocol specifications: "Current status of the report"
        public let status: ReportStatus

        /// The subject that was reported.
        ///
        /// - Note: According to the AT Protocol specifications: "The subject that was reported
        /// with full details"
        public let subject: ToolsOzoneLexicon.Moderation.SubjectViewDefinition

        /// The type of report.
        ///
        /// - Note: According to the AT Protocol specifications: "Type of report"
        public let reportType: ComAtprotoLexicon.Moderation.ReasonTypeDefinition

        /// The decentralized identifier (DID) of the user who made the report.
        ///
        /// - Note: According to the AT Protocol specifications: "DID of the user who made
        /// the report"
        public let reportedBy: String

        /// The subject view of the reporter account.
        ///
        /// - Note: According to the AT Protocol specifications: "Full subject view of the
        /// reporter account"
        public let reporter: ToolsOzoneLexicon.Moderation.SubjectViewDefinition

        /// A comment provided by the reporter. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Comment provided by the reporter"
        public let comment: String?

        /// The date and time the report was created.
        ///
        /// - Note: According to the AT Protocol specifications: "When the report was created"
        public let createdAt: Date

        /// The date and time the report was last updated. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "When the report was last updated"
        public let updatedAt: Date?

        /// The date and time the report was assigned to its current queue. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "When the report was assigned to
        /// its current queue"
        public let queuedAt: Date?

        /// An array of moderation event IDs for actions taken on this report. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Array of moderation event IDs
        /// representing actions taken on this report (sorted DESC, most recent first)"
        public let actionEventIDs: [Int]?

        /// Expanded action events. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Optional: expanded action events"
        public let actions: [ToolsOzoneLexicon.Moderation.ModerationEventViewDefinition]?

        /// A note sent to the reporter when the report was actioned. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Note sent to reporter when report
        /// was actioned"
        public let actionNote: String?

        /// The current status of the reported subject. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Current status of the
        /// reported subject"
        public let subjectStatus: ToolsOzoneLexicon.Moderation.SubjectStatusViewDefinition?

        /// The number of other pending reports on the same subject. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Number of other pending reports
        /// on the same subject"
        public let relatedReportCount: Int?

        /// The moderator currently assigned to this report, if any. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Information about moderator
        /// currently assigned to this report (if any)"
        public let assignment: ReportAssignmentDefinition?

        /// The queue this report is assigned to, if any. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "The queue this report is
        /// assigned to (if any)"
        public let queue: ToolsOzoneLexicon.Queue.QueueViewDefinition?

        /// Whether this report is muted. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Whether this report is muted.
        /// A report is muted if the reporter was muted or the subject was muted at the time
        /// the report was created."
        public let isMuted: Bool?

        /// Whether this report was emitted by automated tooling. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Whether this report was emitted
        /// by automated tooling."
        public let isAutomated: Bool?

        public init(id: Int, eventID: Int, status: ReportStatus,
                    subject: ToolsOzoneLexicon.Moderation.SubjectViewDefinition,
                    reportType: ComAtprotoLexicon.Moderation.ReasonTypeDefinition,
                    reportedBy: String,
                    reporter: ToolsOzoneLexicon.Moderation.SubjectViewDefinition,
                    comment: String? = nil, createdAt: Date, updatedAt: Date? = nil,
                    queuedAt: Date? = nil, actionEventIDs: [Int]? = nil,
                    actions: [ToolsOzoneLexicon.Moderation.ModerationEventViewDefinition]? = nil,
                    actionNote: String? = nil,
                    subjectStatus: ToolsOzoneLexicon.Moderation.SubjectStatusViewDefinition? = nil,
                    relatedReportCount: Int? = nil, assignment: ReportAssignmentDefinition? = nil,
                    queue: ToolsOzoneLexicon.Queue.QueueViewDefinition? = nil,
                    isMuted: Bool? = nil, isAutomated: Bool? = nil) {
            self.id = id
            self.eventID = eventID
            self.status = status
            self.subject = subject
            self.reportType = reportType
            self.reportedBy = reportedBy
            self.reporter = reporter
            self.comment = comment
            self.createdAt = createdAt
            self.updatedAt = updatedAt
            self.queuedAt = queuedAt
            self.actionEventIDs = actionEventIDs
            self.actions = actions
            self.actionNote = actionNote
            self.subjectStatus = subjectStatus
            self.relatedReportCount = relatedReportCount
            self.assignment = assignment
            self.queue = queue
            self.isMuted = isMuted
            self.isAutomated = isAutomated
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.id = try container.decode(Int.self, forKey: .id)
            self.eventID = try container.decode(Int.self, forKey: .eventID)
            self.status = try container.decode(ReportStatus.self, forKey: .status)
            self.subject = try container.decode(ToolsOzoneLexicon.Moderation.SubjectViewDefinition.self, forKey: .subject)
            self.reportType = try container.decode(ComAtprotoLexicon.Moderation.ReasonTypeDefinition.self, forKey: .reportType)
            self.reportedBy = try container.decode(String.self, forKey: .reportedBy)
            self.reporter = try container.decode(ToolsOzoneLexicon.Moderation.SubjectViewDefinition.self, forKey: .reporter)
            self.comment = try container.decodeIfPresent(String.self, forKey: .comment)
            self.createdAt = try container.decodeDate(forKey: .createdAt)
            self.updatedAt = try container.decodeDateIfPresent(forKey: .updatedAt)
            self.queuedAt = try container.decodeDateIfPresent(forKey: .queuedAt)
            self.actionEventIDs = try container.decodeIfPresent([Int].self, forKey: .actionEventIDs)
            self.actions = try container.decodeIfPresent([ToolsOzoneLexicon.Moderation.ModerationEventViewDefinition].self, forKey: .actions)
            self.actionNote = try container.decodeIfPresent(String.self, forKey: .actionNote)
            self.subjectStatus = try container.decodeIfPresent(ToolsOzoneLexicon.Moderation.SubjectStatusViewDefinition.self, forKey: .subjectStatus)
            self.relatedReportCount = try container.decodeIfPresent(Int.self, forKey: .relatedReportCount)
            self.assignment = try container.decodeIfPresent(ReportAssignmentDefinition.self, forKey: .assignment)
            self.queue = try container.decodeIfPresent(ToolsOzoneLexicon.Queue.QueueViewDefinition.self, forKey: .queue)
            self.isMuted = try container.decodeIfPresent(Bool.self, forKey: .isMuted)
            self.isAutomated = try container.decodeIfPresent(Bool.self, forKey: .isAutomated)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.id, forKey: .id)
            try container.encode(self.eventID, forKey: .eventID)
            try container.encode(self.status, forKey: .status)
            try container.encode(self.subject, forKey: .subject)
            try container.encode(self.reportType, forKey: .reportType)
            try container.encode(self.reportedBy, forKey: .reportedBy)
            try container.encode(self.reporter, forKey: .reporter)
            try container.encodeIfPresent(self.comment, forKey: .comment)
            try container.encodeDate(self.createdAt, forKey: .createdAt)
            try container.encodeDateIfPresent(self.updatedAt, forKey: .updatedAt)
            try container.encodeDateIfPresent(self.queuedAt, forKey: .queuedAt)
            try container.encodeIfPresent(self.actionEventIDs, forKey: .actionEventIDs)
            try container.encodeIfPresent(self.actions, forKey: .actions)
            try container.encodeIfPresent(self.actionNote, forKey: .actionNote)
            try container.encodeIfPresent(self.subjectStatus, forKey: .subjectStatus)
            try container.encodeIfPresent(self.relatedReportCount, forKey: .relatedReportCount)
            try container.encodeIfPresent(self.assignment, forKey: .assignment)
            try container.encodeIfPresent(self.queue, forKey: .queue)
            try container.encodeIfPresent(self.isMuted, forKey: .isMuted)
            try container.encodeIfPresent(self.isAutomated, forKey: .isAutomated)
        }

        enum CodingKeys: String, CodingKey {
            case id
            case eventID = "eventId"
            case status
            case subject
            case reportType
            case reportedBy
            case reporter
            case comment
            case createdAt
            case updatedAt
            case queuedAt
            case actionEventIDs = "actionEventIds"
            case actions
            case actionNote
            case subjectStatus
            case relatedReportCount
            case assignment
            case queue
            case isMuted
            case isAutomated
        }
    }

    /// A definition model for a queue activity on a report.
    ///
    /// - Note: According to the AT Protocol specifications: "Activity recording a report being
    /// routed to a queue."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.report.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/report/defs.json
    public struct QueueActivityDefinition: Sendable, Codable {

        /// The report's status before this activity. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "The report's status before this
        /// activity. Populated automatically from the report row; not required in input."
        public let previousStatus: ReportStatus?
    }

    /// A definition model for an assignment activity on a report.
    ///
    /// - Note: According to the AT Protocol specifications: "Activity recording a moderator being
    /// assigned to a report."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.report.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/report/defs.json
    public struct AssignmentActivityDefinition: Sendable, Codable {

        /// The report's status before this activity. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "The report's status before this
        /// activity. Populated automatically from the report row; not required in input."
        public let previousStatus: ReportStatus?
    }

    /// A definition model for an escalation activity on a report.
    ///
    /// - Note: According to the AT Protocol specifications: "Activity recording a report
    /// being escalated."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.report.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/report/defs.json
    public struct EscalationActivityDefinition: Sendable, Codable {

        /// The report's status before this activity. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "The report's status before this
        /// activity. Populated automatically from the report row; not required in input."
        public let previousStatus: ReportStatus?
    }

    /// A definition model for a close activity on a report.
    ///
    /// - Note: According to the AT Protocol specifications: "Activity recording a report
    /// being closed."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.report.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/report/defs.json
    public struct CloseActivityDefinition: Sendable, Codable {

        /// The report's status before this activity. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "The report's status before this
        /// activity. Populated automatically from the report row; not required in input."
        public let previousStatus: ReportStatus?
    }

    /// A definition model for a reopen activity on a report.
    ///
    /// - Note: According to the AT Protocol specifications: "Activity recording a closed report
    /// being reopened. Only valid when the report is in 'closed' status."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.report.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/report/defs.json
    public struct ReopenActivityDefinition: Sendable, Codable {

        /// The report's status before this activity. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "The report's status before this
        /// activity. Populated automatically from the report row; not required in input."
        public let previousStatus: ReportStatus?
    }

    /// A definition model for a note activity on a report.
    ///
    /// - Note: According to the AT Protocol specifications: "Activity recording a note on a report.
    /// Use internalNote for moderator-only notes or publicNote for reporter-visible notes
    /// (or both)."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.report.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/report/defs.json
    public struct NoteActivityDefinition: Sendable, Codable {}

    /// A union of activity types for a moderation report.
    public enum ActivityUnion: ATUnionProtocol {

        /// A queue activity.
        case queueActivity(QueueActivityDefinition)

        /// An assignment activity.
        case assignmentActivity(AssignmentActivityDefinition)

        /// An escalation activity.
        case escalationActivity(EscalationActivityDefinition)

        /// A close activity.
        case closeActivity(CloseActivityDefinition)

        /// A reopen activity.
        case reopenActivity(ReopenActivityDefinition)

        /// A note activity.
        case noteActivity(NoteActivityDefinition)

        /// An unknown activity.
        case unknown(String, [String: CodableValue])

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let type = try container.decodeIfPresent(String.self, forKey: .type)

            switch type {
                case "tools.ozone.report.defs#queueActivity":
                    self = .queueActivity(try QueueActivityDefinition(from: decoder))
                case "tools.ozone.report.defs#assignmentActivity":
                    self = .assignmentActivity(try AssignmentActivityDefinition(from: decoder))
                case "tools.ozone.report.defs#escalationActivity":
                    self = .escalationActivity(try EscalationActivityDefinition(from: decoder))
                case "tools.ozone.report.defs#closeActivity":
                    self = .closeActivity(try CloseActivityDefinition(from: decoder))
                case "tools.ozone.report.defs#reopenActivity":
                    self = .reopenActivity(try ReopenActivityDefinition(from: decoder))
                case "tools.ozone.report.defs#noteActivity":
                    self = .noteActivity(try NoteActivityDefinition(from: decoder))
                default:
                    let singleValueDecodingContainer = try decoder.singleValueContainer()
                    let dictionary = try Self.decodeDictionary(from: singleValueDecodingContainer, decoder: decoder)
                    self = .unknown(type ?? "unknown", dictionary)
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            switch self {
                case .queueActivity(let activity):
                    try container.encode("tools.ozone.report.defs#queueActivity", forKey: .type)
                    try activity.encode(to: encoder)
                case .assignmentActivity(let activity):
                    try container.encode("tools.ozone.report.defs#assignmentActivity", forKey: .type)
                    try activity.encode(to: encoder)
                case .escalationActivity(let activity):
                    try container.encode("tools.ozone.report.defs#escalationActivity", forKey: .type)
                    try activity.encode(to: encoder)
                case .closeActivity(let activity):
                    try container.encode("tools.ozone.report.defs#closeActivity", forKey: .type)
                    try activity.encode(to: encoder)
                case .reopenActivity(let activity):
                    try container.encode("tools.ozone.report.defs#reopenActivity", forKey: .type)
                    try activity.encode(to: encoder)
                case .noteActivity(let activity):
                    try container.encode("tools.ozone.report.defs#noteActivity", forKey: .type)
                    try activity.encode(to: encoder)
                case .unknown(let type, _):
                    try container.encode(type, forKey: .type)
            }
        }

        enum CodingKeys: String, CodingKey {
            case type = "$type"
        }
    }

    /// A definition model for a single activity entry on a report.
    ///
    /// - Note: According to the AT Protocol specifications: "A single activity entry on a report."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.report.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/report/defs.json
    public struct ReportActivityViewDefinition: Sendable, Codable {

        /// The ID of the activity.
        ///
        /// - Note: According to the AT Protocol specifications: "Activity ID"
        public let id: Int

        /// The ID of the report this activity belongs to.
        ///
        /// - Note: According to the AT Protocol specifications: "ID of the report this activity
        /// belongs to"
        public let reportID: Int

        /// The typed activity object describing what occurred.
        ///
        /// - Note: According to the AT Protocol specifications: "The typed activity object
        /// describing what occurred."
        public let activity: ActivityUnion

        /// An optional moderator-only note. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Optional moderator-only note.
        /// Not visible to reporters."
        public let internalNote: String?

        /// An optional public note, potentially visible to the reporter. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Optional public note, potentially
        /// visible to the reporter."
        public let publicNote: String?

        /// Extensible JSON payload for loose activity-specific metadata. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Extensible JSON payload for loose
        /// activity-specific metadata (e.g. assignmentId)."
        public let meta: UnknownType?

        /// Whether this activity was created by an automated process.
        ///
        /// - Note: According to the AT Protocol specifications: "True if this activity was created
        /// by an automated process (e.g. queue router) rather than a direct human action."
        public let isAutomated: Bool

        /// The decentralized identifier (DID) of the actor who created this activity.
        ///
        /// - Note: According to the AT Protocol specifications: "DID of the actor who created this
        /// activity, or the service DID for automated activities."
        public let createdBy: String

        /// The full member record of the moderator who created this activity. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Full member record of the
        /// moderator who created this activity"
        public let moderator: ToolsOzoneLexicon.Team.MemberDefinition?

        /// The full view of the report this activity belongs to. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Full view of the report this
        /// activity belongs to."
        public let report: ReportViewDefinition?

        /// The date and time this activity was created.
        ///
        /// - Note: According to the AT Protocol specifications: "When this activity was created"
        public let createdAt: Date

        public init(id: Int, reportID: Int, activity: ActivityUnion, internalNote: String? = nil,
                    publicNote: String? = nil, meta: UnknownType? = nil, isAutomated: Bool,
                    createdBy: String, moderator: ToolsOzoneLexicon.Team.MemberDefinition? = nil,
                    report: ReportViewDefinition? = nil, createdAt: Date) {
            self.id = id
            self.reportID = reportID
            self.activity = activity
            self.internalNote = internalNote
            self.publicNote = publicNote
            self.meta = meta
            self.isAutomated = isAutomated
            self.createdBy = createdBy
            self.moderator = moderator
            self.report = report
            self.createdAt = createdAt
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.id = try container.decode(Int.self, forKey: .id)
            self.reportID = try container.decode(Int.self, forKey: .reportID)
            self.activity = try container.decode(ActivityUnion.self, forKey: .activity)
            self.internalNote = try container.decodeIfPresent(String.self, forKey: .internalNote)
            self.publicNote = try container.decodeIfPresent(String.self, forKey: .publicNote)
            self.meta = try container.decodeIfPresent(UnknownType.self, forKey: .meta)
            self.isAutomated = try container.decode(Bool.self, forKey: .isAutomated)
            self.createdBy = try container.decode(String.self, forKey: .createdBy)
            self.moderator = try container.decodeIfPresent(ToolsOzoneLexicon.Team.MemberDefinition.self, forKey: .moderator)
            self.report = try container.decodeIfPresent(ReportViewDefinition.self, forKey: .report)
            self.createdAt = try container.decodeDate(forKey: .createdAt)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.id, forKey: .id)
            try container.encode(self.reportID, forKey: .reportID)
            try container.encode(self.activity, forKey: .activity)
            try container.encodeIfPresent(self.internalNote, forKey: .internalNote)
            try container.encodeIfPresent(self.publicNote, forKey: .publicNote)
            try container.encodeIfPresent(self.meta, forKey: .meta)
            try container.encode(self.isAutomated, forKey: .isAutomated)
            try container.encode(self.createdBy, forKey: .createdBy)
            try container.encodeIfPresent(self.moderator, forKey: .moderator)
            try container.encodeIfPresent(self.report, forKey: .report)
            try container.encodeDate(self.createdAt, forKey: .createdAt)
        }

        enum CodingKeys: String, CodingKey {
            case id
            case reportID = "reportId"
            case activity
            case internalNote
            case publicNote
            case meta
            case isAutomated
            case createdBy
            case moderator
            case report
            case createdAt
        }
    }

    /// A definition model for live report statistics.
    ///
    /// - Note: According to the AT Protocol specifications: "Live statistics for reports for the
    /// current calendar day, filterable by queue, moderator, or report type."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.report.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/report/defs.json
    public struct LiveStatisticsDefinition: Sendable, Codable {

        /// The number of reports currently not closed. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Number of reports currently
        /// not closed."
        public let pendingCount: Int?

        /// The number of reports closed today. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Number of reports closed today."
        public let actionedCount: Int?

        /// The number of reports escalated today. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Number of reports escalated today."
        public let escalatedCount: Int?

        /// Reports received today. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Reports received today."
        public let inboundCount: Int?

        /// Percentage of reports actioned, rounded to nearest integer. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Percentage of reports actioned
        /// (actionedCount / inboundCount * 100), rounded to nearest integer."
        public let actionRate: Int?

        /// Average handling time in seconds. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Average time in seconds from report
        /// creation (or moderator assignment) to close."
        public let avgHandlingTimeSec: Int?

        /// When these statistics were last computed. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "When these statistics were
        /// last computed."
        public let lastUpdated: Date?

        public init(pendingCount: Int? = nil, actionedCount: Int? = nil,
                    escalatedCount: Int? = nil, inboundCount: Int? = nil,
                    actionRate: Int? = nil, avgHandlingTimeSec: Int? = nil,
                    lastUpdated: Date? = nil) {
            self.pendingCount = pendingCount
            self.actionedCount = actionedCount
            self.escalatedCount = escalatedCount
            self.inboundCount = inboundCount
            self.actionRate = actionRate
            self.avgHandlingTimeSec = avgHandlingTimeSec
            self.lastUpdated = lastUpdated
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.pendingCount = try container.decodeIfPresent(Int.self, forKey: .pendingCount)
            self.actionedCount = try container.decodeIfPresent(Int.self, forKey: .actionedCount)
            self.escalatedCount = try container.decodeIfPresent(Int.self, forKey: .escalatedCount)
            self.inboundCount = try container.decodeIfPresent(Int.self, forKey: .inboundCount)
            self.actionRate = try container.decodeIfPresent(Int.self, forKey: .actionRate)
            self.avgHandlingTimeSec = try container.decodeIfPresent(Int.self, forKey: .avgHandlingTimeSec)
            self.lastUpdated = try container.decodeDateIfPresent(forKey: .lastUpdated)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encodeIfPresent(self.pendingCount, forKey: .pendingCount)
            try container.encodeIfPresent(self.actionedCount, forKey: .actionedCount)
            try container.encodeIfPresent(self.escalatedCount, forKey: .escalatedCount)
            try container.encodeIfPresent(self.inboundCount, forKey: .inboundCount)
            try container.encodeIfPresent(self.actionRate, forKey: .actionRate)
            try container.encodeIfPresent(self.avgHandlingTimeSec, forKey: .avgHandlingTimeSec)
            try container.encodeDateIfPresent(self.lastUpdated, forKey: .lastUpdated)
        }

        enum CodingKeys: CodingKey {
            case pendingCount
            case actionedCount
            case escalatedCount
            case inboundCount
            case actionRate
            case avgHandlingTimeSec
            case lastUpdated
        }
    }

    /// A definition model for a single daily snapshot of historical report statistics.
    ///
    /// - Note: According to the AT Protocol specifications: "A single daily snapshot of report
    /// statistics for a calendar date."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.report.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/report/defs.json
    public struct HistoricalStatisticsDefinition: Sendable, Codable {

        /// The calendar date this snapshot covers (YYYY-MM-DD).
        ///
        /// - Note: According to the AT Protocol specifications: "The calendar date this snapshot
        /// covers (YYYY-MM-DD)."
        public let date: String

        /// When this snapshot was last computed. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "When this snapshot was
        /// last computed."
        public let computedAt: Date?

        /// The number of reports not closed at time of computation. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Number of reports not closed at
        /// time of computation."
        public let pendingCount: Int?

        /// The number of reports closed during this day. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Number of reports closed during
        /// this day."
        public let actionedCount: Int?

        /// The number of reports escalated during this day. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Number of reports escalated during
        /// this day."
        public let escalatedCount: Int?

        /// Reports received during this day. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Reports received during this day."
        public let inboundCount: Int?

        /// Percentage of reports actioned, rounded to nearest integer. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Percentage of reports actioned
        /// (actionedCount / inboundCount * 100), rounded to nearest integer."
        public let actionRate: Int?

        /// Average handling time in seconds. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Average time in seconds from report
        /// creation (or moderator assignment) to close."
        public let avgHandlingTimeSec: Int?

        public init(date: String, computedAt: Date? = nil, pendingCount: Int? = nil,
                    actionedCount: Int? = nil, escalatedCount: Int? = nil,
                    inboundCount: Int? = nil, actionRate: Int? = nil,
                    avgHandlingTimeSec: Int? = nil) {
            self.date = date
            self.computedAt = computedAt
            self.pendingCount = pendingCount
            self.actionedCount = actionedCount
            self.escalatedCount = escalatedCount
            self.inboundCount = inboundCount
            self.actionRate = actionRate
            self.avgHandlingTimeSec = avgHandlingTimeSec
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.date = try container.decode(String.self, forKey: .date)
            self.computedAt = try container.decodeDateIfPresent(forKey: .computedAt)
            self.pendingCount = try container.decodeIfPresent(Int.self, forKey: .pendingCount)
            self.actionedCount = try container.decodeIfPresent(Int.self, forKey: .actionedCount)
            self.escalatedCount = try container.decodeIfPresent(Int.self, forKey: .escalatedCount)
            self.inboundCount = try container.decodeIfPresent(Int.self, forKey: .inboundCount)
            self.actionRate = try container.decodeIfPresent(Int.self, forKey: .actionRate)
            self.avgHandlingTimeSec = try container.decodeIfPresent(Int.self, forKey: .avgHandlingTimeSec)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.date, forKey: .date)
            try container.encodeDateIfPresent(self.computedAt, forKey: .computedAt)
            try container.encodeIfPresent(self.pendingCount, forKey: .pendingCount)
            try container.encodeIfPresent(self.actionedCount, forKey: .actionedCount)
            try container.encodeIfPresent(self.escalatedCount, forKey: .escalatedCount)
            try container.encodeIfPresent(self.inboundCount, forKey: .inboundCount)
            try container.encodeIfPresent(self.actionRate, forKey: .actionRate)
            try container.encodeIfPresent(self.avgHandlingTimeSec, forKey: .avgHandlingTimeSec)
        }

        enum CodingKeys: CodingKey {
            case date
            case computedAt
            case pendingCount
            case actionedCount
            case escalatedCount
            case inboundCount
            case actionRate
            case avgHandlingTimeSec
        }
    }

    /// A definition model for a report moderator assignment view.
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.report.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/report/defs.json
    public struct ReportAssignmentViewDefinition: Sendable, Codable {

        /// The ID of the assignment.
        public let id: Int

        /// The decentralized identifier (DID) of the assigned moderator.
        public let did: String

        /// The full member record of the assigned moderator. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "The moderator assigned to
        /// this report"
        public let moderator: ToolsOzoneLexicon.Team.MemberDefinition?

        /// The queue this assignment is associated with. Optional.
        public let queue: ToolsOzoneLexicon.Queue.QueueViewDefinition?

        /// The ID of the report.
        public let reportID: Int

        /// The date and time the assignment starts.
        public let startAt: Date

        /// The date and time the assignment ends. Optional.
        public let endAt: Date?

        public init(id: Int, did: String, moderator: ToolsOzoneLexicon.Team.MemberDefinition? = nil,
                    queue: ToolsOzoneLexicon.Queue.QueueViewDefinition? = nil,
                    reportID: Int, startAt: Date, endAt: Date? = nil) {
            self.id = id
            self.did = did
            self.moderator = moderator
            self.queue = queue
            self.reportID = reportID
            self.startAt = startAt
            self.endAt = endAt
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.id = try container.decode(Int.self, forKey: .id)
            self.did = try container.decode(String.self, forKey: .did)
            self.moderator = try container.decodeIfPresent(ToolsOzoneLexicon.Team.MemberDefinition.self, forKey: .moderator)
            self.queue = try container.decodeIfPresent(ToolsOzoneLexicon.Queue.QueueViewDefinition.self, forKey: .queue)
            self.reportID = try container.decode(Int.self, forKey: .reportID)
            self.startAt = try container.decodeDate(forKey: .startAt)
            self.endAt = try container.decodeDateIfPresent(forKey: .endAt)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.id, forKey: .id)
            try container.encode(self.did, forKey: .did)
            try container.encodeIfPresent(self.moderator, forKey: .moderator)
            try container.encodeIfPresent(self.queue, forKey: .queue)
            try container.encode(self.reportID, forKey: .reportID)
            try container.encodeDate(self.startAt, forKey: .startAt)
            try container.encodeDateIfPresent(self.endAt, forKey: .endAt)
        }

        enum CodingKeys: String, CodingKey {
            case id
            case did
            case moderator
            case queue
            case reportID = "reportId"
            case startAt
            case endAt
        }
    }
}
