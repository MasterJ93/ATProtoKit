//
//  ToolsOzoneModerationDefs.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation

extension ToolsOzoneLexicon.Moderation {

    /// A definition model for a moderation event view.
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/defs.json
    public struct ModerationEventViewDefinition: Sendable, Codable {

        /// The ID of the moderator's event view.
        public let id: Int

        /// The type of the moderator's event view.
        public let event: ATUnion.ModerationEventViewUnion

        /// The subject reference of the moderator's event view.
        public let subject: ATUnion.ModerationEventViewSubjectUnion

        /// An array of CID hashes related to blobs for the moderator's event view.
        public let subjectBlobCIDHashes: [String]

        /// The creator of the event view.
        public let createdBy: String

        /// The date and time the event view was created.
        public let createdAt: Date

        /// The handle of the moderator. Optional.
        public var creatorHandle: String?

        /// The subject handle of the event view. Optional.
        public var subjectHandle: String?

        public init(id: Int, event: ATUnion.ModerationEventViewUnion, subject: ATUnion.ModerationEventViewSubjectUnion, subjectBlobCIDHashes: [String],
                    createdBy: String, createdAt: Date, creatorHandle: String? = nil, subjectHandle: String? = nil) {
            self.id = id
            self.event = event
            self.subject = subject
            self.subjectBlobCIDHashes = subjectBlobCIDHashes
            self.createdBy = createdBy
            self.createdAt = createdAt
            self.creatorHandle = creatorHandle
            self.subjectHandle = subjectHandle
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.id = try container.decode(Int.self, forKey: .id)
            self.event = try container.decode(ATUnion.ModerationEventViewUnion.self, forKey: .event)
            self.subject = try container.decode(ATUnion.ModerationEventViewSubjectUnion.self, forKey: .subject)
            self.subjectBlobCIDHashes = try container.decode([String].self, forKey: .subjectBlobCIDHashes)
            self.createdBy = try container.decode(String.self, forKey: .createdBy)
            self.createdAt = try decodeDate(from: container, forKey: .createdAt)
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
            try encodeDate(self.createdAt, with: &container, forKey: .createdAt)
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

    /// A definition model for a detailed moderation event view
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/defs.json
    public struct EventViewDetailDefinition: Sendable, Codable {

        /// The ID of the moderator's event view.
        public let id: Int

        /// The type of the moderator's event view.
        public let event: ATUnion.ModerationEventViewDetailUnion

        /// The subject reference of the moderator's event view.
        public let subject: ATUnion.ModerationEventViewDetailSubjectUnion

        /// An array of blobs for a moderator to look at.
        public let subjectBlobs: [ToolsOzoneLexicon.Moderation.BlobViewDefinition]

        /// The creator of the event view.
        public let createdBy: String

        /// The date and time the event view was created.
        public let createdAt: Date

        public init(id: Int, event: ATUnion.ModerationEventViewDetailUnion, subject: ATUnion.ModerationEventViewDetailSubjectUnion,
                    subjectBlobs: [ToolsOzoneLexicon.Moderation.BlobViewDefinition], createdBy: String, createdAt: Date) {
            self.id = id
            self.event = event
            self.subject = subject
            self.subjectBlobs = subjectBlobs
            self.createdBy = createdBy
            self.createdAt = createdAt
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.id = try container.decode(Int.self, forKey: .id)
            self.event = try container.decode(ATUnion.ModerationEventViewDetailUnion.self, forKey: .event)
            self.subject = try container.decode(ATUnion.ModerationEventViewDetailSubjectUnion.self, forKey: .subject)
            self.subjectBlobs = try container.decode([ToolsOzoneLexicon.Moderation.BlobViewDefinition].self, forKey: .subjectBlobs)
            self.createdBy = try container.decode(String.self, forKey: .createdBy)
            self.createdAt = try decodeDate(from: container, forKey: .createdAt)
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.id, forKey: .id)
            try container.encode(self.event, forKey: .event)
            try container.encode(self.subject, forKey: .subject)
            try container.encode(self.subjectBlobs, forKey: .subjectBlobs)
            try container.encode(self.createdBy, forKey: .createdBy)
            try encodeDate(self.createdAt, with: &container, forKey: .createdAt)
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

    /// A definition model for a subject's status view.
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/defs.json
    public struct SubjectStatusViewDefinition: Sendable, Codable {

        /// The ID of the status view.
        public let id: Int

        /// The subject reference of the status view.
        public let subject: ATUnion.SubjectStatusViewSubjectUnion

        /// An array of CID hashes related to blobs. Optional.
        public var subjectBlobCIDHashes: [String]?

        /// The handle of the subject related to the status. Optional.
        public var subjectRepoHandle: String?

        /// The date and time of the last update for the status view.
        ///
        /// - Note: According to the AT Protocol specifications: "Timestamp referencing when
        /// the last update was made to the moderation status of the subject."
        public let updatedAt: Date

        /// The date and time of the day the first event occured.
        ///
        /// - Note: According to the AT Protocol specifications: "Timestamp referencing the first
        /// moderation status impacting event was emitted on the subject."
        public let createdAt: Date

        /// The review status of the subject.
        public let reviewState: ToolsOzoneLexicon.Moderation.SubjectReviewStateDefinition

        /// Any additional comments written about the subject. Optional.
        public var comment: String?

        /// The date and time the subject's time to be muted has been lifted. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Sticky comment on the subject."
        public let muteUntil: Date?

        /// The date and time until which reporting on the subject is muted. Optional.
        ///
        /// - Important: The item associated with this property is undocumented in the AT Protocol specifications. The documentation here is based on:\
        ///   \* **For items with some inferable context from property names or references**: its best interpretation, though not with full certainty.\
        ///   \* **For items without enough context for even an educated guess**: a direct acknowledgment of their undocumented status.\
        ///   \
        ///   Clarifications from Bluesky are needed in order to fully understand this item.
        public let muteReportingUntil: Date?

        /// The name of the reviewer that reviewed the subject. Optional.
        public var lastReviewedBy: String?

        /// The date and time the last reviewer looked at the subject. Optional.
        public let lastReviewedAt: Date?

        /// The date and time of the last report about the subject. Optional.
        public let lastReportedAt: Date?

        /// The date and time of the last appeal. Optional.
        public let lastAppealedAt: Date?

        /// Indicates whether the subject was taken down. Optional.
        public var isTakenDown: Bool?

        /// Indicates whether an appeal has been made. Optional.
        public var wasAppealed: Bool?

        /// The date and time the subject's suspension will be lifted. Optional.
        public var suspendUntil: Date?

        /// An array of tags. Optional.
        public var tags: [String]?

        public init(id: Int, subject: ATUnion.SubjectStatusViewSubjectUnion, subjectBlobCIDHashes: [String]? = nil, subjectRepoHandle: String? = nil,
                    updatedAt: Date, createdAt: Date, reviewState: ToolsOzoneLexicon.Moderation.SubjectReviewStateDefinition, comment: String? = nil,
                    muteUntil: Date? = nil, muteReportingUntil: Date? = nil, lastReviewedBy: String? = nil, lastReviewedAt: Date? = nil,
                    lastReportedAt: Date? = nil, lastAppealedAt: Date? = nil, isTakenDown: Bool? = nil, wasAppealed: Bool? = nil, suspendUntil: Date? = nil,
                    tags: [String]? = nil) {
            self.id = id
            self.subject = subject
            self.subjectBlobCIDHashes = subjectBlobCIDHashes
            self.subjectRepoHandle = subjectRepoHandle
            self.updatedAt = updatedAt
            self.createdAt = createdAt
            self.reviewState = reviewState
            self.comment = comment
            self.muteUntil = muteUntil
            self.muteReportingUntil = muteReportingUntil
            self.lastReviewedBy = lastReviewedBy
            self.lastReviewedAt = lastReviewedAt
            self.lastReportedAt = lastReportedAt
            self.lastAppealedAt = lastAppealedAt
            self.isTakenDown = isTakenDown
            self.wasAppealed = wasAppealed
            self.suspendUntil = suspendUntil
            self.tags = tags
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.id = try container.decode(Int.self, forKey: .id)
            self.subject = try container.decode(ATUnion.SubjectStatusViewSubjectUnion.self, forKey: .subject)
            self.subjectBlobCIDHashes = try container.decodeIfPresent([String].self, forKey: .subjectBlobCIDHashes)
            self.subjectRepoHandle = try container.decodeIfPresent(String.self, forKey: .subjectRepoHandle)
            self.updatedAt = try decodeDate(from: container, forKey: .updatedAt)
            self.createdAt = try decodeDate(from: container, forKey: .createdAt)
            self.reviewState = try container.decode(ToolsOzoneLexicon.Moderation.SubjectReviewStateDefinition.self, forKey: .reviewState)
            self.comment = try container.decodeIfPresent(String.self, forKey: .comment)
            self.muteUntil = try decodeDateIfPresent(from: container, forKey: .muteUntil)
            self.muteReportingUntil = try decodeDateIfPresent(from: container, forKey: .muteReportingUntil)
            self.lastReviewedBy = try container.decodeIfPresent(String.self, forKey: .lastReviewedBy)
            self.lastReviewedAt = try decodeDateIfPresent(from: container, forKey: .lastReviewedAt)
            self.lastReportedAt = try decodeDateIfPresent(from: container, forKey: .lastReportedAt)
            self.lastAppealedAt = try decodeDateIfPresent(from: container, forKey: .lastReportedAt)
            self.isTakenDown = try container.decodeIfPresent(Bool.self, forKey: .isTakenDown)
            self.wasAppealed = try container.decodeIfPresent(Bool.self, forKey: .wasAppealed)
            self.suspendUntil = try decodeDateIfPresent(from: container, forKey: .suspendUntil)
            self.tags = try container.decodeIfPresent([String].self, forKey: .tags)
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.id, forKey: .id)
            try container.encode(self.subject, forKey: .subject)
            try container.encodeIfPresent(self.subjectBlobCIDHashes, forKey: .subjectBlobCIDHashes)
            try container.encodeIfPresent(self.subjectRepoHandle, forKey: .subjectRepoHandle)
            try encodeDate(self.updatedAt, with: &container, forKey: .updatedAt)
            try encodeDate(self.createdAt, with: &container, forKey: .createdAt)
            try container.encode(self.reviewState, forKey: .reviewState)
            try container.encodeIfPresent(self.comment, forKey: .comment)
            try encodeDateIfPresent(self.muteUntil, with: &container, forKey: .muteUntil)
            try encodeDateIfPresent(self.muteReportingUntil, with: &container, forKey: .muteReportingUntil)
            try container.encodeIfPresent(self.lastReviewedBy, forKey: .lastReviewedBy)
            try encodeDateIfPresent(self.lastReviewedAt, with: &container, forKey: .lastReviewedAt)
            try encodeDateIfPresent(self.lastReportedAt, with: &container, forKey: .lastReportedAt)
            try encodeDateIfPresent(self.lastReportedAt, with: &container, forKey: .lastReportedAt)
            try container.encodeIfPresent(self.isTakenDown, forKey: .isTakenDown)
            try container.encodeIfPresent(self.wasAppealed, forKey: .wasAppealed)
            try encodeDateIfPresent(self.suspendUntil, with: &container, forKey: .suspendUntil)
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
            case muteReportingUntil
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

    /// A definition model for  the subject review state.
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/defs.json
    public enum SubjectReviewStateDefinition: String, Sendable, Codable {

        /// Moderator review status of a subject: Open. Indicates that the subject needs to be
        /// reviewed by a moderator.
        ///
        /// - Note: The above documentation was taken directly from the AT Protocol specifications.
        case reviewOpen

        /// Moderator review status of a subject: Escalated. Indicates that the subject was
        /// escalated for review by a moderator.
        ///
        /// - Note: The above documentation was taken directly from the AT Protocol specifications.
        case reviewEscalated

        /// Moderator review status of a subject: Closed. Indicates that the subject was already
        /// reviewed and resolved by a moderator.
        ///
        /// - Note: The above documentation was taken directly from the AT Protocol specifications.
        case reviewClosed

        /// Moderator review status of a subject: Unnecessary. Indicates that the subject does
        /// not need a review at the moment but there
        /// is probably some moderation related metadata available for it
        ///
        /// - Note: The above documentation was taken directly from the AT Protocol specifications.
        case reviewNone
    }

    /// A definition model for an event takedown.
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/defs.json
    public struct EventTakedownDefinition: Sendable, Codable {

        /// Any additional comments for the takedown event. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Take down a subject permanently
        /// or temporarily."
        public let comment: String?

        /// The amount of time (in hours) for the user to be considered takendown. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Indicates how long the takedown
        /// should be in effect before automatically expiring."
        public let durationInHours: Int?

        /// Indicates whether the remaining reports on the content created by the user account will
        /// be resolved. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "If true, all other reports on
        /// content authored by this account will be resolved (acknowledged)."
        public let acknowledgeAccountSubjects: Bool?
    }

    /// A definition model for a reverse takedown event.
    ///
    /// - Note: According to the AT Protocol specifications: "Revert take down action on
    /// a subject."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/defs.json
    public struct EventReverseTakedownDefinition: Sendable, Codable {

        /// Any comments for the reverse takedown event. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Describe reasoning behind
        /// the reversal."
        public let comment: String?
    }

    /// A definition model for an resolved appeal event.
    ///
    /// - Note: According to the AT Protocol specifications: "Resolve appeal on a subject."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/defs.json
    public struct EventResolveAppealDefinition: Sendable, Codable {

        /// Any comments for the moderator's appeal resolution event. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Describe resolution."
        public let comment: String?
    }

    /// A definition model for a comment event.
    ///
    /// - Note: According to the AT Protocol specifications: "Add a comment to a subject."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/defs.json
    public struct EventCommentDefinition: Sendable, Codable {

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

    /// A definition model for a report event.
    ///
    /// - Note: According to the AT Protocol specifications: "Report a subject."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/defs.json
    public struct EventReportDefinition: Sendable, Codable {

        /// Any comments for the moderator's report event. Optional.
        public var comment: String?

        /// Indicates whether the reporter has been muted. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Set to true if the reporter
        /// was muted from reporting at the time of the event. These reports won't impact
        /// the reviewState of the subject."
        public let isReporterMuted: Bool?

        /// The type of report.
        public let reportType: ComAtprotoLexicon.Moderation.ReasonTypeDefinition
    }

    /// A definition model for a label event.
    ///
    /// - Note: According to the AT Protocol specifications: "Apply/Negate labels on a subject"
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/defs.json
    public struct EventLabelDefinition: Sendable, Codable {

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

    /// A definition model for an acknowledgement event.
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/defs.json
    public struct EventAcknowledgeDefinition: Sendable, Codable {

        /// Any comments for the moderator's acknowledge event. Optional.
        public var comment: String?
    }

    /// A definition model for an acknowledgement event.
    ///
    /// - SeeAlso: This is based on the [tools.ozone.moderation.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/defs.json
    public struct EventEscalateDefinition: Sendable, Codable {

        /// Any additional comments for escalating a report. Optional.
        public var comment: String?
    }

    /// A definition model for a definition of a mute event.
    ///
    /// - Note: According to the AT Protocol specifications: "Mute incoming reports on a subject."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/defs.json
    public struct EventMuteDefinition: Sendable, Codable {

        /// Any additional comments for the mute event. Optional.
        public var comment: String?

        /// The amount of time (in hours) that the moderator has put in for muting a user.
        ///
        /// - Note: According to the AT Protocol specifications: "Indicates how long the
        /// subject should remain muted."
        public let durationInHours: Int
    }

    /// A definition model for an unmute event definition.
    ///
    /// - Note: According to the AT Protocol specifications: "Unmute action on a subject."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/defs.json
    public struct EventUnmuteDefinition: Sendable, Codable {

        /// Any comments for the moderator's unmute event. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Describe reasoning behind
        /// the reversal."
        public var comment: String?
    }

    /// A definition model for a mute reporter event.
    ///
    /// - Note: According to the AT Protocol specifications: "Mute incoming reports from
    /// an account."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/defs.json
    public struct EventMuteReporterDefinition: Sendable, Codable {

        /// Indicates how long the account should remain muted (in hours).
        ///
        /// - Note: According to the AT Protocol specifications: "Indicates how long the
        /// account should remain muted."
        public let durationInHours: Int

        /// Any additional comments about the event. Optional.
        public let comment: String?
    }

    /// A definition model for an unmute reporter event.
    ///
    /// - Note: According to the AT Protocol specifications: "Unmute incoming reports
    /// from an account."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/defs.json
    public struct EventUnmuteReporterDefinition: Sendable, Codable {

        /// Any additional comments about the event.
        ///
        /// - Note: According to the AT Protocol specifications: "Describe reasoning
        /// behind the reversal."
        public let comment: String?
    }

    /// A definition model for an email event.
    ///
    /// - Note: According to the AT Protocol specifications: "Keep a log of outgoing email to a user."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/defs.json
    public struct EventEmailDefinition: Sendable, Codable {

        /// The subject line of the email.
        ///
        /// - Note: According to the AT Protocol specifications: "The subject line of the email
        /// sent to the user."
        public let subjectLine: String

        /// The body of the email.
        ///
        /// - Note: According to the AT Protocol specifications: "The content of the email
        /// sent to the user."
        public let content: String

        /// Any additional comments about the email. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Additional comment about
        /// the outgoing comm."
        public var comment: String?
    }

    /// A definition model for a diversion event.
    ///
    /// - Note: According to the AT Protocol specifications: "Divert a record's blobs to a
    /// 3rd party service for further scanning/tagging"
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/defs.json
    public struct EventDivertDefinition: Sendable, Codable {

        /// Any additional comments about the diversion.
        public let comment: String?
    }

    /// A definition model for a tag event definition.
    ///
    /// - Note: According to the AT Protocol specifications: "Add/Remove a tag on a subject."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.admin.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/defs.json
    public struct EventTagDefinition: Sendable, Codable {

        /// An array of tags to be added to the user.
        ///
        /// If a tag in the array already exists on the user, then the tag will be ignored.
        ///
        /// - Note: According to the AT Protocol specifications: "Tags to be added to
        /// the subject. If already exists, won't be duplicated."
        public let add: [String]

        /// An array of tags to be removed from the user.
        ///
        /// If a tag in the array doesn't exist on the user, then the tag will be ignored.
        ///
        /// - Note: According to the AT Protocol specifications: "Tags to be removed to
        /// the subject. Ignores a tag If it doesn't exist, won't be duplicated."
        public let remove: [String]

        /// Any additional comments about the moderator's tag event.
        ///
        /// - Note: According to the AT Protocol specifications: "Additional comment about
        /// added/removed tags."
        public let comment: String?
    }

    /// A definition model for a repository view.
    ///
    /// - SeeAlso: This is based on the [`com.atproto.admin.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/defs.json
    public struct RepositoryViewDefinition: Sendable, Codable {

        /// The decentralized identifier (DID) of the user.
        public let actorDID: String

        /// The handle of the user.
        public let handle: String

        /// The email of the user. Optional.
        public let email: String?

        /// The related records of the user.
        ///
        /// - Important: The item associated with this property is undocumented in the AT Protocol specifications. The documentation here is based on:\
        ///   \* **For items with some inferable context from property names or references**: its best interpretation, though not with full certainty.\
        ///   \* **For items without enough context for even an educated guess**: a direct acknowledgment of their undocumented status.\
        ///   \
        ///   Clarifications from Bluesky are needed in order to fully understand this item.
        public let relatedRecords: UnknownType

        /// The date and time the user was indexed.
        public let indexedAt: Date

        /// The moderation status of the user.
        public let moderation: ToolsOzoneLexicon.Moderation.ModerationDefinition

        /// The invite code used by the user to sign up. Optional.
        public let invitedBy: ComAtprotoLexicon.Server.InviteCodeDefinition?

        /// Indicates whether the invite codes held by the user are diabled. Optional.
        public let areInvitesDisabled: Bool?

        /// The note of the invite. Optional.
        public let inviteNote: String?

        /// The date and time a status has been deactivated.
        public let deactivatedAt: Date?

        public init(actorDID: String, handle: String, email: String? = nil, relatedRecords: UnknownType, indexedAt: Date,
                    moderation: ToolsOzoneLexicon.Moderation.ModerationDefinition, invitedBy: ComAtprotoLexicon.Server.InviteCodeDefinition? = nil,
                    areInvitesDisabled: Bool? = nil, inviteNote: String? = nil, deactivatedAt: Date? = nil) {
            self.actorDID = actorDID
            self.handle = handle
            self.email = email
            self.relatedRecords = relatedRecords
            self.indexedAt = indexedAt
            self.moderation = moderation
            self.invitedBy = invitedBy
            self.areInvitesDisabled = areInvitesDisabled
            self.inviteNote = inviteNote
            self.deactivatedAt = deactivatedAt
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.actorDID = try container.decode(String.self, forKey: .actorDID)
            self.handle = try container.decode(String.self, forKey: .handle)
            self.email = try container.decodeIfPresent(String.self, forKey: .email)
            self.relatedRecords = try container.decode(UnknownType.self, forKey: .relatedRecords)
            self.indexedAt = try decodeDate(from: container, forKey: .indexedAt)
            self.moderation = try container.decode(ToolsOzoneLexicon.Moderation.ModerationDefinition.self, forKey: .moderation)
            self.invitedBy = try container.decodeIfPresent(ComAtprotoLexicon.Server.InviteCodeDefinition.self, forKey: .invitedBy)
            self.areInvitesDisabled = try container.decodeIfPresent(Bool.self, forKey: .areInvitesDisabled)
            self.inviteNote = try container.decodeIfPresent(String.self, forKey: .inviteNote)
            self.deactivatedAt = try decodeDateIfPresent(from: container, forKey: .deactivatedAt)
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.actorDID, forKey: .actorDID)
            try container.encode(self.handle, forKey: .handle)
            try container.encodeIfPresent(self.email, forKey: .email)
            try container.encode(self.relatedRecords, forKey: .relatedRecords)
            try encodeDate(self.indexedAt, with: &container, forKey: .indexedAt)
            try container.encode(self.moderation, forKey: .moderation)
            try container.encodeIfPresent(self.invitedBy, forKey: .invitedBy)
            try container.encodeIfPresent(self.areInvitesDisabled, forKey: .areInvitesDisabled)
            try container.encodeIfPresent(self.inviteNote, forKey: .inviteNote)
            try encodeDateIfPresent(self.deactivatedAt, with: &container, forKey: .deactivatedAt)
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
            case deactivatedAt
        }
    }

    /// A definition model for a detailed repository view.
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/defs.json
    public struct RepositoryViewDetailDefinition: Sendable, Codable {

        /// The decentralized identifier (DID) of the user.
        public let actorDID: String

        /// The handle of the user.
        public let handle: String

        /// The email of the user. Optional.
        public let email: String?

        /// The user's related records.
        ///
        /// - Important: The item associated with this property is undocumented in the AT Protocol specifications. The documentation here is based on:\
        ///   \* **For items with some inferable context from property names or references**: its best interpretation, though not with full certainty.\
        ///   \* **For items without enough context for even an educated guess**: a direct acknowledgment of their undocumented status.\
        ///   \
        ///   Clarifications from Bluesky are needed in order to fully understand this item.
        public let relatedRecords: UnknownType

        /// The date and time the user was last indexed.
        public let indexedAt: Date

        /// The detailed moderation status of the user.
        public let moderation: ToolsOzoneLexicon.Moderation.ModerationDetailDefinition

        /// An array of labels associated with the user. Optional.
        public let labels: [ComAtprotoLexicon.Label.LabelDefinition]?

        /// The invite code used by the user to sign up. Optional.
        public let invitedBy: ComAtprotoLexicon.Server.InviteCodeDefinition?

        /// An array of invite codes held by the user. Optional.
        public let invites: [ComAtprotoLexicon.Server.InviteCodeDefinition]?

        /// Indicates whether the invite codes held by the user are diabled. Optional.
        public let areInvitesDisabled: Bool?

        /// The note of the invite. Optional.
        public let inviteNote: String?

        /// The date and time the email of the user was confirmed. Optional.
        public let emailConfirmedAt: Date?

        /// The date and time a status has been deactivated.
        public let deactivatedAt: Date?

        public init(actorDID: String, handle: String, email: String? = nil, relatedRecords: UnknownType, indexedAt: Date,
                    moderation: ToolsOzoneLexicon.Moderation.ModerationDetailDefinition, labels: [ComAtprotoLexicon.Label.LabelDefinition]? = nil,
                    invitedBy: ComAtprotoLexicon.Server.InviteCodeDefinition?, invites: [ComAtprotoLexicon.Server.InviteCodeDefinition]? = nil,
                    areInvitesDisabled: Bool? = nil, inviteNote: String? = nil, emailConfirmedAt: Date? = nil, deactivatedAt: Date? = nil) {
            self.actorDID = actorDID
            self.handle = handle
            self.email = email
            self.relatedRecords = relatedRecords
            self.indexedAt = indexedAt
            self.moderation = moderation
            self.labels = labels
            self.invitedBy = invitedBy
            self.invites = invites
            self.areInvitesDisabled = areInvitesDisabled
            self.inviteNote = inviteNote
            self.emailConfirmedAt = emailConfirmedAt
            self.deactivatedAt = deactivatedAt
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.actorDID = try container.decode(String.self, forKey: .actorDID)
            self.handle = try container.decode(String.self, forKey: .handle)
            self.email = try container.decodeIfPresent(String.self, forKey: .email)
            self.relatedRecords = try container.decode(UnknownType.self, forKey: .relatedRecords)
            self.indexedAt = try decodeDate(from: container, forKey: .indexedAt)
            self.moderation = try container.decode(ToolsOzoneLexicon.Moderation.ModerationDetailDefinition.self, forKey: .moderation)
            self.labels = try container.decodeIfPresent([ComAtprotoLexicon.Label.LabelDefinition].self, forKey: .labels)
            self.invitedBy = try container.decodeIfPresent(ComAtprotoLexicon.Server.InviteCodeDefinition.self, forKey: .invitedBy)
            self.invites = try container.decodeIfPresent([ComAtprotoLexicon.Server.InviteCodeDefinition].self,forKey: .invites)
            self.areInvitesDisabled = try container.decodeIfPresent(Bool.self, forKey: .areInvitesDisabled)
            self.inviteNote = try container.decodeIfPresent(String.self, forKey: .inviteNote)
            self.emailConfirmedAt = try decodeDateIfPresent(from: container, forKey: .emailConfirmedAt)
            self.deactivatedAt = try decodeDateIfPresent(from: container, forKey: .deactivatedAt)
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.actorDID, forKey: .actorDID)
            try container.encode(self.handle, forKey: .handle)
            try container.encodeIfPresent(self.email, forKey: .email)
            try container.encode(self.relatedRecords, forKey: .relatedRecords)
            try encodeDate(self.indexedAt, with: &container, forKey: .indexedAt)
            try container.encode(self.moderation, forKey: .moderation)
            try container.encodeIfPresent(self.labels, forKey: .labels)
            try container.encodeIfPresent(self.invitedBy, forKey: .invitedBy)
            try container.encodeIfPresent(self.invites, forKey: .invites)
            try container.encodeIfPresent(self.areInvitesDisabled, forKey: .areInvitesDisabled)
            try container.encodeIfPresent(self.inviteNote, forKey: .inviteNote)
            try encodeDateIfPresent(self.emailConfirmedAt, with: &container, forKey: .emailConfirmedAt)
            try encodeDateIfPresent(self.deactivatedAt, with: &container, forKey: .deactivatedAt)
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
            case deactivatedAt
        }
    }

    /// A definition model for a respository view that may not have been found.
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/defs.json
    public struct RepositoryViewNotFoundDefinition: Sendable, Codable {

        /// The decentralized identifier (DID) of the repository.
        public let repositoryDID: String

        enum CodingKeys: String, CodingKey {
            case repositoryDID = "did"
        }
    }

    /// A definition model for a record view.
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/defs.json
    public struct RecordViewDefinition: Sendable, Codable {

        /// The URI of the record.
        public let recordURI: String

        /// The CID hash of the record.
        public let cidHash: String

        /// The value of the record.
        ///
        /// - Important: The item associated with this property is undocumented in the AT Protocol specifications. The documentation here is based on:\
        ///   \* **For items with some inferable context from property names or references**: its best interpretation, though not with full certainty.\
        ///   \* **For items without enough context for even an educated guess**: a direct acknowledgment of their undocumented status.\
        ///   \
        ///   Clarifications from Bluesky are needed in order to fully understand this item.
        public let value: UnknownType

        /// An array of CID hashes for blobs.
        public let blobCIDHashes: [String]

        /// The date and time the record is indexed.
        public let indexedAt: Date

        /// The status of the subject.
        ///
        /// - Important: The item associated with this property is undocumented in the AT Protocol specifications. The documentation here is based on:\
        ///   \* **For items with some inferable context from property names or references**: its best interpretation, though not with full certainty.\
        ///   \* **For items without enough context for even an educated guess**: a direct acknowledgment of their undocumented status.\
        ///   \
        ///   Clarifications from Bluesky are needed in order to fully understand this item.
        public let moderation: ToolsOzoneLexicon.Moderation.ModerationDefinition

        /// The repository view of the record.
        ///
        /// - Important: The item associated with this property is undocumented in the AT Protocol specifications. The documentation here is based on:\
        ///   \* **For items with some inferable context from property names or references**: its best interpretation, though not with full certainty.\
        ///   \* **For items without enough context for even an educated guess**: a direct acknowledgment of their undocumented status.\
        ///   \
        ///   Clarifications from Bluesky are needed in order to fully understand this item.
        public let repository: ToolsOzoneLexicon.Moderation.RepositoryViewDefinition

        public init(recordURI: String, cidHash: String, value: UnknownType, blobCIDHashes: [String], indexedAt: Date,
                    moderation: ToolsOzoneLexicon.Moderation.ModerationDefinition, repository: ToolsOzoneLexicon.Moderation.RepositoryViewDefinition) {
            self.recordURI = recordURI
            self.cidHash = cidHash
            self.value = value
            self.blobCIDHashes = blobCIDHashes
            self.indexedAt = indexedAt
            self.moderation = moderation
            self.repository = repository
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.recordURI = try container.decode(String.self, forKey: .recordURI)
            self.cidHash = try container.decode(String.self, forKey: .cidHash)
            self.value = try container.decode(UnknownType.self, forKey: .value)
            self.blobCIDHashes = try container.decode([String].self, forKey: .blobCIDHashes)
            self.indexedAt = try decodeDate(from: container, forKey: .indexedAt)
            self.moderation = try container.decode(ToolsOzoneLexicon.Moderation.ModerationDefinition.self, forKey: .moderation)
            self.repository = try container.decode(ToolsOzoneLexicon.Moderation.RepositoryViewDefinition.self, forKey: .repository)
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.recordURI, forKey: .recordURI)
            try container.encode(self.cidHash, forKey: .cidHash)
            try container.encode(self.value, forKey: .value)
            try container.encode(self.blobCIDHashes, forKey: .blobCIDHashes)
            try encodeDate(self.indexedAt, with: &container, forKey: .indexedAt)
            try container.encode(self.moderation, forKey: .moderation)
            try container.encode(self.repository, forKey: .repository)
        }

        enum CodingKeys: String, CodingKey {
            case recordURI = "uri"
            case cidHash = "cid"
            case value
            case blobCIDHashes = "blobCids"
            case indexedAt
            case moderation
            case repository = "repo"
        }
    }

    /// A definition model for a detailed view of a record.
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/defs.json
    public struct RecordViewDetailDefinition: Sendable, Codable {

        /// The URI of a record.
        public let recordURI: String

        /// The CID hash of the record.
        public let cidHash: String

        /// The value of the record.
        ///
        /// - Important: The item associated with this property is undocumented in the AT Protocol specifications. The documentation here is based on:\
        ///   \* **For items with some inferable context from property names or references**: its best interpretation, though not with full certainty.\
        ///   \* **For items without enough context for even an educated guess**: a direct acknowledgment of their undocumented status.\
        ///   \
        ///   Clarifications from Bluesky are needed in order to fully understand this item.
        public let value: String

        /// An array of CID hashes for blobs.
        public let blobs: [ToolsOzoneLexicon.Moderation.BlobViewDefinition]

        /// An array of labels attached to the record. Optional.
        public let labels: [ComAtprotoLexicon.Label.LabelDefinition]?

        /// The date and time the record is indexed.
        public let indexedAt: Date

        /// The repository view of the record.
        ///
        /// - Important: The item associated with this property is undocumented in the AT Protocol specifications. The documentation here is based on:\
        ///   \* **For items with some inferable context from property names or references**: its best interpretation, though not with full certainty.\
        ///   \* **For items without enough context for even an educated guess**: a direct acknowledgment of their undocumented status.\
        ///   \
        ///   Clarifications from Bluesky are needed in order to fully understand this item.
        public let moderation: ToolsOzoneLexicon.Moderation.ModerationDetailDefinition

        /// The repository view of the record.
        ///
        /// - Important: The item associated with this property is undocumented in the AT Protocol specifications. The documentation here is based on:\
        ///   \* **For items with some inferable context from property names or references**: its best interpretation, though not with full certainty.\
        ///   \* **For items without enough context for even an educated guess**: a direct acknowledgment of their undocumented status.\
        ///   \
        ///   Clarifications from Bluesky are needed in order to fully understand this item.
        public let repository: ToolsOzoneLexicon.Moderation.RepositoryViewDefinition

        public init(recordURI: String, cidHash: String, value: String, blobs: [ToolsOzoneLexicon.Moderation.BlobViewDefinition],
                    labels: [ComAtprotoLexicon.Label.LabelDefinition]?, indexedAt: Date, moderation: ToolsOzoneLexicon.Moderation.ModerationDetailDefinition,
                    repository: ToolsOzoneLexicon.Moderation.RepositoryViewDefinition) {
            self.recordURI = recordURI
            self.cidHash = cidHash
            self.value = value
            self.blobs = blobs
            self.labels = labels
            self.indexedAt = indexedAt
            self.moderation = moderation
            self.repository = repository
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.recordURI = try container.decode(String.self, forKey: .recordURI)
            self.cidHash = try container.decode(String.self, forKey: .cidHash)
            self.value = try container.decode(String.self, forKey: .value)
            self.blobs = try container.decode([ToolsOzoneLexicon.Moderation.BlobViewDefinition].self, forKey: .blobs)
            self.labels = try container.decodeIfPresent([ComAtprotoLexicon.Label.LabelDefinition].self, forKey: .labels)
            self.indexedAt = try decodeDate(from: container, forKey: .indexedAt)
            self.moderation = try container.decode(ToolsOzoneLexicon.Moderation.ModerationDetailDefinition.self, forKey: .moderation)
            self.repository = try container.decode(ToolsOzoneLexicon.Moderation.RepositoryViewDefinition.self, forKey: .repository)
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.recordURI, forKey: .recordURI)
            try container.encode(self.cidHash, forKey: .cidHash)
            try container.encode(self.value, forKey: .value)
            try container.encode(self.blobs, forKey: .blobs)
            try container.encodeIfPresent(self.labels, forKey: .labels)
            try encodeDate(self.indexedAt, with: &container, forKey: .indexedAt)
            try container.encode(self.moderation, forKey: .moderation)
            try container.encode(self.repository, forKey: .repository)
        }

        enum CodingKeys: String, CodingKey {
            case recordURI = "uri"
            case cidHash = "cid"
            case value
            case blobs
            case labels
            case indexedAt
            case moderation
            case repository = "repo"
        }
    }

    /// A definition model for a record that may not have been found.
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/defs.json
    public struct RecordViewNotFoundDefinition: Sendable, Codable {

        /// The URI of the record.
        public let recordURI: String

        enum CodingKeys: String, CodingKey {
            case recordURI = "uri"
        }
    }

    /// A definition model for moderation.
    ///
    /// - Important: The item associated with this struct is undocumented in the AT Protocol specifications. The documentation here is based on:\
    ///   \* **For items with some inferable context from property names or references**: its best interpretation, though not with full certainty.\
    ///   \* **For items without enough context for even an educated guess**: a direct acknowledgment of their undocumented status.\
    ///   \
    ///   Clarifications from Bluesky are needed in order to fully understand this item.
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/defs.json
    public struct ModerationDefinition: Sendable, Codable {

        /// The status of the subject. Optional.
        ///
        /// - Important: The item associated with this property is undocumented in the AT Protocol specifications. The documentation here is based on:\
        ///   \* **For items with some inferable context from property names or references**: its best interpretation, though not with full certainty.\
        ///   \* **For items without enough context for even an educated guess**: a direct acknowledgment of their undocumented status.\
        ///   \
        ///   Clarifications from Bluesky are needed in order to fully understand this item.
        public let subjectStatus: ToolsOzoneLexicon.Moderation.SubjectStatusViewDefinition
    }

    /// A definition model for a detailed moderation.
    ///
    /// - Important: The item associated with this struct is undocumented in the AT Protocol specifications. The documentation here is based on:\
    ///   \* **For items with some inferable context from property names or references**: its best interpretation, though not with full certainty.\
    ///   \* **For items without enough context for even an educated guess**: a direct acknowledgment of their undocumented status.\
    ///   \
    ///   Clarifications from Bluesky are needed in order to fully understand this item.
    ///
    /// - SeeAlso: This is based on the [`com.atproto.admin.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/defs.json
    public struct ModerationDetailDefinition: Sendable, Codable {

        /// The status of the subject. Optional.
        ///
        /// - Important: The item associated with this property is undocumented in the AT Protocol specifications. The documentation here is based on:\
        ///   \* **For items with some inferable context from property names or references**: its best interpretation, though not with full certainty.\
        ///   \* **For items without enough context for even an educated guess**: a direct acknowledgment of their undocumented status.\
        ///   \
        ///   Clarifications from Bluesky are needed in order to fully understand this item.
        public var subjectStatus: ToolsOzoneLexicon.Moderation.SubjectStatusViewDefinition?
    }

    /// A definition model for a blob view.
    ///
    /// - SeeAlso: This is based on the [`com.atproto.admin.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/defs.json
    public struct BlobViewDefinition: Sendable, Codable {

        /// The CID hash of the blob.
        public let cidHash: String

        /// The MIME type of the blob.
        public let mimeType: String

        /// The size of the blob. Written in bytes.
        public let size: Int

        /// The date and time the blob was created.
        public let createdAt: Date

        /// The type of media in the blob.
        public let details: ATUnion.BlobViewDetailUnion

        /// The status of the subject.
        public let moderation: ToolsOzoneLexicon.Moderation.ModerationDefinition

        public init(cidHash: String, mimeType: String, size: Int, createdAt: Date, details: ATUnion.BlobViewDetailUnion,
                    moderation: ToolsOzoneLexicon.Moderation.ModerationDefinition) {
            self.cidHash = cidHash
            self.mimeType = mimeType
            self.size = size
            self.createdAt = createdAt
            self.details = details
            self.moderation = moderation
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.cidHash = try container.decode(String.self, forKey: .cidHash)
            self.mimeType = try container.decode(String.self, forKey: .mimeType)
            self.size = try container.decode(Int.self, forKey: .size)
            self.createdAt = try decodeDate(from: container, forKey: .createdAt)
            self.details = try container.decode(ATUnion.BlobViewDetailUnion.self, forKey: .details)
            self.moderation = try container.decode(ToolsOzoneLexicon.Moderation.ModerationDefinition.self, forKey: .moderation)
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.cidHash, forKey: .cidHash)
            try container.encode(self.mimeType, forKey: .mimeType)
            try container.encode(self.size, forKey: .size)
            try encodeDate(self.createdAt, with: &container, forKey: .createdAt)
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

    /// A definition model for details for an image.
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/defs.json
    public struct ImageDetailsDefinition: Sendable, Codable {

        /// The width of the image.
        public let width: Int

        /// The height of the image.
        public let height: Int
    }

    /// A definition model for details for a video.
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/defs.json
    public struct VideoDetailsDefinition: Sendable, Codable {

        /// The width of the video.
        public let width: Int

        /// The height of the video.
        public let height: Int

        /// The duration of the video.
        public let length: Int
    }
}
