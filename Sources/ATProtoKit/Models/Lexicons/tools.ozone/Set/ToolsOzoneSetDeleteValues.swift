//
//  ToolsOzoneSetDeleteValues.swift
//
//
//  Created by Christopher Jr Riley on 2024-10-24.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ToolsOzoneLexicon.Set {

    /// A request body model for deleting values of a set as a moderator.
    ///
    /// - Note: According to the AT Protocol specifications: "Delete values from a specific set.
    /// Attempting to delete values that are not in the set will not result in an error."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.set.deleteValues`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/set/deleteValues.json
    public struct DeleteValuesRequestBody: Sendable, Codable {

        /// The name of the set.
        ///
        /// - Note: According to the AT Protocol specifications: "Name of the set to delete
        /// values from."
        public var name: String

        /// An array of values to delete.
        ///
        /// - Note: According to the AT Protocol specifications: "Array of string values to
        /// delete from the set."
        public var values: [String]
    }
}
