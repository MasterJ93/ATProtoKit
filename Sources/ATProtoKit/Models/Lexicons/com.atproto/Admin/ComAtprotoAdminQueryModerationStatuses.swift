//
//  ComAtprotoAdminQueryModerationStatuses.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation

extension ComAtprotoLexicon.Admin {

    /// A data model definition for the output of listing all of moderation statuses of records
    /// and repositories.
    ///
    /// - Note: According to the AT Protocol specifications: "View moderation statuses of
    /// subjects (record or repo)."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.admin.queryModerationStatuses`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/queryModerationStatuses.json
    public struct QueryModerationStatusesOutput: Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String

        /// An array of subject statuses.
        public let subjectStatuses: [OzoneSubjectStatusView]
    }

    /// Indicates the sorting field for the moderation status array.
    public enum AdminQueryModerationStatusesSortField {

        /// Indicates the moderation status array will be sorted by the last reported user.
        case lastReportedAt

        /// Indicates the moderation status array will be sorted by the last reviwed user.
        case lastReviewedAt
    }

    /// Indicates the sorting direction for the array of moderation statuses.
    public enum QueryModerationStatusesSortDirection: String {

        /// Indicates the moderation events will be sorted in ascending order.
        case ascending = "asc"

        /// Indicates the moderation events will be sorted in descending order.
        case descending = "desc"
    }
}
