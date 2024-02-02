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
    public var creatorHandle: String? = nil
    public var subjectHandle: String? = nil

    public init(id: Int, event: EventViewUnion, subject: RepoReferencesUnion, subjectBlobCIDHashes: [String], createdBy: String, createdAt: Date, creatorHandle: String?, subjectHandle: String?) {
        self.id = id
        self.event = event
        self.subject = subject
        self.subjectBlobCIDHashes = subjectBlobCIDHashes
        self.createdBy = createdBy
        self._createdAt = DateFormatting(wrappedValue: createdAt)
        self.creatorHandle = creatorHandle
        self.subjectHandle = subjectHandle
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(Int.self, forKey: .id)
        self.event = try container.decode(EventViewUnion.self, forKey: .event)
        self.subject = try container.decode(RepoReferencesUnion.self, forKey: .subject)
        self.subjectBlobCIDHashes = try container.decode([String].self, forKey: .subjectBlobCIDHashes)
        self.createdBy = try container.decode(String.self, forKey: .createdBy)
        self.createdAt = try container.decode(DateFormatting.self, forKey: .createdAt).wrappedValue
        self.creatorHandle = try container.decodeIfPresent(String.self, forKey: .creatorHandle)
        self.subjectHandle = try container.decodeIfPresent(String.self, forKey: .subjectHandle)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.id, forKey: .id)
        try container.encode(self.event, forKey: .event)
        try container.encode(self.subject, forKey: .subject)
        try container.encode(self.subjectBlobCIDHashes, forKey: .subjectBlobCIDHashes)
        try container.encode(self.createdBy, forKey: .createdBy)
        try container.encode(self._createdAt, forKey: .createdAt)
        try container.encodeIfPresent(self.creatorHandle, forKey: .creatorHandle)
        try container.encodeIfPresent(self.subjectHandle, forKey: .subjectHandle)
    }

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

    public init(id: Int, event: EventViewDetailUnion, subject: RepoViewUnion, subjectBlobs: [BlobView], createdBy: String, createdAt: Date) {
        self.id = id
        self.event = event
        self.subject = subject
        self.subjectBlobs = subjectBlobs
        self.createdBy = createdBy
        self._createdAt = DateFormatting(wrappedValue: createdAt)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(Int.self, forKey: .id)
        self.event = try container.decode(EventViewDetailUnion.self, forKey: .event)
        self.subject = try container.decode(RepoViewUnion.self, forKey: .subject)
        self.subjectBlobs = try container.decode([BlobView].self, forKey: .subjectBlobs)
        self.createdBy = try container.decode(String.self, forKey: .createdBy)
        self.createdAt = try container.decode(DateFormatting.self, forKey: .createdAt).wrappedValue
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.id, forKey: .id)
        try container.encode(self.event, forKey: .event)
        try container.encode(self.subject, forKey: .subject)
        try container.encode(self.subjectBlobs, forKey: .subjectBlobs)
        try container.encode(self.createdBy, forKey: .createdBy)
        try container.encode(self._createdAt, forKey: .createdAt)
    }

    enum CodingKeys: CodingKey {
        case id
        case event
        case subject
        case subjectBlobs
        case createdBy
        case createdAt
    }
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

    public init(id: Int, reasonType: ModerationReasonType, subject: RepoReferencesUnion, reportedBy: String, createdAt: Date, resolvedByActionIDs: [Int]) {
        self.id = id
        self.reasonType = reasonType
        self.subject = subject
        self.reportedBy = reportedBy
        self._createdAt = DateFormatting(wrappedValue: createdAt)
        self.resolvedByActionIDs = resolvedByActionIDs
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(Int.self, forKey: .id)
        self.reasonType = try container.decode(ModerationReasonType.self, forKey: .reasonType)
        self.subject = try container.decode(RepoReferencesUnion.self, forKey: .subject)
        self.reportedBy = try container.decode(String.self, forKey: .reportedBy)
        self.createdAt = try container.decode(DateFormatting.self, forKey: .createdAt).wrappedValue
        self.resolvedByActionIDs = try container.decode([Int].self, forKey: .resolvedByActionIDs)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.id, forKey: .id)
        try container.encode(self.reasonType, forKey: .reasonType)
        try container.encodeIfPresent(self.comment, forKey: .comment)
        try container.encodeIfPresent(self.subjectRepoHandle, forKey: .subjectRepoHandle)
        try container.encode(self.subject, forKey: .subject)
        try container.encode(self.reportedBy, forKey: .reportedBy)
        try container.encode(self._createdAt, forKey: .createdAt)
        try container.encode(self.resolvedByActionIDs, forKey: .resolvedByActionIDs)
    }

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
        self.updatedAt = try container.decode(DateFormatting.self, forKey: .updatedAt).wrappedValue
        self.createdAt = try container.decode(DateFormatting.self, forKey: .createdAt).wrappedValue
        self.reviewState = try container.decode(SubjectReviewState.self, forKey: .reviewState)
        self.comment = try container.decodeIfPresent(String.self, forKey: .comment)
        self.muteUntil = try container.decodeIfPresent(DateFormattingOptional.self, forKey: .muteUntil)?.wrappedValue
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

    public init(id: Int, reasonType: ModerationReasonType, comment: String? = nil, subject: RepoViewUnion, subjectStatus: SubjectStatusView? = nil, reportedBy: String, createdAt: Date, resolvedByActions: [ModEventView]) {
        self.id = id
        self.reasonType = reasonType
        self.comment = comment
        self.subject = subject
        self.subjectStatus = subjectStatus
        self.reportedBy = reportedBy
        self._createdAt = DateFormatting(wrappedValue: createdAt)
        self.resolvedByActions = resolvedByActions
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(Int.self, forKey: .id)
        self.reasonType = try container.decode(ModerationReasonType.self, forKey: .reasonType)
        self.comment = try container.decodeIfPresent(String.self, forKey: .comment)
        self.subject = try container.decode(RepoViewUnion.self, forKey: .subject)
        self.subjectStatus = try container.decodeIfPresent(SubjectStatusView.self, forKey: .subjectStatus)
        self.reportedBy = try container.decode(String.self, forKey: .reportedBy)
        self.createdAt = try container.decode(DateFormatting.self, forKey: .createdAt).wrappedValue
        self.resolvedByActions = try container.decode([ModEventView].self, forKey: .resolvedByActions)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.id, forKey: .id)
        try container.encode(self.reasonType, forKey: .reasonType)
        try container.encodeIfPresent(self.comment, forKey: .comment)
        try container.encode(self.subject, forKey: .subject)
        try container.encodeIfPresent(self.subjectStatus, forKey: .subjectStatus)
        try container.encode(self.reportedBy, forKey: .reportedBy)
        try container.encode(self._createdAt, forKey: .createdAt)
        try container.encode(self.resolvedByActions, forKey: .resolvedByActions)
    }

    enum CodingKeys: CodingKey {
        case id
        case reasonType
        case comment
        case subject
        case subjectStatus
        case reportedBy
        case createdAt
        case resolvedByActions
    }
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

    public init(atDID: String, handle: String, email: String? = nil, relatedRecords: UnknownType, indexedAt: Date, moderation: AdminModeration, invitedBy: ServerInviteCode? = nil, areInvitesDisabled: Bool? = nil, inviteNote: String? = nil) {
        self.atDID = atDID
        self.handle = handle
        self.email = email
        self.relatedRecords = relatedRecords
        self._indexedAt = DateFormatting(wrappedValue: indexedAt)
        self.moderation = moderation
        self.invitedBy = invitedBy
        self.areInvitesDisabled = areInvitesDisabled
        self.inviteNote = inviteNote
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.atDID = try container.decode(String.self, forKey: .atDID)
        self.handle = try container.decode(String.self, forKey: .handle)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.relatedRecords = try container.decode(UnknownType.self, forKey: .relatedRecords)
        self.indexedAt = try container.decode(DateFormatting.self, forKey: .indexedAt).wrappedValue
        self.moderation = try container.decode(AdminModeration.self, forKey: .moderation)
        self.invitedBy = try container.decodeIfPresent(ServerInviteCode.self, forKey: .invitedBy)
        self.areInvitesDisabled = try container.decodeIfPresent(Bool.self, forKey: .areInvitesDisabled)
        self.inviteNote = try container.decodeIfPresent(String.self, forKey: .inviteNote)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.atDID, forKey: .atDID)
        try container.encode(self.handle, forKey: .handle)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encode(self.relatedRecords, forKey: .relatedRecords)
        try container.encode(self._indexedAt, forKey: .indexedAt)
        try container.encode(self.moderation, forKey: .moderation)
        try container.encodeIfPresent(self.invitedBy, forKey: .invitedBy)
        try container.encodeIfPresent(self.areInvitesDisabled, forKey: .areInvitesDisabled)
        try container.encodeIfPresent(self.inviteNote, forKey: .inviteNote)
    }

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
        self.indexedAt = try container.decode(DateFormatting.self, forKey: .indexedAt).wrappedValue
        self.moderation = try container.decode(AdminModeration.self, forKey: .moderation)
        self.labels = try container.decodeIfPresent([Label].self, forKey: .labels)
        self.invitedBy = try container.decodeIfPresent(ServerInviteCode.self, forKey: .invitedBy)
        self.invites = try container.decodeIfPresent([ServerInviteCode].self, forKey: .invites)
        self.areInvitesDisabled = try container.decodeIfPresent(Bool.self, forKey: .areInvitesDisabled)
        self.inviteNote = try container.decodeIfPresent(String.self, forKey: .inviteNote)
        self.emailConfirmedAt = try container.decodeIfPresent(DateFormattingOptional.self, forKey: .emailConfirmedAt)?.wrappedValue
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.atDID, forKey: .atDID)
        try container.encode(self.handle, forKey: .handle)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encode(self.relatedRecords, forKey: .relatedRecords)
        try container.encode(self._indexedAt, forKey: .indexedAt)
        try container.encode(self.moderation, forKey: .moderation)
        try container.encodeIfPresent(self.labels, forKey: .labels)
        try container.encodeIfPresent(self.invitedBy, forKey: .invitedBy)
        try container.encodeIfPresent(self.invites, forKey: .invites)
        try container.encodeIfPresent(self.areInvitesDisabled, forKey: .areInvitesDisabled)
        try container.encodeIfPresent(self.inviteNote, forKey: .inviteNote)
        try container.encode(self._emailConfirmedAt, forKey: .emailConfirmedAt)
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
        self.indexedAt = try container.decode(DateFormatting.self, forKey: .indexedAt).wrappedValue
        self.invitedBy = try container.decodeIfPresent(ServerInviteCode.self, forKey: .invitedBy)
        self.invites = try container.decodeIfPresent([ServerInviteCode].self, forKey: .invites)
        self.areInvitesDisabled = try container.decodeIfPresent(Bool.self, forKey: .areInvitesDisabled)
        self.emailConfirmedAt = try container.decodeIfPresent(DateFormattingOptional.self, forKey: .emailConfirmedAt)?.wrappedValue
        self.inviteNote = try container.decodeIfPresent(String.self, forKey: .inviteNote)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.atDID, forKey: .atDID)
        try container.encode(self.handle, forKey: .handle)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.relatedRecords, forKey: .relatedRecords)
        try container.encode(self._indexedAt, forKey: .indexedAt)
        try container.encodeIfPresent(self.invitedBy, forKey: .invitedBy)
        try container.encodeIfPresent(self.invites, forKey: .invites)
        try container.encodeIfPresent(self.areInvitesDisabled, forKey: .areInvitesDisabled)
        try container.encode(self._emailConfirmedAt, forKey: .emailConfirmedAt)
        try container.encodeIfPresent(self.inviteNote, forKey: .inviteNote)
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

    public init(atURI: String, cidHash: String, value: UnknownType, blobCIDHashes: [String], indexedAt: Date, moderation: AdminModeration, repo: AdminRepoView) {
        self.atURI = atURI
        self.cidHash = cidHash
        self.value = value
        self.blobCIDHashes = blobCIDHashes
        self._indexedAt = DateFormatting(wrappedValue: indexedAt)
        self.moderation = moderation
        self.repo = repo
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.atURI = try container.decode(String.self, forKey: .atURI)
        self.cidHash = try container.decode(String.self, forKey: .cidHash)
        self.value = try container.decode(UnknownType.self, forKey: .value)
        self.blobCIDHashes = try container.decode([String].self, forKey: .blobCIDHashes)
        self.indexedAt = try container.decode(DateFormatting.self, forKey: .indexedAt).wrappedValue
        self.moderation = try container.decode(AdminModeration.self, forKey: .moderation)
        self.repo = try container.decode(AdminRepoView.self, forKey: .repo)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.atURI, forKey: .atURI)
        try container.encode(self.cidHash, forKey: .cidHash)
        try container.encode(self.value, forKey: .value)
        try container.encode(self.blobCIDHashes, forKey: .blobCIDHashes)
        try container.encode(self._indexedAt, forKey: .indexedAt)
        try container.encode(self.moderation, forKey: .moderation)
        try container.encode(self.repo, forKey: .repo)
    }

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

    public init(atURI: String, cidHash: String, value: String, blobs: [BlobView], labels: [Label]? = nil, indexedAt: Date, moderation: AdminModerationDetail, repo: AdminRepoView) {
        self.atURI = atURI
        self.cidHash = cidHash
        self.value = value
        self.blobs = blobs
        self.labels = labels
        self._indexedAt = DateFormatting(wrappedValue: indexedAt)
        self.moderation = moderation
        self.repo = repo
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.atURI = try container.decode(String.self, forKey: .atURI)
        self.cidHash = try container.decode(String.self, forKey: .cidHash)
        self.value = try container.decode(String.self, forKey: .value)
        self.blobs = try container.decode([BlobView].self, forKey: .blobs)
        self.labels = try container.decodeIfPresent([Label].self, forKey: .labels)
        self.indexedAt = try container.decode(DateFormatting.self, forKey: .indexedAt).wrappedValue
        self.moderation = try container.decode(AdminModerationDetail.self, forKey: .moderation)
        self.repo = try container.decode(AdminRepoView.self, forKey: .repo)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.atURI, forKey: .atURI)
        try container.encode(self.cidHash, forKey: .cidHash)
        try container.encode(self.value, forKey: .value)
        try container.encode(self.blobs, forKey: .blobs)
        try container.encodeIfPresent(self.labels, forKey: .labels)
        try container.encode(self._indexedAt, forKey: .indexedAt)
        try container.encode(self.moderation, forKey: .moderation)
        try container.encode(self.repo, forKey: .repo)
    }

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

    public init(cidHash: String, mimeType: String, size: Int, createdAt: Date, details: MediaDetailUnion, moderation: AdminModeration) {
        self.cidHash = cidHash
        self.mimeType = mimeType
        self.size = size
        self._createdAt = DateFormatting(wrappedValue: createdAt)
        self.details = details
        self.moderation = moderation
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.cidHash = try container.decode(String.self, forKey: .cidHash)
        self.mimeType = try container.decode(String.self, forKey: .mimeType)
        self.size = try container.decode(Int.self, forKey: .size)
        self.createdAt = try container.decode(DateFormatting.self, forKey: .createdAt).wrappedValue
        self.details = try container.decode(MediaDetailUnion.self, forKey: .details)
        self.moderation = try container.decode(AdminModeration.self, forKey: .moderation)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.cidHash, forKey: .cidHash)
        try container.encode(self.mimeType, forKey: .mimeType)
        try container.encode(self.size, forKey: .size)
        try container.encode(self._createdAt, forKey: .createdAt)
        try container.encode(self.details, forKey: .details)
        try container.encode(self.moderation, forKey: .moderation)
    }

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

    public init(id: Int, name: String, subject: String? = nil, contentMarkdown: String, isDisabled: Bool, lastUpdatedBy: String, createdAt: Date, updatedAt: Date) {
        self.id = id
        self.name = name
        self.subject = subject
        self.contentMarkdown = contentMarkdown
        self.isDisabled = isDisabled
        self.lastUpdatedBy = lastUpdatedBy
        self._createdAt = DateFormatting(wrappedValue: createdAt)
        self._updatedAt = DateFormatting(wrappedValue: updatedAt)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.subject = try container.decodeIfPresent(String.self, forKey: .subject)
        self.contentMarkdown = try container.decode(String.self, forKey: .contentMarkdown)
        self.isDisabled = try container.decode(Bool.self, forKey: .isDisabled)
        self.lastUpdatedBy = try container.decode(String.self, forKey: .lastUpdatedBy)
        self.createdAt = try container.decode(DateFormatting.self, forKey: .createdAt).wrappedValue
        self.updatedAt = try container.decode(DateFormatting.self, forKey: .updatedAt).wrappedValue
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
        try container.encodeIfPresent(self.subject, forKey: .subject)
        try container.encode(self.contentMarkdown, forKey: .contentMarkdown)
        try container.encode(self.isDisabled, forKey: .isDisabled)
        try container.encode(self.lastUpdatedBy, forKey: .lastUpdatedBy)
        try container.encode(self._createdAt, forKey: .createdAt)
        try container.encode(self._updatedAt, forKey: .updatedAt)
    }

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
