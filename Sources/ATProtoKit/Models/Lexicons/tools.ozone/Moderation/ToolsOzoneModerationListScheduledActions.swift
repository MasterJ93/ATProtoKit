//
//  ToolsOzoneModerationListScheduledActions.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-11-18.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ToolsOzoneLexicon.Moderation {

    /// A definition model for displaying a list of scheduled moderation actions.
    ///
    /// - Note: According to the AT Protocol specifications: "scheduled moderation actions with
    /// optional filtering."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.listScheduledActions`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/listScheduledActions.json
    public struct ListScheduledActions: Sendable, Codable {

        /// A status to filter into.
        public enum Statuses: String, Sendable, Codable {

            /// Filter to "pending."
            case pending

            /// Filter to "executed."
            case executed

            /// Filter to "cancelled."
            case cancelled

            /// Filter to "failed."
            case failed
        }
    }

    /// A request body model for displaying a list of scheduled moderation actions.
    ///
    /// - Note: According to the AT Protocol specifications: "scheduled moderation actions with
    /// optional filtering."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.listScheduledActions`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/listScheduledActions.json
    public struct ListScheduledActionsRequestBody: Sendable, Codable {

        /// The date and time the filter begins. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Filter actions scheduled to execute after
        /// this time."
        public let startsAfter: Date?

        /// The date and time the filter ends. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Filter actions scheduled to execute after
        /// this time."
        public let endsBefore: Date?

        /// An array of decentalized identifiers (DIDs) to look for scheduled moderation actions. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Filter actions for specific DID subjects."
        public let subjects: [String]?

        /// An array of statuses to filter into.
        ///
        /// - Note: According to the AT Protocol specifications: "Filter actions by status."
        public let statuses: [ToolsOzoneLexicon.Moderation.ScheduledActionViewDefinition.Status]

        /// A limit to the number of results displayed. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Maximum number of results to return."
        public let limit: Int?

        /// The mark used to indicate the starting point for the next set of results. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Cursor for pagination."
        public let cursor: String?

        public init(
            startsAfter: Date?,
            endsBefore: Date?,
            subjects: [String]?,
            statuses: [ToolsOzoneLexicon.Moderation.ScheduledActionViewDefinition.Status],
            limit: Int?,
            cursor: String?
        ) {
            self.startsAfter = startsAfter
            self.endsBefore = endsBefore
            self.subjects = subjects
            self.statuses = statuses
            self.limit = limit
            self.cursor = cursor
        }

//        init(from decoder: any Decoder) throws {
//            let container: KeyedDecodingContainer<ToolsOzoneLexicon.Moderation.ListScheduledActionsRequestBody.CodingKeys> = try decoder.container(
//                keyedBy: ToolsOzoneLexicon.Moderation.ListScheduledActionsRequestBody.CodingKeys.self
//            )
//            self.startsAfter = try container
//                .decodeIfPresent(Date.self, forKey: ToolsOzoneLexicon.Moderation.ListScheduledActionsRequestBody.CodingKeys.startsAfter)
//            self.endsBefore = try container
//                .decodeIfPresent(Date.self, forKey: ToolsOzoneLexicon.Moderation.ListScheduledActionsRequestBody.CodingKeys.endsBefore)
//            self.subjects = try container
//                .decodeIfPresent([String].self, forKey: ToolsOzoneLexicon.Moderation.ListScheduledActionsRequestBody.CodingKeys.subjects)
//            self.statuses = try container
//                .decode(
//                    [ToolsOzoneLexicon.Moderation.ScheduledActionViewDefinition.Status].self,
//                    forKey: ToolsOzoneLexicon.Moderation.ListScheduledActionsRequestBody.CodingKeys.statuses
//                )
//            self.limit = try container.decodeIfPresent(Int.self, forKey: ToolsOzoneLexicon.Moderation.ListScheduledActionsRequestBody.CodingKeys.limit)
//            self.cursor = try container.decodeIfPresent(String.self, forKey: ToolsOzoneLexicon.Moderation.ListScheduledActionsRequestBody.CodingKeys.cursor)
//        }
    }

    /// An output model for displaying a list of scheduled moderation actions.
    ///
    /// - Note: According to the AT Protocol specifications: "scheduled moderation actions with
    /// optional filtering."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.listScheduledActions`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/listScheduledActions.json
    public struct ListScheduledActionsOutput: Sendable, Codable {

        ///
        public let actions: [ToolsOzoneLexicon.Moderation.ScheduledActionViewDefinition]

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?
    }
}
