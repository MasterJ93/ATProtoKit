//
//  ComAtprotoIdentityUpdateHandle.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation

extension ComAtprotoLexicon.Identity {

    /// A request body model for updating a handle.
    ///
    /// - Note: According to the AT Protocol specifications: "Updates the current account's handle.
    /// Verifies handle validity, and updates did:plc document if necessary. Implemented by PDS,
    /// and requires auth."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.identity.updateHandle`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/identity/updateHandle.json
    public struct UpdateHandleRequestBody: Encodable {

        /// The handle the user would like to change to.
        ///
        /// - Note: According to the AT Protocol specifications: "The new handle."
        public let handle: String
    }
}
