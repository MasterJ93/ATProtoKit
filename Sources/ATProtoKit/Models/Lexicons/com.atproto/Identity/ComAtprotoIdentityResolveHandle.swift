//
//  ComAtprotoIdentityResolveHandle.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation

extension ComAtprotoLexicon.Identity {

    /// An output model for esolving handles.
    ///
    /// - SeeAlso: This is based on the [`com.atproto.identity.resolveHandle`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/identity/resolveHandle.json
    public struct ResolveHandleOutput: Sendable, Decodable {

        /// The resolved handle's decentralized identifier (DID).
        public let handleDID: String
    }
}
