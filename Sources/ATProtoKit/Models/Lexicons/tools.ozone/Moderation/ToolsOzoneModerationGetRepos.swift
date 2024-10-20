//
//  ToolsOzoneModerationGetRepos.swift
//
//  Created by Christopher Jr Riley on 2024-10-19.
//

import Foundation
import ATMacro

extension ToolsOzoneLexicon.Moderation {

    /// An output model for getting an array of repositories as a moderator.
    ///
    /// - Note: According to the AT Protocol specifications: "Get details about some repositories."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.getRepos`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/getRepos.json
    public struct GetRepositoriesOutput: Codable {

        /// An array of repositories.
        public let repositories: [String]

        enum CodingKeys: String, CodingKey {
            case repositories = "repos"
        }
    }
}

extension ATUnion {
    #ATUnionBuilder(named: "ModerationGetRepositoriesOutputUnion", containing: [
        "repoViewDetail" : "ToolsOzoneLexicon.Moderation.RepositoryViewDetailDefinition",
        "repoViewNotFound" : "ToolsOzoneLexicon.Moderation.RepositoryViewNotFoundDefinition"
    ])
}
