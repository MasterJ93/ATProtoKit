//
//  OzoneModerationSearchRepos.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-01.
//

import Foundation

/// The output model definition for searching for repositories as an administrator or moderator.
///
/// - Note: According to the AT Protocol specifications: "Find repositories based on a
/// search term."
///
/// - SeeAlso: This is based on the [`tools.ozone.moderation.searchRepos`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/searchRepos.json
public struct ModerationSearchRepositoryOutput: Codable {
    /// The mark used to indicate the starting point for the next set of results. Optional.
    public let cursor: String?
    /// An array of repository views.
    public let repositories: [OzoneModerationRepositoryView]

    enum CodingKeys: String, CodingKey {
        case cursor
        case repositories = "repos"
    }
}
