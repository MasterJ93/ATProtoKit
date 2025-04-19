//
//  AppBskyGraphListblock.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension AppBskyLexicon.Graph {

    /// A record model for a blocking list.
    ///
    /// - Note: According to the AT Protocol specifications: "Record representing a block
    /// relationship against an entire [...] list of accounts (actors)."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.graph.listblock`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/listblock.json
    public struct ListBlockRecord: ATRecordProtocol, Sendable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public static let type: String = "app.bsky.graph.listblock"

        /// The decentralized identifier (DID) of the moderator list record.
        ///
        /// - Note: According to the AT Protocol specifications: "Reference (AT-URI) to the mod
        /// list record."
        public let listURI: String

        /// The date and time the record was created.
        public let createdAt: Date

        public init(listURI: String, createdAt: Date) {
            self.listURI = listURI
            self.createdAt = createdAt
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.listURI = try container.decode(String.self, forKey: .listURI)
            self.createdAt = try container.decodeDate(forKey: .createdAt)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.listURI, forKey: .listURI)
            try container.encodeDate(self.createdAt, forKey: .createdAt)
        }

        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case listURI = "subject"
            case createdAt
        }
    }
}
