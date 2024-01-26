//
//  AtprotoAdminDef.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-25.
//

import Foundation

public struct StatusAttr: Codable {
    public let isApplied: Bool
    public let reference: String? = nil

    enum CodingKeys: String, CodingKey {
        case isApplied = "applied"
        case reference = "ref"
    }
}

public struct ModEventView: Codable {
    public let id: Int
    public let event: EventViewUnion
    public let subject: RepoReferencesUnion
    public let subjectBlobCIDHashes: [String]
    public let createdBy: String
    @DateFormatting public var createdAt: Date
    public let creatorHandle: String? = nil
    public let subjectHandle: String? = nil

    enum CodingKeys: String, CodingKey {
        case id
        case event
        case subject
        case subjectBlobCIDHashes = "subjectBlobCids"
        case createdBy
        case createdAt
        case creatorHandle
        case subjectHandle
    }
}

public struct ModEventViewDetail: Codable {
    public let id: Int
    public let event: EventViewDetailUnion
    public let subject: RepoViewUnion
    public let subjectBlobs: [BlobView]
    public let createdBy: String
    @DateFormatting public var createdAt: Date
}

public struct ReportView: Codable {
    public let id: Int
    public let reasonType: ModerationReasonType
    public let comment: String? = nil
    public let subjectRepoHandle: String? = nil
    public let subject: RepoReferencesUnion
    public let reportedBy: String
    @DateFormatting public var createdAt: Date
    public let resolvedByActionIDs: [Int]

    enum CodingKeys: String, CodingKey {
        case id
        case reasonType
        case comment
        case subjectRepoHandle
        case subject
        case reportedBy
        case createdAt
        case resolvedByActionIDs = "resolvedByActionIds"
    }
}

public struct SubjectStatusView: Codable {
    public let id: Int
    public let subject: RepoReferencesUnion
    public var subjectBlobCIDHashes: [String]? = nil
    public var subjectRepoHandle: String? = nil
    @DateFormatting public var updatedAt: Date // Timestamp referencing when the last update was made to the moderation status of the subject
    @DateFormatting public var createdAt: Date // Timestamp referencing the first moderation status impacting event was emitted on the subject
    public let reviewState: SubjectReviewState
    public var comment: String? = nil
    @DateFormattingOptional public var muteUntil: Date? = nil
    public var lastReviewedBy: String? = nil
    @DateFormattingOptional public var lastReviewedAt: Date? = nil
    @DateFormattingOptional public var lastReportedAt: Date? = nil
    @DateFormattingOptional public var lastAppealedAt: Date? = nil
    public var isTakenDown: Bool? = nil
    public var wasAppealed: Bool? = nil
    @DateFormattingOptional public var suspendUntil: Date? = nil

