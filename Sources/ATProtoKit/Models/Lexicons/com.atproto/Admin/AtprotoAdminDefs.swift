//
//  AtprotoAdminDefs.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-25.
//

import Foundation

/// The main data model definition for admin status attributes.
///
/// - SeeAlso: This is based on the [`com.atproto.admin.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/defs.json
public struct AdminStatusAttributes: Codable {
    /// Indicates whether the status attributes are being applied.
    public let isApplied: Bool
    /// The reference of the attributes.
    public let reference: String? = nil

    enum CodingKeys: String, CodingKey {
        case isApplied = "applied"
        case reference = "ref"
    }
}

/// A data model for a moderation event view definition.
///
/// - SeeAlso: This is based on the [`com.atproto.admin.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/defs.json
public struct AdminModEventView: Codable {
    /// The ID of the moderator's event view.
    public let id: Int
    /// The type of the moderator's event view.
    public let event: AdminEventViewUnion
    /// The subject reference of the moderator's event view.
    public let subject: RepoReferencesUnion
    /// An array of CID hashes related to blobs for the moderator's event view.
    public let subjectBlobCIDHashes: [String]
    /// The creator of the event view.
    public let createdBy: String
    /// The date and time the event view was created.
    @DateFormatting public var createdAt: Date
    /// The handle of the moderator. Optional.
    public var creatorHandle: String? = nil
    /// The subject handle of the event view. Optional.
    public var subjectHandle: String? = nil

