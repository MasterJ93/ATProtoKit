//
//  ToolsOzoneTeamAddMember.swift
//
//
//  Created by Christopher Jr Riley on 2024-06-29.
//

import Foundation

extension ToolsOzoneLexicon.Team {

    /// A request body model for adding a member as an administrator.
    ///
    /// - Note: According to the AT Protocol specifications: "Add a member to the ozone team.
    /// Requires admin role."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.team.addMember`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/team/addMember.json
    public struct AddMemberRequestBody: Sendable, Codable {

        /// The decentralized identifier (DID) of the member.
        public let memberDID: String

        /// The role that the member will be assigned to.
        public let role: MemberDefinition.Role

        enum CodingKeys: String, CodingKey {
            case memberDID = "did"
            case role
        }
    }
}