    public init(id: Int, subject: RepoReferencesUnion, subjectBlobCIDHashes: [String]?, subjectRepoHandle: String?, updatedAt: Date, createdAt: Date, reviewState: SubjectReviewState, comment: String?, muteUntil: Date? = nil, lastReviewedBy: String?, lastReviewedAt: Date? = nil, lastReportedAt: Date? = nil, lastAppealedAt: Date? = nil, isTakenDown: Bool?, wasAppealed: Bool?, suspendUntil: Date? = nil) {
        self.id = id
        self.subject = subject
        self.subjectBlobCIDHashes = subjectBlobCIDHashes
        self.subjectRepoHandle = subjectRepoHandle
        self._updatedAt = DateFormatting(wrappedValue: updatedAt)
        self._createdAt = DateFormatting(wrappedValue: createdAt)
        self.reviewState = reviewState
        self.comment = comment
        self.muteUntil = muteUntil
        self.lastReviewedBy = lastReviewedBy
        self._lastReviewedAt = DateFormattingOptional(wrappedValue: lastReviewedAt)
        self._lastReportedAt = DateFormattingOptional(wrappedValue: lastReportedAt)
        self._lastAppealedAt = DateFormattingOptional(wrappedValue: lastAppealedAt)
        self.isTakenDown = isTakenDown
        self.wasAppealed = wasAppealed
        self._suspendUntil = DateFormattingOptional(wrappedValue: suspendUntil)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.subject = try container.decode(RepoReferencesUnion.self, forKey: .subject)
        self.subjectBlobCIDHashes = try container.decodeIfPresent([String].self, forKey: .subjectBlobCIDHashes)
        self.subjectRepoHandle = try container.decodeIfPresent(String.self, forKey: .subjectRepoHandle)
        self._updatedAt = try container.decode(DateFormatting.self, forKey: .updatedAt)
        self._createdAt = try container.decode(DateFormatting.self, forKey: .createdAt)
        self.reviewState = try container.decode(SubjectReviewState.self, forKey: .reviewState)
        self.comment = try container.decodeIfPresent(String.self, forKey: .comment)
        self._muteUntil = try container.decode(DateFormattingOptional.self, forKey: .muteUntil)
        self.lastReviewedBy = try container.decodeIfPresent(String.self, forKey: .lastReviewedBy)
        self.lastReviewedAt = try container.decodeIfPresent(DateFormattingOptional.self, forKey: .lastReviewedAt)?.wrappedValue
        self.lastReportedAt = try container.decodeIfPresent(DateFormattingOptional.self, forKey: .lastReportedAt)?.wrappedValue
        self.lastAppealedAt = try container.decodeIfPresent(DateFormattingOptional.self, forKey: .lastAppealedAt)?.wrappedValue
        self.isTakenDown = try container.decodeIfPresent(Bool.self, forKey: .isTakenDown)
        self.wasAppealed = try container.decodeIfPresent(Bool.self, forKey: .wasAppealed)
        self.suspendUntil = try container.decodeIfPresent(DateFormattingOptional.self, forKey: .suspendUntil)?.wrappedValue
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.subject, forKey: .subject)
        try container.encodeIfPresent(self.subjectBlobCIDHashes, forKey: .subjectBlobCIDHashes)
        try container.encodeIfPresent(self.subjectRepoHandle, forKey: .subjectRepoHandle)
        try container.encode(self._updatedAt, forKey: .updatedAt)
        try container.encode(self._createdAt, forKey: .createdAt)
        try container.encode(self.reviewState, forKey: .reviewState)
        try container.encodeIfPresent(self.comment, forKey: .comment)
        try container.encode(self._muteUntil, forKey: .muteUntil)
        try container.encodeIfPresent(self.lastReviewedBy, forKey: .lastReviewedBy)
        try container.encode(self._lastReviewedAt, forKey: .lastReviewedAt)
        try container.encode(self._lastReportedAt, forKey: .lastReportedAt)
        try container.encode(self._lastAppealedAt, forKey: .lastAppealedAt)
        try container.encodeIfPresent(self.isTakenDown, forKey: .isTakenDown)
        try container.encodeIfPresent(self.wasAppealed, forKey: .wasAppealed)
        try container.encode(self._suspendUntil, forKey: .suspendUntil)
    }

    enum CodingKeys: String, CodingKey {
        case id
        case subject
        case subjectBlobCIDHashes = "subjectBlobCids"
        case subjectRepoHandle
        case updatedAt
        case createdAt
        case reviewState
        case comment
        case muteUntil
        case lastReviewedBy
        case lastReviewedAt
        case lastReportedAt
        case lastAppealedAt
        case isTakenDown = "takendown"
        case wasAppealed = "appealed"
        case suspendUntil
    }
}

public struct ReportViewDetail: Codable {
    public let id: Int
    public let reasonType: ModerationReasonType
    public var comment: String? = nil
    public let subject: RepoViewUnion
    public var subjectStatus: SubjectStatusView? = nil
    public let reportedBy: String
    @DateFormatting public var createdAt: Date
    public let resolvedByActions: [ModEventView]

}

public struct AdminRepoView: Codable {
    public let atDID: String
    public let handle: String
    public var email: String? = nil
    public let relatedRecords: UnknownType
    @DateFormatting public var indexedAt: Date
    public let moderation: AdminModeration
    public var invitedBy: ServerInviteCode? = nil
    public var areInvitesDisabled: Bool? = nil
    public var inviteNote: String? = nil

    enum CodingKeys: String, CodingKey {
        case atDID = "did"
        case handle
        case email
        case relatedRecords
        case indexedAt
        case moderation
        case invitedBy
        case areInvitesDisabled = "invitesDisabled"
        case inviteNote
    }
}

