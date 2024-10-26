//
//  ToolsOzoneSetQuerySets.swift
//
//
//  Created by Christopher Jr Riley on 2024-10-24.
//

import Foundation

extension ToolsOzoneLexicon.Set {

    /// A definition model for querying available sets.
    ///
    /// - Note: According to the AT Protocol specifications: "Query available sets."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.set.querySets`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/set/querySets.json
    public struct QuerySets: Sendable, Codable {

        /// Defines sorting criteria for sets.
        public enum SortBy: Sendable, Codable {

            /// Sort by name.
            case name

            /// Sort by when the sets were created.
            case createdAt

            /// Sort by when the sets were updated.
            case updatedAt
        }

        /// Defines the sorting direction.
        ///
        /// - Note: According to the AT Protocol specifications: "Defaults to ascending order of
        /// name field."
        public enum SortDirection: String, Sendable, Codable {

            /// Sorts items in alphabetical order.
            case ascending = "asc"

            /// Sorts items in reverse alphabetical order.
            case descending = "desc"
        }
    }

    /// An output model for querying available sets.
    ///
    /// - Note: According to the AT Protocol specifications: "Query available sets."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.set.querySets`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/set/querySets.json
    public struct QuerySetsOutput: Sendable, Codable {

        /// An array of sets.
        public let sets: [ToolsOzoneLexicon.Set.SetViewDefinition]

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?
    }
}
