//
//  ComAtprotoIdentityUpdateHandle.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

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
    public struct UpdateHandleRequestBody: Sendable, Encodable {

        /// The handle the user would like to change to.
        ///
        /// - Note: According to the AT Protocol specifications: "The new handle."
        public let handle: String
        
        public init(handle: String) {
            self.handle = handle
        }
        
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(self.handle, forKey: .handle)
        }
        
        public enum CodingKeys: CodingKey {
            case handle
        }
    }
}