public struct RepoViewDetail: Codable {
    public let atDID: String
    public let handle: String
    public var email: String? = nil
    public let relatedRecords: UnknownType
    @DateFormatting public var indexedAt: Date
    public let moderation: AdminModeration
    public var labels: [Label]? = nil
    public var invitedBy: ServerInviteCode? = nil
    public var invites: [ServerInviteCode]? = nil
    public var areInvitesDisabled: Bool? = nil
    public var inviteNote: String? = nil
    @DateFormattingOptional public var emailConfirmedAt: Date? = nil

    public init(atDID: String, handle: String, email: String?, relatedRecords: UnknownType, indexedAt: Date, moderation: AdminModeration, labels: [Label]?, invitedBy: ServerInviteCode?, invites: [ServerInviteCode]?, areInvitesDisabled: Bool?, inviteNote: String?, emailConfirmedAt: Date? = nil) {
        self.atDID = atDID
        self.handle = handle
        self.email = email
        self.relatedRecords = relatedRecords
        self._indexedAt = DateFormatting(wrappedValue: indexedAt)
        self.moderation = moderation
        self.labels = labels
        self.invitedBy = invitedBy
        self.invites = invites
        self.areInvitesDisabled = areInvitesDisabled
        self.inviteNote = inviteNote
        self._emailConfirmedAt = DateFormattingOptional(wrappedValue: emailConfirmedAt)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.atDID = try container.decode(String.self, forKey: .atDID)
        self.handle = try container.decode(String.self, forKey: .handle)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.relatedRecords = try container.decode(UnknownType.self, forKey: .relatedRecords)
        self._indexedAt = try container.decode(DateFormatting.self, forKey: .indexedAt)
        self.moderation = try container.decode(AdminModeration.self, forKey: .moderation)
        self.labels = try container.decodeIfPresent([Label].self, forKey: .labels)
        self.invitedBy = try container.decodeIfPresent(ServerInviteCode.self, forKey: .invitedBy)
        self.invites = try container.decodeIfPresent([ServerInviteCode].self, forKey: .invites)
        self.areInvitesDisabled = try container.decodeIfPresent(Bool.self, forKey: .areInvitesDisabled)
        self.inviteNote = try container.decodeIfPresent(String.self, forKey: .inviteNote)
        self.emailConfirmedAt = try container.decodeIfPresent(DateFormattingOptional.self, forKey: .emailConfirmedAt)?.wrappedValue
    }

    enum CodingKeys: String, CodingKey {
        case atDID = "did"
        case handle
        case email
        case relatedRecords
        case indexedAt
        case moderation
        case labels
        case invitedBy
        case invites
        case areInvitesDisabled = "invitesDisabled"
        case inviteNote
        case emailConfirmedAt
    }
}

public struct AdminAccountView: Codable {
    public let atDID: String
    public let handle: String
    public var email: String? = nil
    public var relatedRecords: [UnknownType]? = nil
    @DateFormatting public var indexedAt: Date
    public var invitedBy: ServerInviteCode? = nil
    public var invites: [ServerInviteCode]? = nil
    public var areInvitesDisabled: Bool? = nil
    @DateFormattingOptional public var emailConfirmedAt: Date? = nil
    public var inviteNote: String? = nil

    public init(atDID: String, handle: String, email: String?, relatedRecords: [UnknownType]?, indexedAt: Date, invitedBy: ServerInviteCode?, invites: [ServerInviteCode]?, areInvitesDisabled: Bool?, emailConfirmedAt: Date? = nil, inviteNote: String?) {
        self.atDID = atDID
        self.handle = handle
        self.email = email
        self.relatedRecords = relatedRecords
        self._indexedAt = DateFormatting(wrappedValue: indexedAt)
        self.invitedBy = invitedBy
        self.invites = invites
        self.areInvitesDisabled = areInvitesDisabled
        self._emailConfirmedAt = DateFormattingOptional(wrappedValue: emailConfirmedAt)
        self.inviteNote = inviteNote
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.atDID = try container.decode(String.self, forKey: .atDID)
        self.handle = try container.decode(String.self, forKey: .handle)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.relatedRecords = try container.decodeIfPresent([UnknownType].self, forKey: .relatedRecords)
        self._indexedAt = try container.decode(DateFormatting.self, forKey: .indexedAt)
        self.invitedBy = try container.decodeIfPresent(ServerInviteCode.self, forKey: .invitedBy)
        self.invites = try container.decodeIfPresent([ServerInviteCode].self, forKey: .invites)
        self.areInvitesDisabled = try container.decodeIfPresent(Bool.self, forKey: .areInvitesDisabled)
        self.emailConfirmedAt = try container.decodeIfPresent(DateFormattingOptional.self, forKey: .emailConfirmedAt)?.wrappedValue
        self.inviteNote = try container.decodeIfPresent(String.self, forKey: .inviteNote)
    }

