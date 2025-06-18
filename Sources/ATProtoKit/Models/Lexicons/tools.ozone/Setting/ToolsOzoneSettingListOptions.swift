//
//  ToolsOzoneSettingListOptions.swift
//
//
//  Created by Christopher Jr Riley on 2024-12-31.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ToolsOzoneLexicon.Setting {

    /// A definition model for listing options.
    public struct ListOptions: Sendable, Codable {

        /// The scope of the option.
        public enum Scope: Sendable, Codable {

            /// Indicates this is an instance scope.
            case instance

            /// Indicates this is a personal scope.
            case personal
        }
    }

    /// An output model for listing options.
    ///
    /// - Note: According to the AT Protocol specifications: "List settings with optional filtering."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.setting.listOption`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/setting/listOptions.json
    public struct ListOptionsOutput: Sendable, Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of options.
        public let options: [ToolsOzoneLexicon.Setting.OptionDefinition]
    }
}
