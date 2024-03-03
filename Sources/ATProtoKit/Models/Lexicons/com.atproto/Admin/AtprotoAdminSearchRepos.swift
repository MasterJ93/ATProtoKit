//
//  AtprotoAdminSearchRepos.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-02.
//

import Foundation

/// The main data model definition for the output of searching repositories.
///
/// - Note: According to the AT Protocol specifications: "Find repositories based on a search term."
///
/// - SeeAlso: This is based on the [`com.atproto.admin.searchRepos`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/searchRepos.json
public struct AdminSearchReposOutput: Codable {
    /// The mark used to indicate the starting point for the next set of results. Optional.
    public let cursor: String?
    /// An array of repositories.
    public let repos: AdminRepoView
}