    enum CodingKeys: String, CodingKey {
        case atDID = "did"
        case handle
        case email
        case relatedRecords
        case indexedAt
        case invitedBy
        case invites
        case areInvitesDisabled = "invitesDisabled"
        case emailConfirmedAt
        case inviteNote
    }
}

public struct RepoViewNotFound: Codable {
    public let atDid: String

    enum CodingKeys: String, CodingKey {
        case atDid = "did"
    }
}

public struct RepoReference: Codable {
    public let atDid: String

    enum CodingKeys: String, CodingKey {
        case atDid = "did"
    }
}

public struct RepoBlobReference: Codable {
    public let atDid: String
    public let cidHash: String
    public let recordURI: String?

    enum CodingKeys: String, CodingKey {
        case atDid = "did"
        case cidHash = "cid"
        case recordURI = "recordUri"
    }
}

public struct AdminRecordView: Codable {
    public let atURI: String
    public let cidHash: String
    public let value: UnknownType
    public let blobCIDHashes: [String]
    @DateFormatting public var indexedAt: Date
    public let moderation: AdminModeration
    public let repo: AdminRepoView

    enum CodingKeys: String, CodingKey {
        case atURI = "uri"
        case cidHash = "cid"
        case value
        case blobCIDHashes = "blobCids"
        case indexedAt
        case moderation
        case repo
    }
}

public struct AdminRecordViewDetail: Codable {
    public let atURI: String
    public let cidHash: String
    public let value: String
    public let blobs: [BlobView]
    public var labels: [Label]? = nil
    @DateFormatting public var indexedAt: Date
    public let moderation: AdminModerationDetail
    public let repo: AdminRepoView

    enum CodingKeys: String, CodingKey {
        case atURI = "uri"
        case cidHash = "cid"
        case value
        case blobs
        case labels
        case indexedAt
        case moderation
        case repo
    }
}

public struct RecordViewNotFound: Codable {
    public let atURI: String

    enum CodingKeys: String, CodingKey {
        case atURI = "uri"
    }
}

public struct AdminModeration: Codable {
    public var subjectStatus: SubjectStatusView? = nil
}

public struct AdminModerationDetail: Codable {
    public var subjectStatus: SubjectStatusView? = nil
}

public struct BlobView: Codable {
    public let cidHash: String
    public let mimeType: String
    public let size: Int
    @DateFormatting public var createdAt: Date
    public let details: MediaDetailUnion
    public let moderation: AdminModeration

    enum CodingKeys: String, CodingKey {
        case cidHash = "cid"
        case mimeType
        case size
        case createdAt
        case details
        case moderation
    }
}

public struct MediaImageDetails: Codable {
    public let width: Int
    public let height: Int
}

public struct MediaVideoDetails: Codable {
    public let width: Int
    public let height: Int
    public let length: Int
}

public enum SubjectReviewState: String, Codable {
    /// Moderator review status of a subject: Open. Indicates that the subject needs to be reviewed by a moderator.
    case reviewOpen

    /// Moderator review status of a subject: Escalated. Indicates that the subject was escalated for review by a moderator.
    case reviewEscalated

    /// Moderator review status of a subject: Closed. Indicates that the subject was already reviewed and resolved by a moderator.
    case reviewClosed
}

public struct ModEventTakedown: Codable {
    public let comment: String?
    public let durationInHours: Int?
}

public struct ModEventReverseTakedown: Codable {
    public let comment: String?
}

public struct ModEventResolveAppeal: Codable {
    public let comment: String?
}

public struct ModEventComment: Codable {
    public let comment: String
    public let isSticky: Bool?

