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
    public struct GetRepositoriesOutput: Sendable, Codable {

        /// An array of repositories.
        public let repositories: [String]

        enum CodingKeys: String, CodingKey {
            case repositories = "repos"
        }

        // Unions
        ///
        public enum ModerationGetRepositoriesOutputUnion: Codable, Sendable {

            ///
            case repoViewDetail(ToolsOzoneLexicon.Moderation.RepositoryViewDetailDefinition)

            ///
            case repoViewNotFound(ToolsOzoneLexicon.Moderation.RepositoryViewNotFoundDefinition)

            public init(from decoder: Decoder) throws {
                let container = try decoder.singleValueContainer()
                if let value = try? container.decode(ToolsOzoneLexicon.Moderation.RepositoryViewDetailDefinition.self) {
                    self = .repoViewDetail(value)
                } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.RepositoryViewNotFoundDefinition.self) {
                    self = .repoViewNotFound(value)
                } else {
                    throw DecodingError.typeMismatch(
                        ModerationGetRepositoriesOutputUnion.self, DecodingError.Context(
                            codingPath: decoder.codingPath, debugDescription: "Unknown ModerationGetRepositoriesOutputUnion type"))
                }
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()
                switch self {
                    case .repoViewDetail(let unionValue):
                        try container.encode(unionValue)
                    case .repoViewNotFound(let unionValue):
                        try container.encode(unionValue)
                }
            }
        }
    }
}
