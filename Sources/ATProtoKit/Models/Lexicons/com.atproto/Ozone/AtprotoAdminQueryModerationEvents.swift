//
//  AtprotoAdminQueryModerationEvents.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-01.
//

import Foundation

/// The main data model definition for listing all moderation events pertaining a subject.
///
/// - Note: According to the AT Protocol specifications: "List moderation events related to a subject."
///
/// - SeeAlso: This is based on the [`com.atproto.admin.queryModerationEvents`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/queryModerationEvents.json
public struct AdminQueryModerationEventOutput: Codable {
    /// The mark used to indicate the starting point for the next set of results. Optional.
    public let cursor: String?
    /// An array of moderator events.
    public let events: [AdminModEventView]
}

/// Indicates the sorting direction for the array of moderation events.
public enum AdminQueryModerationEventSortDirection: String {
    /// Indicates the moderation events will be sorted in ascending order.
    case ascending = "asc"
    /// Indicates the moderation events will be sorted in descending order.
    case descending = "desc"
}
