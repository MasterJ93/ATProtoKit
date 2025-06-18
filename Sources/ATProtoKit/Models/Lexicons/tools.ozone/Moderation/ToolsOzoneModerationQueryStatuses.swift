//
//  ToolsOzoneModerationQueryStatuses.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-21.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ToolsOzoneLexicon.Moderation {

    /// The main data model definition for listing all moderation events pertaining a subject.
    public struct QueryStatuses: Sendable, Codable {

        /// Indicates the sorting field for the moderation status array.
        public enum SortField: Sendable, Codable {

            /// Indicates the moderation status array will be sorted by the last reported user.
            case lastReportedAt

            /// Indicates the moderation status array will be sorted by the last reviwed user.
            case lastReviewedAt

            /// Indicates the moderation status array will be sorted by the number of
            /// reported records.
            case reportedRecordsCount

            /// Indicates the moderation status array will be sorted by the number of
            /// takedown records.
            case takendownRecordsCount

            /// Indicates the moderation status array will be sorted by the priority score.
            case priorityScore
        }

        public enum SortDirection: String, Sendable, Codable {

            /// Indicates the moderation events will be sorted in ascending order.
            case ascending = "asc"

            /// Indicates the moderation events will be sorted in descending order.
            case descending = "desc"
        }

        /// The main data model definition for the specified subject type for the event.
        public enum SubjectType: String {

            /// Indicates the subject type is an account.
            case account

            /// Indicates the subject type is a record.
            case record
        }
    }

    /// An output model for listing all moderation events pertaining a subject.
    ///
    /// - Note: According to the AT Protocol specifications: "View moderation statuses of subjects
    /// (record or repo)."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.queryStatuses`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/queryStatuses.json
    public struct QueryStatusesOutput: Sendable, Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of subject status views.
        public let subjectStatuses: [ToolsOzoneLexicon.Moderation.SubjectStatusViewDefinition]
    }
}
