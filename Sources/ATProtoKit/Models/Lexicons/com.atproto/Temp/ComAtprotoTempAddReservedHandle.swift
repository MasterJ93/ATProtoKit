//
//  ComAtprotoTempAddReservedHandle.swift
//
//
//  Created by Christopher Jr Riley on 2024-12-31.
//

import Foundation

extension ComAtprotoLexicon.Temp {

    /// A definition model for adding a reserved handle.
    ///
    /// - Important: The lexicon associated with this model may be removed at any time. This may
    /// not work.
    ///
    /// - Note: According to the AT Protocol specifications: "Add a handle to the set of
    /// reserved handles."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.temp.addReservedHandle`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/temp/addReservedHandle.json
    public struct AddReservedHandleRequestBody: Sendable, Codable {

        /// The handle to add.
        public let handle: String
    }
}
