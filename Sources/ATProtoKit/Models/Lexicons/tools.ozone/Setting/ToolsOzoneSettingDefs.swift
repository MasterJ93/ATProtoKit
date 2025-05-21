//
//  ToolsOzoneSettingDefs.swift
//
//
//  Created by Christopher Jr Riley on 2024-12-31.
//

import Foundation

extension ToolsOzoneLexicon.Setting {

    /// A definition model for a setting option.
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.setting.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/setting/defs.json
    public struct OptionDefinition: Sendable, Codable {

        /// The key of the option.
        public let key: String

        /// The option's decentralized identifier (DID).
        public let did: String

        /// The option's value.
        public let value: UnknownType

        /// The description of the option. Optional.
        ///
        /// - Important: Current maximum length is 1,024 characters.
        public let description: String?

        /// The date and time the option was created. Optional.
        public let createdAt: Date?

        /// The date and time the option was last updated. Optional.
        public let updatedAt: Date?

        /// The manager role of the option. Optional.
        public let managerRole: Role?

        /// The scope of the option.
        public let scope: Scope

        /// The decentralized identifier (DID) of the user account that created the option.
        public let createdBy: String

        /// The decentralized identifier (DID) of the user account that last updated the option.
        public let lastUpdatedBy: String

        public init(key: String, did: String, value: UnknownType, description: String?, createdAt: Date?, updatedAt: Date?,
             managerRole: Role?, scope: Scope, createdBy: String, lastUpdatedBy: String) {
            self.key = key
            self.did = did
            self.value = value
            self.description = description
            self.createdAt = createdAt
            self.updatedAt = updatedAt
            self.managerRole = managerRole
            self.scope = scope
            self.createdBy = createdBy
            self.lastUpdatedBy = lastUpdatedBy
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.key = try container.decode(String.self, forKey: .key)
            self.did = try container.decode(String.self, forKey: .did)
            self.value = try container.decode(UnknownType.self, forKey: .value)
            self.description = try container.decodeIfPresent(String.self, forKey: .description)
            self.createdAt = try container.decodeDateIfPresent(forKey: .createdAt)
            self.updatedAt = try container.decodeDateIfPresent(forKey: .updatedAt)
            self.managerRole = try container.decodeIfPresent(Role.self, forKey: .managerRole)
            self.scope = try container.decode(ToolsOzoneLexicon.Setting.OptionDefinition.Scope.self, forKey: .scope)
            self.createdBy = try container.decode(String.self, forKey: .createdBy)
            self.lastUpdatedBy = try container.decode(String.self, forKey: .lastUpdatedBy)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.key, forKey: .key)
            try container.encode(self.did, forKey: .did)
            try container.encode(self.value, forKey: .value)
            try container.encodeIfPresent(self.description, forKey: .description)
            try container.truncatedEncodeIfPresent(self.description, forKey: .description, upToCharacterLength: 1_024)
            try container.encodeDateIfPresent(self.createdAt, forKey: .createdAt)
            try container.encodeDateIfPresent(self.updatedAt, forKey: .updatedAt)
            try container.encodeIfPresent(self.managerRole, forKey: .managerRole)
            try container.encode(self.scope, forKey: .scope)
            try container.encode(self.createdBy, forKey: .createdBy)
            try container.encode(self.lastUpdatedBy, forKey: .lastUpdatedBy)
        }

        enum CodingKeys: CodingKey {
            case key
            case did
            case value
            case description
            case createdAt
            case updatedAt
            case managerRole
            case scope
            case createdBy
            case lastUpdatedBy
        }

        // Enums
        /// The scope of the option.
        public enum Scope: Sendable, Codable {

            /// Indicates this is an instance scope.
            case instance

            /// Indicates this is a personal scope.
            case personal
        }

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
}
