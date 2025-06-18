//
//  ToolsOzoneModerationSearchRepos.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-21.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ToolsOzoneLexicon.Moderation {

    /// An output model for searching for repositories as an administrator or moderator.
    ///
    /// - Note: According to the AT Protocol specifications: "Find repositories based on a
    /// search term."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.searchRepos`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/searchRepos.json
    public struct SearchRepositoryOutput: Sendable, Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of repository views.
        public let repositories: [ToolsOzoneLexicon.Moderation.RepositoryViewDefinition]

        enum CodingKeys: String, CodingKey {
            case cursor
            case repositories = "repos"
        }
    }
}
