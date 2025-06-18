//
//  ComAtprotoServerGetServiceAuth.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ComAtprotoLexicon.Server {

    /// An output model for getting the signed token for the service.
    ///
    /// - Note: According to the AT Protocol specifications: "Get a signed token on behalf of the
    /// requesting DID for the requested service."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.getServiceAuth`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/getServiceAuth.json
    public struct GetServiceAuthOutput: Sendable, Codable {

        /// The token for the requested service.
        public let token: String
    }
}
