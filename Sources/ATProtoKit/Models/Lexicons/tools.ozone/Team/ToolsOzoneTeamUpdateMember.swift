//
//  ToolsOzoneTeamUpdateMember.swift
//
//
//  Created by Christopher Jr Riley on 2024-06-29.
//

import Foundation

extension ToolsOzoneLexicon.Team {

    /// A request body model for updating a member.
    ///
    /// - Note: According to the AT Protocol specifications: "Update a member in the ozone service.
    /// Requires admin role."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.team.updateMember`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/team/updateMember.json
    public struct UpdateMemberRequestBody: Sendable, Codable {

        /// The decentralized identifier (DID) of the member.
        public let memberDID: String

        /// Indicates whether the member is disabled. Optional.
        public let isDisabled: Bool?

        /// The current role that was given to the member. Optional.
        public let role: MemberDefinition.Role?


        enum CodingKeys: String, CodingKey {
            case memberDID = "did"
            case isDisabled = "disabled"
            case role
        }
    }
}
