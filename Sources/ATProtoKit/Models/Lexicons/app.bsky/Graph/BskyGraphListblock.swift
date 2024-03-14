//
//  BskyGraphListblock.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-10.
//

import Foundation

/// The main data model definition for a blocking list record.
///
/// - Note: According to the AT Protocol specifications: "Record representing a block relationship against an entire [...] list of accounts (actors)."
///
/// - SeeAlso: This is based on the [`app.bsky.graph.listblock`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/listblock.json
public struct GraphListBlock: Codable {
    /// The identifier of the lexicon.
    ///
    /// - Warning: The value must not change.
    internal let type: String = "app.bsky.graph.listblock"
    /// The decentralized identifier (DID) of the moderator list record.
    ///
    /// - Note: According to the AT Protocol specifications: "Reference (AT-URI) to the mod list record."
    public let subjectDID: String
    /// The date and time the record was created.
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
        try container.encode(self.type, forKey: .type)
        try container.encode(self.subjectDID, forKey: .subjectDID)
        try container.encode(self._createdAt, forKey: .createdAt)
    }

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case subjectDID = "subject"
        case createdAt
    }
}
