//
//  AppBskyGraphListitem.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension AppBskyLexicon.Graph {

    /// A record model for a list item.
    ///
    /// - Note: According to the AT Protocol specifications: "Record representing an account's
    /// inclusion on a specific list. The AppView will ignore duplicate listitem records."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.graph.listitem`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/listitem.json
    public struct ListItemRecord: ATRecordProtocol, Sendable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public static let type: String = "app.bsky.graph.listitem"

        /// The decentralized identifier (DID) of the account that's in a list.
        ///
        /// - Note: According to the AT Protocol specifications: "The account which is included on
        /// the list."
        public let subjectDID: String

        /// The decentralized identifier (DID) of the list record.
        ///
        /// - Note: According to the AT Protocol specifications: "The account which is included on
        /// the list."
        public let list: String

        /// The date and time the record was created.
        @DateFormatting public var createdAt: Date

        public init(subjectDID: String, list: String, createdAt: Date) {
            self.subjectDID = subjectDID
            self.list = list
            self._createdAt = DateFormatting(wrappedValue: createdAt)
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.subjectDID = try container.decode(String.self, forKey: .subjectDID)
            self.list = try container.decode(String.self, forKey: .list)
            self.createdAt = try container.decode(DateFormatting.self, forKey: .createdAt).wrappedValue
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.subjectDID, forKey: .subjectDID)
            try container.encode(self.list, forKey: .list)
            try container.encode(self._createdAt, forKey: .createdAt)
        }

        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case subjectDID = "subject"
            case list
            case createdAt
        }
    }
}
