//
//  ToolsOzoneTeamDefs.swift
//
//
//  Created by Christopher Jr Riley on 2024-06-29.
//

import Foundation

extension ToolsOzoneLexicon.Team {

    /// A definition model for a member.
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.team.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/team/defs.json
    public struct MemberDefinition: Codable {

        /// The decentralized identifier (DID) of the member.
        public let memberDID: String

        /// Indicates whether the member is disabled. Optional.
        public let isDisabled: Bool?

        /// The user account of the member. Optional.
        public let profile: AppBskyLexicon.Actor.ProfileViewDetailedDefinition?

        /// The date and time the member was created. Optional.
        @DateFormattingOptional public var createdAt: Date?

        /// The date and time the member was updated. Optional.
        @DateFormattingOptional public var updatedAt: Date?

        /// The user account that updated the member. Optional.
        public let lastUpdatedBy: String?

        /// The current role that was given to the member.
        public let role: String

        enum CodingKeys: String, CodingKey {
            case memberDID = "did"
            case isDisabled = "disabled"
            case profile
            case createdAt
            case updatedAt
            case lastUpdatedBy
            case role
        }

        // Enums
        /// The role that was given to the member.
        public enum Role: String, Codable {

            /// A role that allows the member to access all of the actions.
            ///
            /// - Note: According to the AT Protocol specifications: "Admin role. Highest level
            /// of access, can perform all actions."
            case roleAdmin

            /// A role that allows the member to access most of the actions.
            ///
            /// - Note: According to the AT Protocol specifications: "Moderator role. Can perform
            /// most actions."
            case roleModerator

            /// A role that allows the member to access actions related to monitoring and
            /// escalating issues.
            ///
            /// - Note: According to the AT Protocol specifications: "Triage role. Mostly intended
            /// for monitoring and escalating issues."
            case roleTriage
        }
    }
}
