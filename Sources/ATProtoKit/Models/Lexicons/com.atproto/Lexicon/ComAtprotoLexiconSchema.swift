//
//  ComAtprotoLexiconSchema.swift
//
//
//  Created by Christopher Jr Riley on 2025-01-15.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ComAtprotoLexicon.Lexicon {

    /// A definition model for a lexicon structure.
    ///
    /// - Note: According to the AT Protocol specifications: "Representation of Lexicon schemas
    /// themselves, when published as atproto records. Note that the schema language is not defined
    /// in Lexicon; this meta schema currently only includes a single version field ('lexicon').
    /// See the atproto specifications for description of the other expected top-level fields
    /// ('id', 'defs', etc)."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.lexicon.schema`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/lexicon/schema.json
    public struct SchemaRecord: ATRecordProtocol, Sendable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public static let type: String = "com.atproto.lexicon.schema"

        /// The version number for the lexicon.
        ///
        /// - Note: According to the AT Protocol specifications: "Indicates the 'version' of the
        /// Lexicon language. Must be '1' for the current atproto/Lexicon schema system."
        public let lexicon: Int

        public init(lexicon: Int = 1) {
            self.lexicon = lexicon
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.lexicon = try container.decode(Int.self, forKey: .lexicon)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.lexicon, forKey: .lexicon)
        }

        enum CodingKeys: CodingKey {
            case lexicon
        }
    }
}
