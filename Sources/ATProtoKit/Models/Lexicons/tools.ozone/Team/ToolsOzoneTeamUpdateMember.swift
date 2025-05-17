//
//  ToolsOzoneTeamUpdateMember.swift
//
//
//  Created by Christopher Jr Riley on 2024-06-29.
//

import Foundation

extension ToolsOzoneLexicon.Team {

    /// The main data model definition for updating a member.
    ///
    /// - Note: According to the AT Protocol specifications: "Update a member in the ozone service.
    /// Requires admin role."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.team.updateMember`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/team/updateMember.json
    public struct UpdateMember: Sendable, Codable {

        /// The manager role of the option.
        public enum Role: String, Sendable, Codable {

            /// A role that allows the member to access actions related to ensuring that rules are
            /// maintained in the service.
            case moderator = "tools.ozone.team.defs#roleModerator"

            /// A role that allows the member to access actions related to monitoring and
            /// escalating issues.
            case triage = "tools.ozone.team.defs#roleTriage"

            /// A role that allows the member to have nearly full access of the systems.
            case admin = "tools.ozone.team.defs#roleAdmin"

            /// A role that allows the member to verify user accounts.
            case verifier = "tools.ozone.team.defs#roleVerifier"
        }
    }

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
        public let role: UpdateMember.Role?


        enum CodingKeys: String, CodingKey {
            case memberDID = "did"
            case isDisabled = "disabled"
            case role
        }
    }
}
