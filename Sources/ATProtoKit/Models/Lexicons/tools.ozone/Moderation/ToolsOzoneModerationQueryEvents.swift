//
//  ToolsOzoneModerationQueryEvents.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-21.
//

import Foundation

extension ToolsOzoneLexicon.Moderation {

    /// The main data model definition for listing all moderation events pertaining a subject.
    ///
    /// - Note: According to the AT Protocol specifications: "List moderation events related
    /// to a subject."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.queryEvents`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/queryEvents.json
    public struct EventsOutput: Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of moderator events.
        public let events: [OzoneModerationEventView]
    }

    /// Indicates the sorting direction for the array of moderation events.
    public enum AdminQueryModerationEventSortDirection: String {

        /// Indicates the moderation events will be sorted in ascending order.
        case ascending = "asc"

        /// Indicates the moderation events will be sorted in descending order.
        case descending = "desc"
    }
}
