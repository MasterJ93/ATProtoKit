//
//  ToolsOzoneSetDeleteSet.swift
//
//
//  Created by Christopher Jr Riley on 2024-10-24.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ToolsOzoneLexicon.Set {

    /// A request body model for deleting a set as a moderator.
    ///
    /// - Note: According to the AT Protocol specifications: "Delete an entire set. Attempting to
    /// delete a set that does not exist will result in an error."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.set.deleteSet`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/set/deleteSet.json
    public struct DeleteSetRequestBody: Sendable, Codable {

        /// The name of the set.
        ///
        /// - Note: According to the AT Protocol specifications: "Name of the set to delete."
        public let name: String
    }

    /// An output model for deleting a set as a moderator.
    ///
    /// - Note: According to the AT Protocol specifications: "Delete an entire set. Attempting to
    /// delete a set that does not exist will result in an error."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.set.deleteSet`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/set/deleteSet.json
    public struct DeleteSetOutput: Sendable, Codable {}
}
