//
//  ToolsOzoneModerationQueryStatuses.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-21.
//

import Foundation

extension ToolsOzoneLexicon.Moderation {

    /// An output model for listing all moderation events pertaining a subject.
    ///
    /// - Note: According to the AT Protocol specifications: "View moderation statuses of subjects
    /// (record or repo)."
    ///
    /// - SeeAlso: This is based on the [`ools.ozone.moderation.queryStatuses`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/queryEvents.json
    public struct QueryStatusesOutput: Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of subject status views.
        public let subjectStatuses: [ToolsOzoneLexicon.Moderation.SubjectStatusViewDefinition]
    }
}
