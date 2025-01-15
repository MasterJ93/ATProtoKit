//
//  ToolsOzoneSettingRemoveOptions.swift
//
//
//  Created by Christopher Jr Riley on 2024-12-31.
//

import Foundation

extension ToolsOzoneLexicon.Setting {

    /// A definition model for removing options.
    public struct RemoveOptions: Sendable, Codable {

        /// The scope of the option.
        public enum Scope: Sendable, Codable {

            /// Indicates this is an instance scope.
            case instance

            /// Indicates this is a personal scope.
            case personal
        }
    }

    /// A request body model for removing options.
    ///
    /// - Note: According to the AT Protocol specifications: "Delete settings by key."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.setting.removeOptions`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/setting/removeOptions.json
    public struct RemoveOptionsRequestBody: Sendable, Codable {

        /// An array of keys.
        ///
        /// - Important: Current maximum length is 200 items.
        public let keys: [String]

        /// The scope of the options.
        ///
        /// - Important: Current maximum is 200 characters.
        public let scope: RemoveOptions.Scope

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.truncatedEncode(self.keys, forKey: .keys, upToArrayLength: 200)
            try container.encode(self.scope, forKey: .scope)
        }

        enum CodingKeys: CodingKey {
            case keys
            case scope
        }
    }
}
