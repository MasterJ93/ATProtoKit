//
//  ToolsOzoneTeamDefs.swift
//
//
//  Created by Christopher Jr Riley on 2024-06-29.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ToolsOzoneLexicon.Team {

    /// A definition model for a member.
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.team.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/team/defs.json
    public struct MemberDefinition: Sendable, Codable {

        /// The decentralized identifier (DID) of the member.
        public let memberDID: String

        /// Indicates whether the member is disabled. Optional.
        public let isDisabled: Bool?

        /// The user account of the member. Optional.
        public let profile: AppBskyLexicon.Actor.ProfileViewDetailedDefinition?

        /// The date and time the member was created. Optional.
        public let createdAt: Date?

        /// The date and time the member was updated. Optional.
        public let updatedAt: Date?

        /// The user account that updated the member. Optional.
        public let lastUpdatedBy: String?

        /// The current role that was given to the member.
        public let role: Role

        public init(memberDID: String, isDisabled: Bool?, profile: AppBskyLexicon.Actor.ProfileViewDetailedDefinition?, createdAt: Date?,
                    updatedAt: Date? = nil, lastUpdatedBy: String?, role: Role) {
            self.memberDID = memberDID
            self.isDisabled = isDisabled
            self.profile = profile
            self.createdAt = createdAt
            self.updatedAt = updatedAt
            self.lastUpdatedBy = lastUpdatedBy
            self.role = role
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.memberDID = try container.decode(String.self, forKey: .memberDID)
            self.isDisabled = try container.decodeIfPresent(Bool.self, forKey: .isDisabled)
            self.profile = try container.decodeIfPresent(AppBskyLexicon.Actor.ProfileViewDetailedDefinition.self, forKey: .profile)
            self.createdAt = try container.decodeDateIfPresent(forKey: .createdAt)
            self.updatedAt = try container.decodeDateIfPresent(forKey: .updatedAt)
            self.lastUpdatedBy = try container.decodeIfPresent(String.self, forKey: .lastUpdatedBy)
            self.role = try container.decode(Role.self, forKey: .role)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.memberDID, forKey: .memberDID)
            try container.encodeIfPresent(self.isDisabled, forKey: .isDisabled)
            try container.encodeIfPresent(self.profile, forKey: .profile)
            try container.encodeDateIfPresent(self.createdAt, forKey: .createdAt)
            try container.encodeDateIfPresent(self.updatedAt, forKey: .updatedAt)
            try container.encodeIfPresent(self.lastUpdatedBy, forKey: .lastUpdatedBy)
            try container.encode(self.role, forKey: .role)
        }

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
        public enum Role: String, Sendable, Codable {

            /// A role that allows the member to access all of the actions.
            ///
            /// - Note: According to the AT Protocol specifications: "Admin role. Highest level
            /// of access, can perform all actions."
            case admin = "roleAdmin"

            /// A role that allows the member to access most of the actions.
            ///
            /// - Note: According to the AT Protocol specifications: "Moderator role. Can perform
            /// most actions."
            case moderator = "roleModerator"

            /// A role that allows the member to access actions related to monitoring and
            /// escalating issues.
            ///
            /// - Note: According to the AT Protocol specifications: "Triage role. Mostly intended
            /// for monitoring and escalating issues."
            case triage = "roleTriage"

            /// A role that allows the member to verify user accounts.
            ///
            /// - Note: According to the AT Protocol specifications: "Verifier role. Only allowed to
            /// issue verifications."
            case verifier = "roleVerifier"
        }
    }
}
