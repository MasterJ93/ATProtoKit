//
//  BskyGraphBlock.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-08.
//

import Foundation

/// The main data model definition for a block record.
///
/// - Note: According to the AT Protocol specifications: "Record declaring a 'block' relationship
/// against another account. NOTE: blocks are public in Bluesky; see blog posts for details."
///
/// - SeeAlso: This is based on the [`app.bsky.graph.block`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/block.json
public struct GraphBlock: ATRecordProtocol {
    /// The identifier of the lexicon.
    ///
    /// - Warning: The value must not change.
    public static private(set) var type: String = "app.bsky.graph.block"
    /// The decentralized identifier(DID) of the subject that has been blocked.
    ///
    /// - Note: According to the AT Protocol specifications: "DID of the account to be blocked."
    public let subjectDID: String
    /// The date and time the block record was created.
    @DateFormatting public var createdAt: Date

    public init(subjectDID: String, createdAt: Date) {
        self.subjectDID = subjectDID
        self._createdAt = DateFormatting(wrappedValue: createdAt)
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.subjectDID = try container.decode(String.self, forKey: .subjectDID)
        self.createdAt = try container.decode(DateFormatting.self, forKey: .createdAt).wrappedValue
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

//        try container.encode(self.type, forKey: .type)
        try container.encode(self.subjectDID, forKey: .subjectDID)
        try container.encode(self._createdAt, forKey: .createdAt)
    }

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case subjectDID = "subject"
        case createdAt
    }
}
