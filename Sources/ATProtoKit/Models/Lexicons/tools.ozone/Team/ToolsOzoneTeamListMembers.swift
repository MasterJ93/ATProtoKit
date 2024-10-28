//
//  ToolsOzoneTeamListMembers.swift
//
//
//  Created by Christopher Jr Riley on 2024-06-29.
//

import Foundation

extension ToolsOzoneLexicon.Team {

    /// An output model for listing members.
    ///
    /// - Note: According to the AT Protocol specifications: "List all members with access to the
    /// ozone service."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.team.listMembers`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/team/listMembers.json
    public struct ListMembersOutput: Sendable, Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of members.
        public let members: [MemberDefinition]
    }
}
