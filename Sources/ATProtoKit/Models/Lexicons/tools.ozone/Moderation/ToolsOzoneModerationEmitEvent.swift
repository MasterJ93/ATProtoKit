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
        public enum EmitEventUnion: ATUnionProtocol {

            /// A takedown event.
            case moderationEventTakedown(ToolsOzoneLexicon.Moderation.EventTakedownDefinition)

            /// An acknowledgement event.
            case moderationEventAcknowledge(ToolsOzoneLexicon.Moderation.EventAcknowledgeDefinition)

            /// An escalation event.
            case moderationEventEscalate(ToolsOzoneLexicon.Moderation.EventEscalateDefinition)

            /// A comment event.
            case moderationEventComment(ToolsOzoneLexicon.Moderation.EventCommentDefinition)

            /// A label event.
            case moderationEventLabel(ToolsOzoneLexicon.Moderation.EventLabelDefinition)

            /// A report event.
            case moderationEventReport(ToolsOzoneLexicon.Moderation.EventReportDefinition)

            /// A mute event.
            case moderationEventMute(ToolsOzoneLexicon.Moderation.EventMuteDefinition)

            /// An unmute event.
            case moderationEventUnmute(ToolsOzoneLexicon.Moderation.EventUnmuteDefinition)

            /// A mute reporter event.
            case moderationEventMuteReporter(ToolsOzoneLexicon.Moderation.EventMuteReporterDefinition)

            /// An unmute reporter event.
            case moderationEventUnmuteReporter(ToolsOzoneLexicon.Moderation.EventUnmuteReporterDefinition)

            /// A reverse takedown event.
            case moderationEventReverseTakedown(ToolsOzoneLexicon.Moderation.EventReverseTakedownDefinition)

            /// A resolve appeal event.
            case moderationEventResolveAppeal(ToolsOzoneLexicon.Moderation.EventResolveAppealDefinition)

            /// An email event.
            case moderationEventEmail(ToolsOzoneLexicon.Moderation.EventEmailDefinition)

            /// A divert event.
            case moderationEventDivert(ToolsOzoneLexicon.Moderation.EventDivertDefinition)

            /// A tag event.
            case moderationEventTag(ToolsOzoneLexicon.Moderation.EventTagDefinition)

            /// An account event.
            case moderationAccountEvent(ToolsOzoneLexicon.Moderation.AccountEventDefinition)

            /// An identity event.
            case moderationIdentityEvent(ToolsOzoneLexicon.Moderation.IdentityEventDefinition)

            /// A record event.
            case moderationRecordEvent(ToolsOzoneLexicon.Moderation.RecordEventDefinition)

            /// A priority score event.
            case moderationPriorityScoreEvent(ToolsOzoneLexicon.Moderation.EventPriorityScoreDefinition)

            /// An age assurance event.
            case ageAssuranceEvent(ToolsOzoneLexicon.Moderation.AgeAssuranceEventDefinition)

            /// An age assurance override event.
            case ageAssuranceOverrideEvent(ToolsOzoneLexicon.Moderation.AgeAssuranceOverrideEventDefinition)

            /// A revoke account credentials event.
            case revokeAccountCredentialsEvent(ToolsOzoneLexicon.Moderation.RevokeAccountCredentialsEventDefinition)

            /// An unknown case.
            case unknown(String, [String: CodableValue])

            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let type = try container.decodeIfPresent(String.self, forKey: .type)

                switch type {
                    case "tools.ozone.moderation.defs#modEventTakedown":
                        self = .moderationEventTakedown(try ToolsOzoneLexicon.Moderation.EventTakedownDefinition(from: decoder))
                    case "tools.ozone.moderation.defs#modEventAcknowledge":
                        self = .moderationEventAcknowledge(try ToolsOzoneLexicon.Moderation.EventAcknowledgeDefinition(from: decoder))
                    case "tools.ozone.moderation.defs#modEventEscalate":
                        self = .moderationEventEscalate(try ToolsOzoneLexicon.Moderation.EventEscalateDefinition(from: decoder))
                    case "tools.ozone.moderation.defs#modEventComment":
                        self = .moderationEventComment(try ToolsOzoneLexicon.Moderation.EventCommentDefinition(from: decoder))
                    case "tools.ozone.moderation.defs#modEventLabel":
                        self = .moderationEventLabel(try ToolsOzoneLexicon.Moderation.EventLabelDefinition(from: decoder))
                    case "tools.ozone.moderation.defs#modEventReport":
                        self = .moderationEventReport(try ToolsOzoneLexicon.Moderation.EventReportDefinition(from: decoder))
                    case "tools.ozone.moderation.defs#modEventMute":
                        self = .moderationEventMute(try ToolsOzoneLexicon.Moderation.EventMuteDefinition(from: decoder))
                    case "tools.ozone.moderation.defs#modEventUnmute":
                        self = .moderationEventUnmute(try ToolsOzoneLexicon.Moderation.EventUnmuteDefinition(from: decoder))
                    case "tools.ozone.moderation.defs#modEventMuteReporter":
                        self = .moderationEventMuteReporter(try ToolsOzoneLexicon.Moderation.EventMuteReporterDefinition(from: decoder))
                    case "tools.ozone.moderation.defs#modEventUnmuteReporter":
                        self = .moderationEventUnmuteReporter(try ToolsOzoneLexicon.Moderation.EventUnmuteReporterDefinition(from: decoder))
                    case "tools.ozone.moderation.defs#modEventReverseTakedown":
                        self = .moderationEventReverseTakedown(try ToolsOzoneLexicon.Moderation.EventReverseTakedownDefinition(from: decoder))
                    case "tools.ozone.moderation.defs#modEventResolveAppeal":
                        self = .moderationEventResolveAppeal(try ToolsOzoneLexicon.Moderation.EventResolveAppealDefinition(from: decoder))
                    case "tools.ozone.moderation.defs#modEventEmail":
                        self = .moderationEventEmail(try ToolsOzoneLexicon.Moderation.EventEmailDefinition(from: decoder))
                    case "tools.ozone.moderation.defs#modEventDivert":
                        self = .moderationEventDivert(try ToolsOzoneLexicon.Moderation.EventDivertDefinition(from: decoder))
                    case "tools.ozone.moderation.defs#modEventTag":
                        self = .moderationEventTag(try ToolsOzoneLexicon.Moderation.EventTagDefinition(from: decoder))
                    case "tools.ozone.moderation.defs#accountEvent":
                        self = .moderationAccountEvent(try ToolsOzoneLexicon.Moderation.AccountEventDefinition(from: decoder))
                    case "tools.ozone.moderation.defs#identityEvent":
                        self = .moderationIdentityEvent(try ToolsOzoneLexicon.Moderation.IdentityEventDefinition(from: decoder))
                    case "tools.ozone.moderation.defs#recordEvent":
                        self = .moderationRecordEvent(try ToolsOzoneLexicon.Moderation.RecordEventDefinition(from: decoder))
                    case "tools.ozone.moderation.defs#modEventPriorityScore":
                        self = .moderationPriorityScoreEvent(try ToolsOzoneLexicon.Moderation.EventPriorityScoreDefinition(from: decoder))
                    case "tools.ozone.moderation.defs#ageAssuranceEvent":
                        self = .ageAssuranceEvent(try ToolsOzoneLexicon.Moderation.AgeAssuranceEventDefinition(from: decoder))
                    case "tools.ozone.moderation.defs#ageAssuranceOverrideEvent":
                        self = .ageAssuranceOverrideEvent(try ToolsOzoneLexicon.Moderation.AgeAssuranceOverrideEventDefinition(from: decoder))
                    case "tools.ozone.moderation.defs#revokeAccountCredentialsEvent":
                        self = .revokeAccountCredentialsEvent(try ToolsOzoneLexicon.Moderation.RevokeAccountCredentialsEventDefinition(from: decoder))
                    default:
                        let singleValueDecodingContainer = try decoder.singleValueContainer()
                        let dictionary = try Self.decodeDictionary(from: singleValueDecodingContainer, decoder: decoder)

                        self = .unknown(type ?? "unknown", dictionary)
                }
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()

                switch self {
                    case .moderationEventTakedown(let value):
                        try container.encode(value)
                    case .moderationEventReverseTakedown(let value):
                        try container.encode(value)
                    case .moderationEventComment(let value):
                        try container.encode(value)
                    case .moderationEventReport(let value):
                        try container.encode(value)
                    case .moderationEventLabel(let value):
                        try container.encode(value)
                    case .moderationEventAcknowledge(let value):
                        try container.encode(value)
                    case .moderationEventEscalate(let value):
                        try container.encode(value)
                    case .moderationEventMute(let value):
                        try container.encode(value)
                    case .moderationEventUnmute(let value):
                        try container.encode(value)
                    case .moderationEventMuteReporter(let value):
                        try container.encode(value)
                    case .moderationEventUnmuteReporter(let value):
                        try container.encode(value)
                    case .moderationEventEmail(let value):
                        try container.encode(value)
                    case .moderationEventDivert(let value):
                        try container.encode(value)
                    case .moderationEventResolveAppeal(let value):
                        try container.encode(value)
                    case .moderationEventTag(let value):
                        try container.encode(value)
                    case .moderationAccountEvent(let value):
                        try container.encode(value)
                    case .moderationIdentityEvent(let value):
                        try container.encode(value)
                    case .moderationRecordEvent(let value):
                        try container.encode(value)
                    default:
                        break
                }
            }

            enum CodingKeys: String, CodingKey {
                case type = "$type"
            }
        }

        public enum EmitEventSubjectUnion: ATUnionProtocol {

            /// A repository reference.
            case repositoryReference(ComAtprotoLexicon.Admin.RepositoryReferenceDefinition)

            /// A strong reference.
            case strongReference(ComAtprotoLexicon.Repository.StrongReference)

            /// An unknown case.
            case unknown(String, [String: CodableValue])

            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let type = try container.decodeIfPresent(String.self, forKey: .type)

                switch type {
                    case "com.atproto.admin.defs#repoRef":
                        self = .repositoryReference(try ComAtprotoLexicon.Admin.RepositoryReferenceDefinition(from: decoder))
                    case "com.atproto.repo.strongRef":
                        self = .strongReference(try ComAtprotoLexicon.Repository.StrongReference(from: decoder))
                    default:
                        let singleValueDecodingContainer = try decoder.singleValueContainer()
                        let dictionary = try Self.decodeDictionary(from: singleValueDecodingContainer, decoder: decoder)

                        self = .unknown(type ?? "unknown", dictionary)
                }
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()

                switch self {
                    case .repositoryReference(let repositoryReference):
                        try container.encode(repositoryReference)
                    case .strongReference(let strongReference):
                        try container.encode(strongReference)
                    default:
                        break
                }
            }

            enum CodingKeys: String, CodingKey {
                case type = "$type"
            }
        }
    }
}
