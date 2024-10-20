//
//  ToolsOzoneModerationSetAddValues.swift
//
//  Created by Christopher Jr Riley on 2024-10-19.
//

import Foundation

extension ToolsOzoneLexicon.Set {

    /// A request body model for adding values to a specific set as an administrator.
    ///
    /// - Note: According to the AT Protocol specifications: "Add values to a specific set.
    /// Attempting to add values to a set that does not exist will result in an error."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.set.addValues`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/set/addValues.json
    public struct AddValuesRequestBody: Codable {

        /// The name of the set.
        public let name: String

        /// An array of values. Limited to 100 items.
        public let values: [String]
    }
}
