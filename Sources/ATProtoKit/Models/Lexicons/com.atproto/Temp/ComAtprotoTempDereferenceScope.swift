//
//  ComAtprotoTempDereferenceScope.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-09-27.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ComAtprotoLexicon.Temp {

    /// An output model for resolving the OAuth permission scope from a reference.
    ///
    /// - Note: According to the AT Protocol specifications: "Allows finding the oauth permission scope from a reference."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.temp.dereferenceScope`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/temp/dereferenceScope.json
    public struct DereferenceScopeOutput: Sendable, Codable {

        /// The complete OAuth permission scope.
        ///
        /// - Note: According to the AT Protocol specifications: "The full oauth permission scope."
        public let scope: String
    }
}