    public init(id: Int, event: AdminEventViewUnion, subject: RepoReferencesUnion, subjectBlobCIDHashes: [String], createdBy: String, createdAt: Date, creatorHandle: String?, subjectHandle: String?) {
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
        self.event = try container.decode(AdminEventViewUnion.self, forKey: .event)
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

/// A data model for a detailed moderation event view definition.
///
/// - SeeAlso: This is based on the [`com.atproto.admin.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/defs.json
public struct AdminModEventViewDetail: Codable {
    /// The ID of the moderator's event view.
    public let id: Int
    /// The type of the moderator's event view.
    public let event: EventViewDetailUnion
    /// The subject reference of the moderator's event view.
    public let subject: RepoViewUnion
    /// An array of blobs for a moderator to look at.
    public let subjectBlobs: [AdminBlobView]
    /// The creator of the event view.
    public let createdBy: String
    /// The date and time the event view was created.
    @DateFormatting public var createdAt: Date

    public init(id: Int, event: EventViewDetailUnion, subject: RepoViewUnion, subjectBlobs: [AdminBlobView], createdBy: String, createdAt: Date) {
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
        self.subjectBlobs = try container.decode([AdminBlobView].self, forKey: .subjectBlobs)
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

/// A data model for a report view definition.
///
/// - SeeAlso: This is based on the [`com.atproto.admin.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/defs.json
public struct AdminReportView: Codable {
    /// The ID of the report.
    public let id: Int
    /// The reason for the report.
    public let reasonType: ModerationReasonType
    /// The additional comment provided for a report. Optional.
    public let comment: String? = nil
    /// The handle of the subject who's related to the report. Optional.
    public let subjectRepoHandle: String? = nil
    /// The subject reference of the report.
    public let subject: RepoReferencesUnion
    /// The user who created the report.
    public let reportedBy: String
    /// The date and time the report was created.
    @DateFormatting public var createdAt: Date
    /// An array of action IDs that relate to resolutions.
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

/// A data model for a subject's status view definition.
///
/// - SeeAlso: This is based on the [`com.atproto.admin.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/defs.json
public struct AdminSubjectStatusView: Codable {
    /// The ID of the status view.
    public let id: Int
    /// The subject reference of the status view.
    public let subject: RepoReferencesUnion
    /// An array of CID hashes related to blobs. Optional.
    public var subjectBlobCIDHashes: [String]? = nil
    /// The handle of the subject related to the status. Optional.
    public var subjectRepoHandle: String? = nil
    /// The date and time of the last update for the status view.
    ///
    /// - Note: According to the AT Protocol specifications: "Timestamp referencing when the last update was made to the moderation status of the subject."
    @DateFormatting public var updatedAt: Date
    /// The date and time of the day the first event occured.
    ///
    /// - Note: According to the AT Protocol specifications: "Timestamp referencing the first moderation status impacting event was emitted on the subject."
    @DateFormatting public var createdAt: Date
    /// The review status of the subject.
    public let reviewState: AdminSubjectReviewState
    /// Any additional comments written about the subject. Optional.
    public var comment: String? = nil
    /// The date and time the subject's time to be muted has been lifted. Optional.
    ///
    /// - Note: According to the AT Protocol specifications: "Sticky comment on the subject."
    @DateFormattingOptional public var muteUntil: Date? = nil
    /// The name of the reviewer that reviewed the subject. Optional.
    public var lastReviewedBy: String? = nil
    /// The date and time the last reviewer looked at the subject. Optional.
    @DateFormattingOptional public var lastReviewedAt: Date? = nil
    /// The date and time of the last report about the subject. Optional.
    @DateFormattingOptional public var lastReportedAt: Date? = nil
    /// The date and time of the last appeal. Optional.
    @DateFormattingOptional public var lastAppealedAt: Date? = nil
    /// Indicates whether the subject was taken down. Optional.
    public var isTakenDown: Bool? = nil
    /// Indicates whether an appeal has been made. Optional.
    public var wasAppealed: Bool? = nil
    /// The date and time the subject's suspension will be lifted. Optional.
    @DateFormattingOptional public var suspendUntil: Date? = nil
    /// An array of tags. Optional.
    public var tags: [String]? = nil

    public init(id: Int, subject: RepoReferencesUnion, subjectBlobCIDHashes: [String]?, subjectRepoHandle: String?, updatedAt: Date, createdAt: Date, reviewState: AdminSubjectReviewState, comment: String?, muteUntil: Date?, lastReviewedBy: String?, lastReviewedAt: Date?, lastReportedAt: Date?, lastAppealedAt: Date?, isTakenDown: Bool?, wasAppealed: Bool?, suspendUntil: Date?, tags: [String]?) {
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
        self.tags = tags
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(Int.self, forKey: .id)
        self.subject = try container.decode(RepoReferencesUnion.self, forKey: .subject)
        self.subjectBlobCIDHashes = try container.decodeIfPresent([String].self, forKey: .subjectBlobCIDHashes)
        self.subjectRepoHandle = try container.decodeIfPresent(String.self, forKey: .subjectRepoHandle)
        self.updatedAt = try container.decode(DateFormatting.self, forKey: .updatedAt).wrappedValue
        self.createdAt = try container.decode(DateFormatting.self, forKey: .createdAt).wrappedValue
        self.reviewState = try container.decode(AdminSubjectReviewState.self, forKey: .reviewState)
        self.comment = try container.decodeIfPresent(String.self, forKey: .comment)
        self.muteUntil = try container.decodeIfPresent(DateFormattingOptional.self, forKey: .muteUntil)?.wrappedValue
        self.lastReviewedBy = try container.decodeIfPresent(String.self, forKey: .lastReviewedBy)
        self.lastReviewedAt = try container.decodeIfPresent(DateFormattingOptional.self, forKey: .lastReviewedAt)?.wrappedValue
        self.lastReportedAt = try container.decodeIfPresent(DateFormattingOptional.self, forKey: .lastReportedAt)?.wrappedValue
        self.lastAppealedAt = try container.decodeIfPresent(DateFormattingOptional.self, forKey: .lastAppealedAt)?.wrappedValue
        self.isTakenDown = try container.decodeIfPresent(Bool.self, forKey: .isTakenDown)
        self.wasAppealed = try container.decodeIfPresent(Bool.self, forKey: .wasAppealed)
        self.suspendUntil = try container.decodeIfPresent(DateFormattingOptional.self, forKey: .suspendUntil)?.wrappedValue
        self.tags = try container.decode([String].self, forKey: .tags)
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
        try container.encode(self.tags, forKey: .tags)
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
        case tags
    }
}

/// A data model for a detailed report view definition.
///
/// - SeeAlso: This is based on the [`com.atproto.admin.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/defs.json
public struct AdminReportViewDetail: Codable {
    /// The ID of a report.
    public let id: Int
    /// The reason for the report.
    public let reasonType: ModerationReasonType
    /// Any additional comments about the report. Optional.
    public var comment: String? = nil
    /// The subject of the report.
    ///
    /// - Important: The item associated with this property is undocumented in the AT Protocol specifications. Our documentation here is based on:\
    ///   \* **For items with some inferable context from property names or references**: its best interpretation, though not with full certainty.\
    ///   \* **For items without enough context for even an educated guess**: a direct acknowledgment of their undocumented status.\
    ///   Clarifications from Bluesky are essential for definitive understanding and usage.
    public let subject: RepoViewUnion
    /// The status for the subject of the report. Optional.
    ///
    /// - Important: The item associated with this property is undocumented in the AT Protocol specifications. Our documentation here is based on:\
    ///   \* **For items with some inferable context from property names or references**: its best interpretation, though not with full certainty.\
    ///   \* **For items without enough context for even an educated guess**: a direct acknowledgment of their undocumented status.\
    ///   Clarifications from Bluesky are essential for definitive understanding and usage.
    public var subjectStatus: AdminSubjectStatusView? = nil
    /// The user who created the report.
    public let reportedBy: String
    /// The date and time the report was created.
    @DateFormatting public var createdAt: Date
    /// An array of resolved actions made in relation to the report.
    public let resolvedByActions: [AdminModEventView]

    public init(id: Int, reasonType: ModerationReasonType, comment: String? = nil, subject: RepoViewUnion, subjectStatus: AdminSubjectStatusView? = nil, reportedBy: String, createdAt: Date, resolvedByActions: [AdminModEventView]) {
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
        self.subjectStatus = try container.decodeIfPresent(AdminSubjectStatusView.self, forKey: .subjectStatus)
        self.reportedBy = try container.decode(String.self, forKey: .reportedBy)
        self.createdAt = try container.decode(DateFormatting.self, forKey: .createdAt).wrappedValue
        self.resolvedByActions = try container.decode([AdminModEventView].self, forKey: .resolvedByActions)
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

/// A data model for a definition of a repository view.
///
/// - SeeAlso: This is based on the [`com.atproto.admin.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/defs.json
public struct AdminRepoView: Codable {
    /// The decentralized identifier (DID) of the user.
    public let actorDID: String
    /// The handle of the user.
    public let handle: String
    /// The email of the user. Optional.
    public var email: String? = nil
    /// The related records of the user.
    ///
    /// - Important: The item associated with this property is undocumented in the AT Protocol specifications. Our documentation here is based on:\
    ///   \* **For items with some inferable context from property names or references**: its best interpretation, though not with full certainty.\
    ///   \* **For items without enough context for even an educated guess**: a direct acknowledgment of their undocumented status.\
    ///   Clarifications from Bluesky are essential for definitive understanding and usage.
    public let relatedRecords: UnknownType
    /// The date and time the user was indexed.
    @DateFormatting public var indexedAt: Date
    /// The moderation status of the user.
    public let moderation: AdminModeration
    /// The invite code used by the user to sign up. Optional.
    public var invitedBy: ServerInviteCode? = nil
    /// Indicates whether the invite codes held by the user are diabled. Optional.
    public var areInvitesDisabled: Bool? = nil
    /// The note of the invite. Optional.
    public var inviteNote: String? = nil

    public init(actorDID: String, handle: String, email: String? = nil, relatedRecords: UnknownType, indexedAt: Date, moderation: AdminModeration, invitedBy: ServerInviteCode? = nil, areInvitesDisabled: Bool? = nil, inviteNote: String? = nil) {
        self.actorDID = actorDID
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

        self.actorDID = try container.decode(String.self, forKey: .actorDID)
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

        try container.encode(self.actorDID, forKey: .actorDID)
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
        case actorDID = "did"
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

/// A data model for a definition of a detailed repository view.
///
/// - SeeAlso: This is based on the [`com.atproto.admin.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/defs.json
public struct AdminRepoViewDetail: Codable {
    /// The decentralized identifier (DID) of the user.
    public let actorDID: String
    /// The handle of the user.
    public let handle: String
    /// The email of the user. Optional.
    public var email: String? = nil
    /// The user's related records.
    ///
    /// - Important: The item associated with this property is undocumented in the AT Protocol specifications. Our documentation here is based on:\
    ///   \* **For items with some inferable context from property names or references**: its best interpretation, though not with full certainty.\
    ///   \* **For items without enough context for even an educated guess**: a direct acknowledgment of their undocumented status.\
    ///   Clarifications from Bluesky are essential for definitive understanding and usage.
    public let relatedRecords: UnknownType
    /// The date and time the user was last indexed.
    @DateFormatting public var indexedAt: Date
    /// The detailed moderation status of the user.
    public let moderation: AdminModerationDetail
    /// An array of labels associated with the user. Optional.
    public var labels: [Label]? = nil
    /// The invite code used by the user to sign up. Optional.
    public var invitedBy: ServerInviteCode? = nil
    /// An array of invite codes held by the user. Optional.
    public var invites: [ServerInviteCode]? = nil
    /// Indicates whether the invite codes held by the user are diabled. Optional.
    public var areInvitesDisabled: Bool? = nil
    /// The note of the invite. Optional.
    public var inviteNote: String? = nil
    /// The date and time the email of the user was confirmed. Optional.
    @DateFormattingOptional public var emailConfirmedAt: Date? = nil

    public init(actorDID: String, handle: String, email: String?, relatedRecords: UnknownType, indexedAt: Date, moderation: AdminModerationDetail, labels: [Label]?, invitedBy: ServerInviteCode?, invites: [ServerInviteCode]?, areInvitesDisabled: Bool?, inviteNote: String?, emailConfirmedAt: Date? = nil) {
        self.actorDID = actorDID
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

        self.actorDID = try container.decode(String.self, forKey: .actorDID)
        self.handle = try container.decode(String.self, forKey: .handle)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.relatedRecords = try container.decode(UnknownType.self, forKey: .relatedRecords)
        self.indexedAt = try container.decode(DateFormatting.self, forKey: .indexedAt).wrappedValue
        self.moderation = try container.decode(AdminModerationDetail.self, forKey: .moderation)
        self.labels = try container.decodeIfPresent([Label].self, forKey: .labels)
        self.invitedBy = try container.decodeIfPresent(ServerInviteCode.self, forKey: .invitedBy)
        self.invites = try container.decodeIfPresent([ServerInviteCode].self, forKey: .invites)
        self.areInvitesDisabled = try container.decodeIfPresent(Bool.self, forKey: .areInvitesDisabled)
        self.inviteNote = try container.decodeIfPresent(String.self, forKey: .inviteNote)
        self.emailConfirmedAt = try container.decodeIfPresent(DateFormattingOptional.self, forKey: .emailConfirmedAt)?.wrappedValue
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.actorDID, forKey: .actorDID)
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
        case actorDID = "did"
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

/// A data model for a definition of an account view.
///
/// - SeeAlso: This is based on the [`com.atproto.admin.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/defs.json
public struct AdminAccountView: Codable {
    /// The decentralized identifier (DID) of the user.
    public let actorDID: String
    /// The handle of the user.
    public let handle: String
    /// The email of the user. Optional.
    public var email: String? = nil
    /// The user's related records. Optional.
    ///
    /// - Important: The item associated with this property is undocumented in the AT Protocol specifications. Our documentation here is based on:\
    ///   \* **For items with some inferable context from property names or references**: its best interpretation, though not with full certainty.\
    ///   \* **For items without enough context for even an educated guess**: a direct acknowledgment of their undocumented status.\
    ///   Clarifications from Bluesky are essential for definitive understanding and usage.
    public var relatedRecords: [UnknownType]? = nil
    /// The date and time the user was last indexed.
    @DateFormatting public var indexedAt: Date
    /// The invite code used by the user to sign up. Optional.
    public var invitedBy: ServerInviteCode? = nil
    /// An array of invite codes held by the user. Optional.
    public var invites: [ServerInviteCode]? = nil
    /// Indicates whether the invite codes held by the user are diabled. Optional.
    public var areInvitesDisabled: Bool? = nil
    /// The date and time the email of the user was confirmed. Optional.
    @DateFormattingOptional public var emailConfirmedAt: Date? = nil
    /// Any notes related to inviting the user. Optional.
    public var inviteNote: String? = nil

    public init(actorDID: String, handle: String, email: String?, relatedRecords: [UnknownType]?, indexedAt: Date, invitedBy: ServerInviteCode?, invites: [ServerInviteCode]?, areInvitesDisabled: Bool?, emailConfirmedAt: Date? = nil, inviteNote: String?) {
        self.actorDID = actorDID
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

        self.actorDID = try container.decode(String.self, forKey: .actorDID)
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

        try container.encode(self.actorDID, forKey: .actorDID)
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
        case actorDID = "did"
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

/// A data model for a definition of a respository view that may not have been found.
///
/// - SeeAlso: This is based on the [`com.atproto.admin.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/defs.json
public struct AdminRepoViewNotFound: Codable {
    /// The decentralized identifier (DID) of the repository.
    public let atDID: String

    enum CodingKeys: String, CodingKey {
        case atDID = "did"
    }
}

/// A data model for a definition of a repository reference.
///
/// - SeeAlso: This is based on the [`com.atproto.admin.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/defs.json
public struct AdminRepoReference: Codable {
    /// The decentralized identifier (DID) of the repository.
    public let atDID: String

    enum CodingKeys: String, CodingKey {
        case atDID = "did"
    }
}

/// A data model for a blob reference definition.
///
/// - SeeAlso: This is based on the [`com.atproto.admin.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/defs.json
public struct AdminRepoBlobReference: Codable {
    /// The decentralized identifier (DID) of the blob reference.
    public let atDID: String
    /// The CID hash of the blob reference.
    public let cidHash: String
    /// The URI of the record that contains the blob reference.
    public let recordURI: String?

    enum CodingKeys: String, CodingKey {
        case atDID = "did"
        case cidHash = "cid"
        case recordURI = "recordUri"
    }
}

/// A data model for the definition of a record view.
///
/// - SeeAlso: This is based on the [`com.atproto.admin.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/defs.json
public struct AdminRecordView: Codable {
    /// The URI of the record.
    public let recordURI: String
    /// The CID hash of the record.
    public let cidHash: String
    /// The value of the record.
    ///
    /// - Important: The item associated with this property is undocumented in the AT Protocol specifications. Our documentation here is based on:\
    ///   \* **For items with some inferable context from property names or references**: its best interpretation, though not with full certainty.\
    ///   \* **For items without enough context for even an educated guess**: a direct acknowledgment of their undocumented status.\
    ///   Clarifications from Bluesky are essential for definitive understanding and usage.
    public let value: UnknownType
    /// An array of CID hashes for blobs.
    public let blobCIDHashes: [String]
    /// The date and time the record is indexed.
    @DateFormatting public var indexedAt: Date
    /// The status of the subject.
    ///
    /// - Important: The item associated with this property is undocumented in the AT Protocol specifications. Our documentation here is based on:\
    ///   \* **For items with some inferable context from property names or references**: its best interpretation, though not with full certainty.\
    ///   \* **For items without enough context for even an educated guess**: a direct acknowledgment of their undocumented status.\
    ///   Clarifications from Bluesky are essential for definitive understanding and usage.
    public let moderation: AdminModeration
    /// The repository view of the record.
    ///
    /// - Important: The item associated with this property is undocumented in the AT Protocol specifications. Our documentation here is based on:\
    ///   \* **For items with some inferable context from property names or references**: its best interpretation, though not with full certainty.\
    ///   \* **For items without enough context for even an educated guess**: a direct acknowledgment of their undocumented status.\
    ///   Clarifications from Bluesky are essential for definitive understanding and usage.
    public let repo: AdminRepoView

    public init(recordURI: String, cidHash: String, value: UnknownType, blobCIDHashes: [String], indexedAt: Date, moderation: AdminModeration, repo: AdminRepoView) {
        self.recordURI = recordURI
        self.cidHash = cidHash
        self.value = value
        self.blobCIDHashes = blobCIDHashes
        self._indexedAt = DateFormatting(wrappedValue: indexedAt)
        self.moderation = moderation
        self.repo = repo
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.recordURI = try container.decode(String.self, forKey: .recordURI)
        self.cidHash = try container.decode(String.self, forKey: .cidHash)
        self.value = try container.decode(UnknownType.self, forKey: .value)
        self.blobCIDHashes = try container.decode([String].self, forKey: .blobCIDHashes)
        self.indexedAt = try container.decode(DateFormatting.self, forKey: .indexedAt).wrappedValue
        self.moderation = try container.decode(AdminModeration.self, forKey: .moderation)
        self.repo = try container.decode(AdminRepoView.self, forKey: .repo)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.recordURI, forKey: .recordURI)
        try container.encode(self.cidHash, forKey: .cidHash)
        try container.encode(self.value, forKey: .value)
        try container.encode(self.blobCIDHashes, forKey: .blobCIDHashes)
        try container.encode(self._indexedAt, forKey: .indexedAt)
        try container.encode(self.moderation, forKey: .moderation)
        try container.encode(self.repo, forKey: .repo)
    }

    enum CodingKeys: String, CodingKey {
        case recordURI = "uri"
        case cidHash = "cid"
        case value
        case blobCIDHashes = "blobCids"
        case indexedAt
        case moderation
        case repo
    }
}

/// A data model for a definition a detailed view of a record.
///
/// - SeeAlso: This is based on the [`com.atproto.admin.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/defs.json
public struct AdminRecordViewDetail: Codable {
    /// The URI of a record.
    public let recordURI: String
    /// The CID hash of the record.
    public let cidHash: String
    /// The value of the record.
    ///
    /// - Important: The item associated with this property is undocumented in the AT Protocol specifications. Our documentation here is based on:\
    ///   \* **For items with some inferable context from property names or references**: its best interpretation, though not with full certainty.\
    ///   \* **For items without enough context for even an educated guess**: a direct acknowledgment of their undocumented status.\
    ///   Clarifications from Bluesky are essential for definitive understanding and usage.
    public let value: String
    /// An array of CID hashes for blobs.
    public let blobs: [AdminBlobView]
    /// An array of labels attached to the record. Optional.
    public var labels: [Label]? = nil
    /// The date and time the record is indexed.
    @DateFormatting public var indexedAt: Date
    /// The repository view of the record.
    ///
    /// - Important: The item associated with this property is undocumented in the AT Protocol specifications. Our documentation here is based on:\
    ///   \* **For items with some inferable context from property names or references**: its best interpretation, though not with full certainty.\
    ///   \* **For items without enough context for even an educated guess**: a direct acknowledgment of their undocumented status.\
    ///   Clarifications from Bluesky are essential for definitive understanding and usage.
    public let moderation: AdminModerationDetail
    /// The repository view of the record.
    ///
    /// - Important: The item associated with this property is undocumented in the AT Protocol specifications. Our documentation here is based on:\
    ///   \* **For items with some inferable context from property names or references**: its best interpretation, though not with full certainty.\
    ///   \* **For items without enough context for even an educated guess**: a direct acknowledgment of their undocumented status.\
    ///   Clarifications from Bluesky are essential for definitive understanding and usage.
    public let repo: AdminRepoView

    public init(recordURI: String, cidHash: String, value: String, blobs: [AdminBlobView], labels: [Label]? = nil, indexedAt: Date, moderation: AdminModerationDetail, repo: AdminRepoView) {
        self.recordURI = recordURI
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

        self.recordURI = try container.decode(String.self, forKey: .recordURI)
        self.cidHash = try container.decode(String.self, forKey: .cidHash)
        self.value = try container.decode(String.self, forKey: .value)
        self.blobs = try container.decode([AdminBlobView].self, forKey: .blobs)
        self.labels = try container.decodeIfPresent([Label].self, forKey: .labels)
        self.indexedAt = try container.decode(DateFormatting.self, forKey: .indexedAt).wrappedValue
        self.moderation = try container.decode(AdminModerationDetail.self, forKey: .moderation)
        self.repo = try container.decode(AdminRepoView.self, forKey: .repo)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.recordURI, forKey: .recordURI)
        try container.encode(self.cidHash, forKey: .cidHash)
        try container.encode(self.value, forKey: .value)
        try container.encode(self.blobs, forKey: .blobs)
        try container.encodeIfPresent(self.labels, forKey: .labels)
        try container.encode(self._indexedAt, forKey: .indexedAt)
        try container.encode(self.moderation, forKey: .moderation)
        try container.encode(self.repo, forKey: .repo)
    }

    enum CodingKeys: String, CodingKey {
        case recordURI = "uri"
        case cidHash = "cid"
        case value
        case blobs
        case labels
        case indexedAt
        case moderation
        case repo
    }
}

/// A data model for a definition of a record that may not have been found.
///
/// - SeeAlso: This is based on the [`com.atproto.admin.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/defs.json
public struct AdminRecordViewNotFound: Codable {
    /// The URI of the record.
    public let recordURI: String

    enum CodingKeys: String, CodingKey {
        case recordURI = "uri"
    }
}

/// A data model of a definition for moderation.
///
/// - Important: The item associated with this struct is undocumented in the AT Protocol specifications. Our documentation here is based on:\
///   \* **For items with some inferable context from property names or references**: its best interpretation, though not with full certainty.\
///   \* **For items without enough context for even an educated guess**: a direct acknowledgment of their undocumented status.\
///   Clarifications from Bluesky are essential for definitive understanding and usage.
///
/// - SeeAlso: This is based on the [`com.atproto.admin.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/defs.json
public struct AdminModeration: Codable {
    /// The status of the subject. Optional.
    ///
    /// - Important: The item associated with this property is undocumented in the AT Protocol specifications. Our documentation here is based on:\
    ///   \* **For items with some inferable context from property names or references**: its best interpretation, though not with full certainty.\
    ///   \* **For items without enough context for even an educated guess**: a direct acknowledgment of their undocumented status.\
    ///   Clarifications from Bluesky are essential for definitive understanding and usage.
    public var subjectStatus: AdminSubjectStatusView? = nil
}

/// A data model of a definition for a detailed moderation.
///
/// - Important: The item associated with this struct is undocumented in the AT Protocol specifications. Our documentation here is based on:\
///   \* **For items with some inferable context from property names or references**: its best interpretation, though not with full certainty.\
///   \* **For items without enough context for even an educated guess**: a direct acknowledgment of their undocumented status.\
///   Clarifications from Bluesky are essential for definitive understanding and usage.
///
/// - SeeAlso: This is based on the [`com.atproto.admin.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/defs.json
public struct AdminModerationDetail: Codable {
    /// The status of the subject. Optional.
    ///
    /// - Important: The item associated with this property is undocumented in the AT Protocol specifications. Our documentation here is based on:\
    ///   \* **For items with some inferable context from property names or references**: its best interpretation, though not with full certainty.\
    ///   \* **For items without enough context for even an educated guess**: a direct acknowledgment of their undocumented status.\
    ///   Clarifications from Bluesky are essential for definitive understanding and usage.
    public var subjectStatus: AdminSubjectStatusView? = nil
}

/// The data model for a definition of a blow view.
///
/// - SeeAlso: This is based on the [`com.atproto.admin.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/defs.json
public struct AdminBlobView: Codable {
    /// The CID hash of the blob.
    public let cidHash: String
    /// The MIME type of the blob.
    public let mimeType: String
    /// The size of the blob. Written in bytes.
    public let size: Int
    /// The date and time the blob was created.
    @DateFormatting public var createdAt: Date
    /// The type of media in the blob.
    public let details: MediaDetailUnion
    /// The status of the subject.
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

/// A data model for a definition of details for an image.
///
/// - SeeAlso: This is based on the [`com.atproto.admin.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/defs.json
public struct AdminMediaImageDetails: Codable {
    /// The width of the image.
    public let width: Int
    /// The height of the image.
    public let height: Int
}

/// A data model for a definition of details for a video.
///
/// - SeeAlso: This is based on the [`com.atproto.admin.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/defs.json
public struct AdminMediaVideoDetails: Codable {
    /// The width of the video.
    public let width: Int
    /// The height of the video.
    public let height: Int
    /// The duration of the video.
    public let length: Int
}

/// A data model for the subject review state definition.
///
/// - SeeAlso: This is based on the [`com.atproto.admin.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/defs.json
public enum AdminSubjectReviewState: String, Codable {
    /// Moderator review status of a subject: Open. Indicates that the subject needs to be reviewed by a moderator.
    ///
    /// - Note: The above documentation was taken directly from the AT Protocol specifications.
    case reviewOpen

    /// Moderator review status of a subject: Escalated. Indicates that the subject was escalated for review by a moderator.
    ///
    /// - Note: The above documentation was taken directly from the AT Protocol specifications.
    case reviewEscalated

    /// Moderator review status of a subject: Closed. Indicates that the subject was already reviewed and resolved by a moderator.
    ///
    /// - Note: The above documentation was taken directly from the AT Protocol specifications.
    case reviewClosed
}

/// A data model for an event takedown definition.
///
/// - SeeAlso: This is based on the [`com.atproto.admin.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/defs.json
public struct AdminModEventTakedown: Codable {
    /// Any additional comments for the takedown event. Optional.
    ///
    /// - Note: According to the AT Protocol specifications: "Take down a subject permanently or temporarily."
    public let comment: String?
    /// The amount of time (in hours) for the user to be considered takendown. Optional.
    ///
    /// - Note: According to the AT Protocol specifications: "Indicates how long the takedown should be in effect before automatically expiring."
    public let durationInHours: Int?
}

/// A data model for a reverse takedown event definition.
///
/// - Note: According to the AT Protocol specifications: "Revert take down action on a subject."
/// - SeeAlso: This is based on the [`com.atproto.admin.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/defs.json
public struct AdminModEventReverseTakedown: Codable {
    /// Any comments for the reverse takedown event. Optional.
    ///
    /// - Note: According to the AT Protocol specifications: "Describe reasoning behind the reversal."
    public let comment: String?
}

/// A data model for a definition of an resolved appeal event.
///
/// - Note: According to the AT Protocol specifications: "Resolve appeal on a subject."
///
/// - SeeAlso: This is based on the [`com.atproto.admin.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/defs.json
public struct AdminModEventResolveAppeal: Codable {
    /// Any comments for the moderator's appeal resolution event. Optional.
    ///
    /// - Note: According to the AT Protocol specifications: "Describe resolution."
    public let comment: String?
}

/// A data model for a definition of a comment event.
///
/// - Note: According to the AT Protocol specifications: "Add a comment to a subject."
///
/// - SeeAlso: This is based on the [`com.atproto.admin.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/defs.json
public struct AdminModEventComment: Codable {
    /// Any comment for the moderator's comment event.
    public let comment: String
    /// Indicates whether the moderator event is sticky. Optional.
    ///
    /// - Note: According to the AT Protocol specifications: "Make the comment persistent on the subject."
    public let isSticky: Bool?

    enum CodingKeys: String, CodingKey {
        case comment
        case isSticky = "sticky"
    }
}

/// A data model for a report event definition.
///
/// - Note: According to the AT Protocol specifications: "Report a subject."
///
/// - SeeAlso: This is based on the [`com.atproto.admin.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/defs.json
public struct AdminModEventReport: Codable {
    /// Any comments for the moderator's report event. Optional.
    public var comment: String? = nil
    /// The type of report.
    public let reportType: ModerationReasonType
}

/// A data model for a label event definition.
///
/// - Note: According to the AT Protocol specifications: "Apply/Negate labels on a subject"
///
/// - SeeAlso: This is based on the [`com.atproto.admin.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/defs.json
public struct AdminModEventLabel: Codable {
    /// Any comments for the moderator's label event. Optional.
    public let comment: String?
    /// An array of labels that apply to a user.
    public let createLabelValues: [String]
    /// An array of labels that's applied to a user for the purpose of negating.
    public let negateLabelValues: [String]

    enum CodingKeys: String, CodingKey {
        case comment
        case createLabelValues = "createLabelVals"
        case negateLabelValues = "negateLabelVals"
    }
}

/// A data model for a definition of an acknowledgement event.
///
/// - SeeAlso: This is based on the [`com.atproto.admin.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/defs.json
public struct AdminModEventAcknowledge: Codable {
    /// Any comments for the moderator's acknowledge event. Optional.
    public var comment: String? = nil
}

/// A data model for a definition of an escalation event.
///
/// - SeeAlso: This is based on the [`com.atproto.admin.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/defs.json
public struct AdminModEventEscalate: Codable {
    /// Any additional comments for escalating a report. Optional.
    public var comment: String? = nil
}

/// A data model for a definition of a mute event.
///
/// - Note: According to the AT Protocol specifications: "Mute incoming reports on a subject."
///
/// - SeeAlso: This is based on the [`com.atproto.admin.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/defs.json
public struct AdminModEventMute: Codable {
    /// Any additional comments for the mute event. Optional.
    public var comment: String? = nil
    /// The amount of time (in hours) that the moderator has put in for muting a user.
    ///
    /// - Note: According to the AT Protocol specifications: "Indicates how long the subject should remain muted."
    public let durationInHours: Int
}

/// A data model for an unmute event definition.
///
/// - Note: According to the AT Protocol specifications: "Unmute action on a subject."
///
/// - SeeAlso: This is based on the [`com.atproto.admin.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/defs.json
public struct AdminModEventUnmute: Codable {
    /// Any comments for the moderator's unmute event. Optional.
    ///
    /// - Note: According to the AT Protocol specifications: "Describe reasoning behind the reversal."
    public var comment: String? = nil
}

/// A data model for a definition of an email event.
///
/// - Note: According to the AT Protocol specifications: "Keep a log of outgoing email to a user."
///
/// - SeeAlso: This is based on the [`com.atproto.admin.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/defs.json
public struct AdminModEventEmail: Codable {
    /// The subject line of the email.
    ///
    /// - Note: According to the AT Protocol specifications: "The subject line of the email sent to the user."
    public let subjectLine: String
    /// Any additional comments about the email. Optional.
    ///
    /// - Note: According to the AT Protocol specifications: "Additional comment about the outgoing comm."
    public var comment: String? = nil
}

/// A data model for a tag event definition.
///
/// - Note: According to the AT Protocol specifications: "Add/Remove a tag on a subject."
///
/// - SeeAlso: This is based on the [`com.atproto.admin.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/defs.json
public struct AdminModEventTag: Codable {
    /// An array of tags to be added to the user.
    ///
    /// If a tag in the array already exists on the user, then the tag will be ignored.
    ///
    /// - Note: According to the AT Protocol specifications: "Tags to be added to the subject. If already exists, won't be duplicated."
    public let add: [String]
    /// An array of tags to be removed from the user.
    ///
    /// If a tag in the array doesn't exist on the user, then the tag will be ignored.
    ///
    /// - Note: According to the AT Protocol specifications: "Tags to be removed to the subject. Ignores a tag If it doesn't exist, won't be duplicated."
    public let remove: [String]
    /// Any additional comments about the moderator's tag event.
    ///
    /// - Note: According to the AT Protocol specifications: "Additional comment about added/removed tags."
    public let comment: String?
}

/// A data model definition for a communication template.
///
/// - SeeAlso: This is based on the [`com.atproto.admin.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/defs.json
public struct AdminCommunicationTemplateView: Codable {
    /// The ID of the communication template.
    public let id: Int
    /// The name of the communication template.
    ///
    /// - Note: According to the AT Protocol specifications: "Name of the template."
    public let name: String
    /// The subject of the message. Optional.
    ///
    /// - Note: According to the AT Protocol specifications: "Subject of the message, used in emails."
    public var subject: String? = nil
    /// The content of the communication template. Optional.
    ///
    /// This may contain Markdown placeholders and variable placeholders.
    ///
    /// - Note: According to the AT Protocol specifications: "Content of the template, can contain markdown and variable placeholders."
    public let contentMarkdown: String
    /// Indicates whether the communication template has been disabled.
    public let isDisabled: Bool
    /// The decentralized identifier (DID) of the user who last updated the communication template.
    ///
    /// - Note: According to the AT Protocol specifications: "DID of the user who last updated the template."
    public let lastUpdatedBy: String
    /// The date and time the communication template was created.
    @DateFormatting public var createdAt: Date
    /// The date and time the communication template was updated.
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

// MARK: - Union types
/// A reference containing the list of event views..
public enum AdminEventViewUnion: Codable {
    /// A takedown event.
    case modEventTakedown(AdminModEventTakedown)
    /// A reverse takedown event.
    case modEventReverseTakedown(AdminModEventReverseTakedown)
    /// A comment event.
    case modEventComment(AdminModEventComment)
    /// A report event.
    case modEventReport(AdminModEventReport)
    /// A label event.
    case modEventLabel(AdminModEventLabel)
    /// An acknowledgement event.
    case modEventAcknowledge(AdminModEventAcknowledge)
    /// An escalation event.
    case modEventEscalate(AdminModEventEscalate)
    /// A mute event.
    case modEventMute(AdminModEventMute)
    /// An email event.
    case modEventEmail(AdminModEventEmail)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let value = try? container.decode(AdminModEventTakedown.self) {
            self = .modEventTakedown(value)
        } else if let value = try? container.decode(AdminModEventReverseTakedown.self) {
            self = .modEventReverseTakedown(value)
        } else if let value = try? container.decode(AdminModEventComment.self) {
            self = .modEventComment(value)
        } else if let value = try? container.decode(AdminModEventReport.self) {
            self = .modEventReport(value)
        } else if let value = try? container.decode(AdminModEventLabel.self) {
            self = .modEventLabel(value)
        } else if let value = try? container.decode(AdminModEventAcknowledge.self) {
            self = .modEventAcknowledge(value)
        } else if let value = try? container.decode(AdminModEventEscalate.self) {
            self = .modEventEscalate(value)
        } else if let value = try? container.decode(AdminModEventMute.self) {
            self = .modEventMute(value)
        } else if let value = try? container.decode(AdminModEventEmail.self) {
            self = .modEventEmail(value)
        } else {
            throw DecodingError.typeMismatch(AdminEventViewUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unknown EventViewUnion type"))
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
/// A reference containing the list of repository references..
public enum RepoReferencesUnion: Codable {
    /// A repository reference.
    case repoReference(AdminRepoReference)
    /// A strong reference.
    case strongReference(StrongReference)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let value = try? container.decode(AdminRepoReference.self) {
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
/// A reference containing the list of moderator events.
public enum EventViewDetailUnion: Codable {
    /// A takedown event.
    case modEventTakedown(AdminModEventTakedown)
    /// A reverse takedown event.
    case modEventReverseTakedown(AdminModEventReverseTakedown)
    /// A comment event.
    case modEventComment(AdminModEventComment)
    /// A report event.
    case modEventReport(AdminModEventReport)
    /// A label event.
    case modEventLabel(AdminModEventLabel)
    /// An acknowledgment event.
    case modEventAcknowledge(AdminModEventAcknowledge)
    /// An escalation event.
    case modEventEscalate(AdminModEventEscalate)
    /// A mute event.
    case modEventMute(AdminModEventMute)
    /// A resolve appeal event.
    case modEventResolveAppeal(AdminModEventResolveAppeal)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let value = try? container.decode(AdminModEventTakedown.self) {
            self = .modEventTakedown(value)
        } else if let value = try? container.decode(AdminModEventReverseTakedown.self) {
            self = .modEventReverseTakedown(value)
        } else if let value = try? container.decode(AdminModEventComment.self) {
            self = .modEventComment(value)
        } else if let value = try? container.decode(AdminModEventReport.self) {
            self = .modEventReport(value)
        } else if let value = try? container.decode(AdminModEventLabel.self) {
            self = .modEventLabel(value)
        } else if let value = try? container.decode(AdminModEventAcknowledge.self) {
            self = .modEventAcknowledge(value)
        } else if let value = try? container.decode(AdminModEventEscalate.self) {
            self = .modEventEscalate(value)
        } else if let value = try? container.decode(AdminModEventMute.self) {
            self = .modEventMute(value)
        } else if let value = try? container.decode(AdminModEventResolveAppeal.self) {
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
/// A reference containing the list of the types of repository or record views.
public enum RepoViewUnion: Codable {
    /// A normal repository view.
    case repoView(AdminReportView)
    /// A repository view that may not have been found.
    case repoViewNotFound(AdminRepoViewNotFound)
    /// A normal record.
    case recordView(AdminRecordView)
    /// A record view that may not have been found.
    case recordViewNotFound(AdminRecordViewNotFound)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let value = try? container.decode(AdminReportView.self) {
            self = .repoView(value)
        } else if let value = try? container.decode(AdminRepoViewNotFound.self) {
            self = .repoViewNotFound(value)
        } else if let value = try? container.decode(AdminRecordView.self) {
            self = .recordView(value)
        } else if let value = try? container.decode(AdminRecordViewNotFound.self) {
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
/// A reference containing the list of the types of media details..
public enum MediaDetailUnion: Codable {
    /// The details for an image.
    case mediaImageDetails(AdminMediaImageDetails)
    /// The details for a video.
    case mediaVideoDetails(AdminMediaVideoDetails)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let value = try? container.decode(AdminMediaImageDetails.self) {
            self = .mediaImageDetails(value)
        } else if let value = try? container.decode(AdminMediaVideoDetails.self) {
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
