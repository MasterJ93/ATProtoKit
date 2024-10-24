//
//  ToolsOzoneSetDefs.swift
//
//  Created by Christopher Jr Riley on 2024-10-19.
//

import Foundation

extension ToolsOzoneLexicon.Set {

    /// A definition model for a set.
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.set.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/set/defs.json
    public struct SetDefinition: Codable {

        /// The name of the set.
        ///
        /// A minimum of 3 characters and maximum of 128 characters is required.
        public let name: String

        /// The description of the set.
        ///
        /// A maximum of 1,024 characters can be made.
        public let description: String?
    }

    /// A definition model for a set view.
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.set.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/set/defs.json
    public struct SetViewDefinition: Codable {

        /// The name of the set.
        ///
        /// A minimum of 3 characters and maximum of 128 characters is required.
        public let name: String

        /// The description of the set.
        ///
        /// A maximum of 1,024 characters can be made.
        public let description: String?

        /// The size of the set.
        public let setSize: Int

        /// The date and time the set was created.
        @DateFormatting public var createdAt: Date

        /// The date and time the set was updated.
        @DateFormatting public var updatedAt: Date

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.name, forKey: .name)
            try container.encodeIfPresent(self.description, forKey: .description)
            try container.encode(self.setSize, forKey: .setSize)
            try container.encode(self.createdAt, forKey: .createdAt)
            try container.encode(self.updatedAt, forKey: .updatedAt)
        }
    }
}
