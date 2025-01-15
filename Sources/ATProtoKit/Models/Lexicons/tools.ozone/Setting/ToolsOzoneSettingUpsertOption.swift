//
//  ToolsOzoneSettingUpsertOption.swift
//
//
//  Created by Christopher Jr Riley on 2024-12-31.
//

import Foundation

extension ToolsOzoneLexicon.Setting {

    /// A definition model for upserting options.
    public struct UpsertOption: Sendable, Codable {

        /// The scope of the option.
        public enum Scope: Sendable, Codable {

            /// Indicates this is an instance scope.
            case instance

            /// Indicates this is a personal scope.
            case personal
        }
    }

    /// A request body model for upserting options.
    ///
    /// - Note: According to the AT Protocol specifications: "Create or update setting option."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.setting.upsertOption`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/setting/upsertOption.json
    public struct UpsertOptionRequestBody: Sendable, Codable {

        /// The key of the option.
        public let key: String

        /// The scope of the option.
        public let scope: UpsertOption.Scope

        /// The value of the option.
        public let value: UnknownType

        /// The description of the option. Optional.
        ///
        /// - Important: Current maximum is 2,000 characters.
        public let description: String?

        /// The manager role of the option. Optional.
        public let managerRole: ToolsOzoneLexicon.Team.MemberDefinition.Role?

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.key, forKey: .key)
            try container.encode(self.scope, forKey: .scope)
            try container.encode(self.value, forKey: .value)
            try container.truncatedEncodeIfPresent(self.description, forKey: .description, upToCharacterLength: 2_000)
            try container.encodeIfPresent(self.managerRole, forKey: .managerRole)
        }

        enum CodingKeys: CodingKey {
            case key
            case scope
            case value
            case description
            case managerRole
        }
    }

    /// An output model for upserting options.
    ///
    /// - Note: According to the AT Protocol specifications: "Create or update setting option."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.setting.upsertOption`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/setting/upsertOption.json
    public struct UpsertOptionOutput: Sendable, Codable {

        /// The option that have be upserted.
        public let option: ToolsOzoneLexicon.Setting.OptionDefinition
    }
}
