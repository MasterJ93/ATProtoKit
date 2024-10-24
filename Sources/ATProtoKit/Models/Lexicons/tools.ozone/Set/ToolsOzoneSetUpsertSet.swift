//
//  ToolsOzoneSetUpsertSet.swift
//
//
//  Created by Christopher Jr Riley on 2024-10-24.
//

import Foundation

extension ToolsOzoneLexicon.Set {

    /// A request body model for creating or updating set metadata.
    ///
    /// - Note: According to the AT Protocol specifications: "Create or update set metadata."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.set.upsertSet`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/set/upsertSet.json
    public struct UpsertSetRequestBody: Codable {

        /// The name of the set.
        public let name: String

        /// The new description of the set.
        public let description: String

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try truncatedEncode(self.name, withContainer: &container, forKey: .name, upToCharacterLength: 128)
            try truncatedEncode(self.description, withContainer: &container, forKey: .description, upToCharacterLength: 10_240)
        }
    }
}
