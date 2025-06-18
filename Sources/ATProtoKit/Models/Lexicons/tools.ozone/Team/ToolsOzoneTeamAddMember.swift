//
//  ToolsOzoneTeamAddMember.swift
//
//
//  Created by Christopher Jr Riley on 2024-06-29.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ToolsOzoneLexicon.Team {

    /// The main data model definition for adding a member as an administrator.
    ///
    /// - Note: According to the AT Protocol specifications: "Add a member to the ozone team.
    /// Requires admin role."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.team.addMember`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/team/addMember.json
    public struct AddMember: Sendable, Codable {

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
        public let role: AddMember.Role

        enum CodingKeys: String, CodingKey {
            case memberDID = "did"
            case role
        }
    }
}
