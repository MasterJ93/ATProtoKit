//
//  ComAtprotoAdminDefs.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation

extension ComAtprotoLexicon.Admin {

    /// The main data model definition for admin status attributes.
    ///
    /// - SeeAlso: This is based on the [`com.atproto.admin.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/defs.json
    public struct StatusAttributesDefinition: Codable {

        /// Indicates whether the status attributes are being applied.
        public let isApplied: Bool

        /// The reference of the attributes.
        public let reference: String?

        enum CodingKeys: String, CodingKey {
            case isApplied = "applied"
            case reference = "ref"
        }
    }

    /// A data model for a report view definition.
    ///
    /// - SeeAlso: This is based on the [`com.atproto.admin.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/defs.json
    public struct ReportViewDefinition: Codable {

        /// The ID of the report.
        public let id: Int

        /// The reason for the report.
        public let reasonType: ModerationReasonType

        /// The additional comment provided for a report. Optional.
        public let comment: String?

        /// The handle of the subject who's related to the report. Optional.
        public let subjectRepoHandle: String?

        /// The subject reference of the report.
        public let subject: ATUnion.RepositoryReferencesUnion

        /// The user who created the report.
        public let reportedBy: String

        /// The date and time the report was created.
        @DateFormatting public var createdAt: Date

        /// An array of action IDs that relate to resolutions.
        public let resolvedByActionIDs: [Int]

        public init(id: Int, reasonType: ModerationReasonType, comment: String?, subjectRepoHandle: String?, subject: ATUnion.RepositoryReferencesUnion, reportedBy: String, createdAt: Date,
                    resolvedByActionIDs: [Int]) {
            self.id = id
            self.reasonType = reasonType
            self.comment = comment
            self.subjectRepoHandle = subjectRepoHandle
            self.subject = subject
            self.reportedBy = reportedBy
            self._createdAt = DateFormatting(wrappedValue: createdAt)
            self.resolvedByActionIDs = resolvedByActionIDs
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.id = try container.decode(Int.self, forKey: .id)
            self.reasonType = try container.decode(ModerationReasonType.self, forKey: .reasonType)
            self.comment = try container.decodeIfPresent(String.self, forKey: .comment)
            self.subjectRepoHandle = try container.decodeIfPresent(String.self, forKey: .subjectRepoHandle)
            self.subject = try container.decode(ATUnion.RepositoryReferencesUnion.self, forKey: .subject)
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

    /// A data model for a detailed report view definition.
    ///
    /// - SeeAlso: This is based on the [`com.atproto.admin.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/defs.json
    public struct ReportViewDetailDefinition: Codable {

        /// The ID of a report.
        public let id: Int

        /// The reason for the report.
        public let reasonType: ModerationReasonType

        /// Any additional comments about the report. Optional.
        public var comment: String?

        /// The subject of the report.
        ///
        /// - Important: The item associated with this property is undocumented in the AT Protocol specifications. The documentation here is based on:\
        ///   \* **For items with some inferable context from property names or references**: its best interpretation, though not with full certainty.\
        ///   \* **For items without enough context for even an educated guess**: a direct acknowledgment of their undocumented status.\
        ///   \
        ///   Clarifications from Bluesky are needed in order to fully understand this item.
        public let subject: ATUnion.RepositoryViewUnion

        /// The status for the subject of the report. Optional.
        ///
        /// - Important: The item associated with this property is undocumented in the AT Protocol specifications. The documentation here is based on:\
        ///   \* **For items with some inferable context from property names or references**: its best interpretation, though not with full certainty.\
        ///   \* **For items without enough context for even an educated guess**: a direct acknowledgment of their undocumented status.\
        ///   \
        ///   Clarifications from Bluesky are needed in order to fully understand this item.
        public var subjectStatus: OzoneSubjectStatusView?

        /// The user who created the report.
        public let reportedBy: String

        /// The date and time the report was created.
        @DateFormatting public var createdAt: Date

        /// An array of resolved actions made in relation to the report.
        public let resolvedByActions: [OzoneModerationEventView]

        public init(id: Int, reasonType: ModerationReasonType, comment: String? = nil, subject: ATUnion.RepositoryViewUnion, subjectStatus: OzoneSubjectStatusView? = nil,
                    reportedBy: String, createdAt: Date, resolvedByActions: [OzoneModerationEventView]) {
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
            self.subject = try container.decode(ATUnion.RepositoryViewUnion.self, forKey: .subject)
            self.subjectStatus = try container.decodeIfPresent(OzoneSubjectStatusView.self, forKey: .subjectStatus)
            self.reportedBy = try container.decode(String.self, forKey: .reportedBy)
            self.createdAt = try container.decode(DateFormatting.self, forKey: .createdAt).wrappedValue
            self.resolvedByActions = try container.decode([OzoneModerationEventView].self, forKey: .resolvedByActions)
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

    /// A data model for a definition of an account view.
    ///
    /// - SeeAlso: This is based on the [`com.atproto.admin.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/defs.json
    public struct AccountViewDefinition: Codable {

        /// The decentralized identifier (DID) of the user.
        public let actorDID: String

        /// The handle of the user.
        public let handle: String

        /// The email of the user. Optional.
        public var email: String?

        /// The user's related records. Optional.
        ///
        /// - Important: The item associated with this property is undocumented in the AT Protocol specifications. The documentation here is based on:\
        ///   \* **For items with some inferable context from property names or references**: its best interpretation, though not with full certainty.\
        ///   \* **For items without enough context for even an educated guess**: a direct acknowledgment of their undocumented status.\
        ///   \
        ///   Clarifications from Bluesky are needed in order to fully understand this item.
        public var relatedRecords: [UnknownType]?

        /// The date and time the user was last indexed.
        @DateFormatting public var indexedAt: Date

        /// The invite code used by the user to sign up. Optional.
        public var invitedBy: ServerInviteCode?

        /// An array of invite codes held by the user. Optional.
        public var invites: [ServerInviteCode]?

        /// Indicates whether the invite codes held by the user are diabled. Optional.
        public var areInvitesDisabled: Bool?

        /// The date and time the email of the user was confirmed. Optional.
        @DateFormattingOptional public var emailConfirmedAt: Date?

        /// Any notes related to inviting the user. Optional.
        public var inviteNote: String?

        public init(actorDID: String, handle: String, email: String?, relatedRecords: [UnknownType]?, indexedAt: Date, invitedBy: ServerInviteCode?,
                    invites: [ServerInviteCode]?, areInvitesDisabled: Bool?, emailConfirmedAt: Date? = nil, inviteNote: String?) {
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

    /// A data model for a definition of a repository reference.
    ///
    /// - SeeAlso: This is based on the [`com.atproto.admin.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/defs.json
    public struct RepositoryReferenceDefinition: Codable {

        /// The decentralized identifier (DID) of the repository.
        public let repositoryDID: String

        enum CodingKeys: String, CodingKey {
            case repositoryDID = "did"
        }
    }

    /// A data model for a blob reference definition.
    ///
    /// - SeeAlso: This is based on the [`com.atproto.admin.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/defs.json
    public struct RepositoryBlobReferenceDefinition: Codable {

        /// The decentralized identifier (DID) of the blob reference.
        public let blobDID: String

        /// The CID hash of the blob reference.
        public let cidHash: String

        /// The URI of the record that contains the blob reference.
        public let recordURI: String?

        enum CodingKeys: String, CodingKey {
            case blobDID = "did"
            case cidHash = "cid"
            case recordURI = "recordUri"
        }
    }
}
