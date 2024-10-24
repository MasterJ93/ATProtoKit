//
//  ToolsOzoneSetGetValues.swift
//
//
//  Created by Christopher Jr Riley on 2024-10-24.
//

import Foundation

extension ToolsOzoneLexicon.Set {

    /// An output model for getting a specific set and its values.
    ///
    /// - Note: According to the AT Protocol specifications: "Get a specific set and its values."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.set.getValues`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/set/getValues.json
    public struct GetValuesOutput: Codable {

        /// A view of the set.
        public let set: ToolsOzoneLexicon.Set.SetViewDefinition

        /// An array of values.
        public let values: [String]

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?
    }
}
