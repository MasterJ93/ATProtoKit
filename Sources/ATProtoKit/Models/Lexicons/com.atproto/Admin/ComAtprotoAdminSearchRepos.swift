//
//  ComAtprotoAdminSearchRepos.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ComAtprotoLexicon.Admin {

    /// An output model for searching repositories.
    ///
    /// - Note: According to the AT Protocol specifications: "Find repositories based on a
    /// search term."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.admin.searchRepos`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/searchRepos.json
    public struct SearchRepositoriesOutput: Sendable, Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of repositories.
        public let repositories: ToolsOzoneLexicon.Moderation.RepositoryViewDefinition

        enum CodingKeys: String, CodingKey {
            case cursor
            case repositories = "repos"
        }
    }
}
