//
//  ToolsOzoneModerationEmitEvent.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-21.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ToolsOzoneLexicon.Moderation {

    /// A request body model for enacting on an action against a user's account.
    ///
    /// - Note: According to the AT Protocol specifications: "Take a moderation action on an actor."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.emitEvent`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/emitEvent.json
    public struct EmitEventRequestBody: Sendable, Codable {

        /// The type of event the moderator is taking,
        public let event: EmitEventUnion

        /// The type of repository reference.
        public let subject: EmitEventSubjectUnion

        /// An array of CID hashes related to blobs for the moderator's event view. Optional.
        public let subjectBlobCIDs: [String]?

        /// The decentralized identifier (DID) of the moderator taking this action.
        public let createdBy: String

        /// The moderation tool related to the event. Optional.
        public let moderationTool: ToolsOzoneLexicon.Moderation.ModToolDefinition?

        /// An identifier used for deduplicating events from external systems. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "An optional external ID for the event,
        /// used to deduplicate events from external systems. Fails when an event of same type with the same
        /// external ID exists for the same subject."
        public let externalID: String?

        enum CodingKeys: String, CodingKey {
            case event
            case subject
            case subjectBlobCIDs = "subjectBlobCids"
            case createdBy
            case moderationTool = "modTool"
            case externalID = "externalId"
        }

        // Unions
        /// 
        public enum EmitEventUnion: Sendable, Codable {

            /// A takedown event.
            case moderationEventTakedown(ToolsOzoneLexicon.Moderation.EventTakedownDefinition)

            /// A reverse takedown event.
            case moderationEventReverseTakedown(ToolsOzoneLexicon.Moderation.EventReverseTakedownDefinition)

            /// A comment event.
            case moderationEventComment(ToolsOzoneLexicon.Moderation.EventCommentDefinition)

            /// A report event.
            case moderationEventReport(ToolsOzoneLexicon.Moderation.EventReportDefinition)

            /// A label event.
            case moderationEventLabel(ToolsOzoneLexicon.Moderation.EventLabelDefinition)

            /// An acknowledgement event.
            case moderationEventAcknowledge(ToolsOzoneLexicon.Moderation.EventAcknowledgeDefinition)

            /// An escalation event.
            case moderationEventEscalate(ToolsOzoneLexicon.Moderation.EventEscalateDefinition)

            /// A mute event.
            case moderationEventMute(ToolsOzoneLexicon.Moderation.EventMuteDefinition)

            /// An unmute event.
            case moderationEventUnmute(ToolsOzoneLexicon.Moderation.EventUnmuteDefinition)

            /// A mute reporter event.
            case moderationEventMuteReporter(ToolsOzoneLexicon.Moderation.EventMuteReporterDefinition)

            /// An unmute reporter event.
            case moderationEventUnmuteReporter(ToolsOzoneLexicon.Moderation.EventUnmuteReporterDefinition)

            /// An email event.
            case moderationEventEmail(ToolsOzoneLexicon.Moderation.EventEmailDefinition)

            /// A divert event.
            case moderationEventDivert(ToolsOzoneLexicon.Moderation.EventDivertDefinition)

            /// A resolve appeal event.
            case moderationEventResolveAppeal(ToolsOzoneLexicon.Moderation.EventResolveAppealDefinition)

            /// A diversion event.
            case moderationEventTag(ToolsOzoneLexicon.Moderation.EventTagDefinition)

            /// An account event.
            case moderationAccountEvent(ToolsOzoneLexicon.Moderation.AccountEventDefinition)

            /// An identity event.
            case moderationIdentityEvent(ToolsOzoneLexicon.Moderation.IdentityEventDefinition)

            /// A record event.
            case moderationRecordEvent(ToolsOzoneLexicon.Moderation.RecordEventDefinition)

            public init(from decoder: Decoder) throws {
                let container = try decoder.singleValueContainer()

                if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventTakedownDefinition.self) {
                    self = .moderationEventTakedown(value)
                } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventReverseTakedownDefinition.self) {
                    self = .moderationEventReverseTakedown(value)
                } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventCommentDefinition.self) {
                    self = .moderationEventComment(value)
                } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventReportDefinition.self) {
                    self = .moderationEventReport(value)
                } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventLabelDefinition.self) {
                    self = .moderationEventLabel(value)
                } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventAcknowledgeDefinition.self) {
                    self = .moderationEventAcknowledge(value)
                } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventEscalateDefinition.self) {
                    self = .moderationEventEscalate(value)
                } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventMuteDefinition.self) {
                    self = .moderationEventMute(value)
                } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventUnmuteDefinition.self) {
                    self = .moderationEventUnmute(value)
                } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventMuteReporterDefinition.self) {
                    self = .moderationEventMuteReporter(value)
                } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventUnmuteReporterDefinition.self) {
                    self = .moderationEventUnmuteReporter(value)
                } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventEmailDefinition.self) {
                    self = .moderationEventEmail(value)
                } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventDivertDefinition.self) {
                    self = .moderationEventDivert(value)
                } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventResolveAppealDefinition.self) {
                    self = .moderationEventResolveAppeal(value)
                } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventTagDefinition.self) {
                    self = .moderationEventTag(value)
                } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.AccountEventDefinition.self) {
                    self = .moderationAccountEvent(value)
                } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.IdentityEventDefinition.self) {
                    self = .moderationIdentityEvent(value)
                } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.RecordEventDefinition.self) {
                    self = .moderationRecordEvent(value)
                } else {
                    throw DecodingError.typeMismatch(
                        EmitEventUnion.self, DecodingError.Context(
                            codingPath: decoder.codingPath, debugDescription: "Unknown EmitEventUnion type"))
                }
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()

                switch self {
                    case .moderationEventTakedown(let moderationEventTakedown):
                        try container.encode(moderationEventTakedown)
                    case .moderationEventReverseTakedown(let moderationEventReverseTakedown):
                        try container.encode(moderationEventReverseTakedown)
                    case .moderationEventComment(let moderationEventComment):
                        try container.encode(moderationEventComment)
                    case .moderationEventReport(let moderationEventReport):
                        try container.encode(moderationEventReport)
                    case .moderationEventLabel(let moderationEventLabel):
                        try container.encode(moderationEventLabel)
                    case .moderationEventAcknowledge(let moderationEventAcknowledge):
                        try container.encode(moderationEventAcknowledge)
                    case .moderationEventEscalate(let moderationEventEscalate):
                        try container.encode(moderationEventEscalate)
                    case .moderationEventMute(let moderationEventMute):
                        try container.encode(moderationEventMute)
                    case .moderationEventUnmute(let moderationEventUnmute):
                        try container.encode(moderationEventUnmute)
                    case .moderationEventMuteReporter(let moderationEventMuteReporter):
                        try container.encode(moderationEventMuteReporter)
                    case .moderationEventUnmuteReporter(let moderationEventUnmuteReporter):
                        try container.encode(moderationEventUnmuteReporter)
                    case .moderationEventEmail(let moderationEventEmail):
                        try container.encode(moderationEventEmail)
                    case .moderationEventDivert(let moderationEventDivert):
                        try container.encode(moderationEventDivert)
                    case .moderationEventResolveAppeal(let moderationEventResolveAppeal):
                        try container.encode(moderationEventResolveAppeal)
                    case .moderationEventTag(let value):
                        try container.encode(value)
                    case .moderationAccountEvent(let value):
                        try container.encode(value)
                    case .moderationIdentityEvent(let value):
                        try container.encode(value)
                    case .moderationRecordEvent(let value):
                        try container.encode(value)
                }
            }
        }

        public enum EmitEventSubjectUnion: Sendable, Codable {

            /// A repository reference.
            case repositoryReference(ComAtprotoLexicon.Admin.RepositoryReferenceDefinition)

            /// A strong reference.
            case strongReference(ComAtprotoLexicon.Repository.StrongReference)

            public init(from decoder: Decoder) throws {
                let container = try decoder.singleValueContainer()

                if let value = try? container.decode(ComAtprotoLexicon.Admin.RepositoryReferenceDefinition.self) {
                    self = .repositoryReference(value)
                } else if let value = try? container.decode(ComAtprotoLexicon.Repository.StrongReference.self) {
                    self = .strongReference(value)
                } else {
                    throw DecodingError.typeMismatch(
                        EmitEventSubjectUnion.self, DecodingError.Context(
                            codingPath: decoder.codingPath, debugDescription: "Unknown EmitEventSubjectUnion type"))
                }
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()

                switch self {
                    case .repositoryReference(let repositoryReference):
                        try container.encode(repositoryReference)
                    case .strongReference(let strongReference):
                        try container.encode(strongReference)
                }
            }
        }
    }
}
