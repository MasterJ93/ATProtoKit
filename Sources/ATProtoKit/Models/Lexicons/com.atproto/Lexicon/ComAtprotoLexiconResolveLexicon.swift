//
//  ComAtprotoLexiconResolveLexicon.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-11-13.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ComAtprotoLexicon.Lexicon {

    /// An output model for mapping a Namespaced Identifier (NSID) to its corresponding lexicon
    /// schema definition.
    ///
    /// - Note: According to the AT Protocol specifications: "Resolves an atproto lexicon (NSID) to
    /// a schema."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.lexicon.resolveLexicon`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/lexicon/resolveLexicon.json
    public struct ResolveLexiconOutput: Codable, Sendable {

        /// The CID that identifies the lexicon schema record.
        ///
        /// - Note: According to the AT Protocol specifications: "The CID of the lexicon schema record."
        public let cid: String

        /// The lexicon schema record after it has been fully resolved.
        ///
        /// - Note: According to the AT Protocol specifications: "The resolved lexicon schema record."
        public let schema: ComAtprotoLexicon.Lexicon.SchemaRecord

        /// The AT-URI that points to the lexicon schema record.
        ///
        /// - Note: According to the AT Protocol specifications: "The AT-URI of the lexicon schema record."
        public let uri: String
    }
}