    enum CodingKeys: String, CodingKey {
        case comment
        case isSticky = "sticky"
    }
}

public struct ModEventReport: Codable {
    public var comment: String? = nil
    public let reportType: ModerationReasonType
}

public struct ModEventLabel: Codable {
    public let comment: String?
    public let createLabelValues: [String]
    public let negateLabelValues: [String]

    enum CodingKeys: String, CodingKey {
        case comment
        case createLabelValues = "createLabelVals"
        case negateLabelValues = "negateLabelVals"
    }
}

public struct ModEventAcknowledge: Codable {
    public var comment: String? = nil
}

public struct ModEventEscalate: Codable {
    public var comment: String? = nil
}

public struct ModEventMute: Codable {
    public var comment: String? = nil
    public let durationInHours: Int
}

public struct ModEventUnmute: Codable {
    public var comment: String? = nil
}

public struct ModEventEmail: Codable {
    public let subjectLine: String
    public var comment: String? = nil
}

public struct CommunicationTemplateView: Codable {
    public let id: Int
    public let name: String
    public var subject: String? = nil
    public let contentMarkdown: String
    public let isDisabled: Bool
    public let lastUpdatedBy: String
    @DateFormatting public var createdAt: Date
    @DateFormatting public var updatedAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case subject
        case contentMarkdown
        case isDisabled = "disabled"
        case lastUpdatedBy
        case createdAt
        case updatedAt
    }
}

// Create the custom init and encode methods.
public enum EventViewUnion: Codable {
    case modEventTakedown(ModEventTakedown)
    case modEventReverseTakedown(ModEventReverseTakedown)
    case modEventComment(ModEventComment)
    case modEventReport(ModEventReport)
    case modEventLabel(ModEventLabel)
    case modEventAcknowledge(ModEventAcknowledge)
    case modEventEscalate(ModEventEscalate)
    case modEventMute(ModEventMute)
    case modEventEmail(ModEventEmail)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let value = try? container.decode(ModEventTakedown.self) {
            self = .modEventTakedown(value)
        } else if let value = try? container.decode(ModEventReverseTakedown.self) {
            self = .modEventReverseTakedown(value)
        } else if let value = try? container.decode(ModEventComment.self) {
            self = .modEventComment(value)
        } else if let value = try? container.decode(ModEventReport.self) {
            self = .modEventReport(value)
        } else if let value = try? container.decode(ModEventLabel.self) {
            self = .modEventLabel(value)
        } else if let value = try? container.decode(ModEventAcknowledge.self) {
            self = .modEventAcknowledge(value)
        } else if let value = try? container.decode(ModEventEscalate.self) {
            self = .modEventEscalate(value)
        } else if let value = try? container.decode(ModEventMute.self) {
            self = .modEventMute(value)
        } else if let value = try? container.decode(ModEventEmail.self) {
            self = .modEventEmail(value)
        } else {
            throw DecodingError.typeMismatch(EventViewUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unknown EventViewUnion type"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
            case .modEventTakedown(let modEvent):
                try container.encode(modEvent)
            case .modEventReverseTakedown(let modEvent):
                try container.encode(modEvent)
            case .modEventComment(let modEvent):
                try container.encode(modEvent)
            case .modEventReport(let modEvent):
                try container.encode(modEvent)
            case .modEventLabel(let modEvent):
                try container.encode(modEvent)
            case .modEventAcknowledge(let modEvent):
                try container.encode(modEvent)
            case .modEventEscalate(let modEvent):
                try container.encode(modEvent)
            case .modEventMute(let modEvent):
                try container.encode(modEvent)
            case .modEventEmail(let modEvent):
                try container.encode(modEvent)

        }
    }
}

// Create the custom init and encode methods.
public enum RepoReferencesUnion: Codable {
    case repoReference(RepoReference)
    case strongReference(StrongReference)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let value = try? container.decode(RepoReference.self) {
            self = .repoReference(value)
        } else if let value = try? container.decode(StrongReference.self) {
            self = .strongReference(value)
        } else {
            throw DecodingError.typeMismatch(ActorPreferenceUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unknown RepoReferencesUnion type"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
            case .repoReference(let repoReference):
                try container.encode(repoReference)
            case .strongReference(let repoReference):
                try container.encode(repoReference)
        }
    }
}

