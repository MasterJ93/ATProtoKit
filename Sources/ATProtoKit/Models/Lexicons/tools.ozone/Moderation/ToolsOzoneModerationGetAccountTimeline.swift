//
//  ToolsOzoneModerationGetAccountTimeline.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-09-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ToolsOzoneLexicon.Moderation {

    /// A definition model for retrieving the timeline of all available events for an account, including
    /// moderation events, account history, and decentralized identifier (DID) history.
    ///
    /// - Note: According to the AT Protocol specifications: "Get timeline of all available events of
    /// an account. This includes moderation events, account history and did history."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.getAccountTimeline`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/getAccountTimeline.json
    public struct GetAccountTimeline: Sendable, Codable {

        /// A data point of the account's timeline.
        ///
        /// - SeeAlso: This is based on the [`tools.ozone.moderation.getAccountTimeline`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/getAccountTimeline.json
        public struct TimelineItem: Sendable, Codable {

            /// The calendar date (UTC) this summary applies to.
            ///
            /// Formatted as an ISO 8601 date string (YYYY-MM-DD).
            public let day: String

            /// An array of summaries of the timeline item.
            public let summary: [TimelineItemSummary]
        }

        /// The summary of the timeline item.
        ///
        /// - SeeAlso: This is based on the [`tools.ozone.moderation.getAccountTimeline`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/getAccountTimeline.json
        public struct TimelineItemSummary: Sendable, Codable {

            /// The broad category of subject the events are about.
            public let eventSubjectType: EventSubjectType

            /// The specific event type represented in this summary bucket.
            public let eventType: EventType

            /// The number of events of this type and subject on the given day.
            public let count: Int

            // Enums
            /// The category of subject an event refers to.
            public enum EventSubjectType: String, Codable, Sendable {

                /// Events whose subject is an account.
                case account

                /// Events whose subject is a record.
                case record

                /// Events whose subject is a chat or messaging entity.
                case chat
            }

            /// The type of event for the timeline item.
            public enum EventType: String, Codable, Sendable {

                /// A takedown moderation event.
                case moderationEventTakedown = "tools.ozone.moderation.defs#modEventTakedown"

                /// A reverse takedown moderation event.
                case moderationEventReverseTakedown = "tools.ozone.moderation.defs#modEventReverseTakedown"

                /// A comment moderation event.
                case moderationEventComment = "tools.ozone.moderation.defs#modEventComment"

                /// A report moderation event.
                case moderationEventReport = "tools.ozone.moderation.defs#modEventReport"

                /// A label moderation event.
                case moderationEventLabel = "tools.ozone.moderation.defs#modEventLabel"

                /// An acknowledge moderation event.
                case moderationEventAcknowledge = "tools.ozone.moderation.defs#modEventAcknowledge"

                /// An escalate moderation event.
                case moderationEventEscalate = "tools.ozone.moderation.defs#modEventEscalate"

                /// A mute moderation event.
                case moderationEventMute = "tools.ozone.moderation.defs#modEventMute"

                /// A unmute moderation event.
                case moderationEventUnmute = "tools.ozone.moderation.defs#modEventUnmute"

                /// A mute reporter moderation event.
                case moderationEventMuteReporter = "tools.ozone.moderation.defs#modEventMuteReporter"

                /// An unmute reporter moderation event.
                case moderationEventUnmuteReporter = "tools.ozone.moderation.defs#modEventUnmuteReporter"

                /// An email moderation event.
                case moderationEventEmail = "tools.ozone.moderation.defs#modEventEmail"

                /// A resolve appeal moderation event.
                case moderationEventResolveAppeal = "tools.ozone.moderation.defs#modEventResolveAppeal"

                /// An divert moderation event.
                case moderationEventDivert = "tools.ozone.moderation.defs#modEventDivert"

                /// A tag moderation event.
                case moderationEventTag = "tools.ozone.moderation.defs#modEventTag"

                /// An account event.
                case accountEvent = "tools.ozone.moderation.defs#accountEvent"

                /// An identity event.
                case identityEvent = "tools.ozone.moderation.defs#identityEvent"

                /// A record event.
                case recordEvent = "tools.ozone.moderation.defs#recordEvent"

                /// A moderation priority score event.
                case moderationEventPriorityScore = "tools.ozone.moderation.defs#modEventPriorityScore"

                /// A revoke account credentials event.
                case revokeAccountCredentialsEvent = "tools.ozone.moderation.defs#revokeAccountCredentialsEvent"

                /// An age assurance event.
                case ageAssuranceEvent = "tools.ozone.moderation.defs#ageAssuranceEvent"

                /// An age assurance override event.
                case ageAssuranceOverrideEvent = "tools.ozone.moderation.defs#ageAssuranceOverrideEvent"

                /// A PLC create timeline event.
                case timelineEventPLCCreate = "tools.ozone.moderation.defs#timelineEventPlcCreate"

                /// A PLC operation timeline event.
                case timelineEventPLCOperation = "tools.ozone.moderation.defs#timelineEventPlcOperation"

                /// A PLC tombstone timeline event.
                case timelineEventPLCTombstone = "tools.ozone.moderation.defs#timelineEventPlcTombstone"

                /// An account created event.
                case accountCreated = "tools.ozone.hosting.getAccountHistory#accountCreated"

                /// An email confirmed event.
                case emailConfirmed = "tools.ozone.hosting.getAccountHistory#emailConfirmed"

                /// A password updated event.
                case passwordUpdated = "tools.ozone.hosting.getAccountHistory#passwordUpdated"

                /// A handle updated event.
                case handleUpdated = "tools.ozone.hosting.getAccountHistory#handleUpdated"
            }
        }
    }

    /// An output model for retrieving the timeline of all available events for an account, including
    /// moderation events, account history, and decentralized identifier (DID) history.
    ///
    /// - Note: According to the AT Protocol specifications: "Get timeline of all available events of
    /// an account. This includes moderation events, account history and did history."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.getAccountTimeline`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/getAccountTimeline.json
    public struct GetAccountTimelineOutput: Sendable, Codable {

        /// An array of items in the account's timeline.
        public let timeline: [ToolsOzoneLexicon.Moderation.GetAccountTimeline.TimelineItem]
    }
}