// Create the custom init and encode methods.
public enum EventViewDetailUnion: Codable {
    case modEventTakedown(ModEventTakedown)
    case modEventReverseTakedown(ModEventReverseTakedown)
    case modEventComment(ModEventComment)
    case modEventReport(ModEventReport)
    case modEventLabel(ModEventLabel)
    case modEventAcknowledge(ModEventAcknowledge)
    case modEventEscalate(ModEventEscalate)
    case modEventMute(ModEventMute)
    case modEventResolveAppeal(ModEventResolveAppeal)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let value = try? container.decode(ModEventTakedown.self) {
            self = .modEventTakedown(value)
        } else if let value = try? container.decode(ModEventReverseTakedown.self) {
            self = .modEventReverseTakedown(value)
        } else if let value = try? container.decode(ModEventComment.self) {
            self = .modEventComment(value)
        } else if let value = try? container.decode(ModEventReport.self) {
            self = .modEventReport(value)
        } else if let value = try? container.decode(ModEventLabel.self) {
            self = .modEventLabel(value)
        } else if let value = try? container.decode(ModEventAcknowledge.self) {
            self = .modEventAcknowledge(value)
        } else if let value = try? container.decode(ModEventEscalate.self) {
            self = .modEventEscalate(value)
        } else if let value = try? container.decode(ModEventMute.self) {
            self = .modEventMute(value)
        } else if let value = try? container.decode(ModEventResolveAppeal.self) {
            self = .modEventResolveAppeal(value)
        } else {
            throw DecodingError.typeMismatch(ActorPreferenceUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unknown EventViewDetailUnion type"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
            case .modEventTakedown(let modEventDetail):
                try container.encode(modEventDetail)
            case .modEventReverseTakedown(let modEventDetail):
                try container.encode(modEventDetail)
            case .modEventComment(let modEventDetail):
                try container.encode(modEventDetail)
            case .modEventReport(let modEventDetail):
                try container.encode(modEventDetail)
            case .modEventLabel(let modEventDetail):
                try container.encode(modEventDetail)
            case .modEventAcknowledge(let modEventDetail):
                try container.encode(modEventDetail)
            case .modEventEscalate(let modEventDetail):
                try container.encode(modEventDetail)
            case .modEventMute(let modEventDetail):
                try container.encode(modEventDetail)
            case .modEventResolveAppeal(let modEventDetail):
                try container.encode(modEventDetail)
        }
    }
}

// Create the custom init and encode methods.
public enum RepoViewUnion: Codable {
    case repoView(ReportView)
    case repoViewNotFound(RepoViewNotFound)
    case recordView(AdminRecordView)
    case recordViewNotFound(RecordViewNotFound)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let value = try? container.decode(ReportView.self) {
            self = .repoView(value)
        } else if let value = try? container.decode(RepoViewNotFound.self) {
            self = .repoViewNotFound(value)
        } else if let value = try? container.decode(AdminRecordView.self) {
            self = .recordView(value)
        } else if let value = try? container.decode(RecordViewNotFound.self) {
            self = .recordViewNotFound(value)
        } else {
            throw DecodingError.typeMismatch(ActorPreferenceUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unknown RepoViewUnion type"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
            case .repoView(let repoView):
                try container.encode(repoView)
            case .repoViewNotFound(let repoView):
                try container.encode(repoView)
            case .recordView(let repoView):
                try container.encode(repoView)
            case .recordViewNotFound(let repoView):
                try container.encode(repoView)
        }
    }
}

// Create the custom init and encode methods.
public enum MediaDetailUnion: Codable {
    case mediaImageDetails(MediaImageDetails)
    case mediaVideoDetails(MediaVideoDetails)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let value = try? container.decode(MediaImageDetails.self) {
            self = .mediaImageDetails(value)
        } else if let value = try? container.decode(MediaVideoDetails.self) {
            self = .mediaVideoDetails(value)
        } else {
            throw DecodingError.typeMismatch(ActorPreferenceUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unknown ActorPreference type"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
            case .mediaImageDetails(let mediaDetail):
                try container.encode(mediaDetail)
            case .mediaVideoDetails(let mediaDetail):
                try container.encode(mediaDetail)
        }
    }
}
