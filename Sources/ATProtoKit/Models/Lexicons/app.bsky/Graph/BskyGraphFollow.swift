//
//  BskyGraphFollow.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-08.
//

import Foundation

/// The main data model definition for a follow record.
///
/// - Note: According to the AT Protocol specifications: "Record declaring a social 'follow' relationship of another account. Duplicate follows will be ignored
/// by the AppView."
///
/// - SeeAlso: This is based on the [`app.bsky.graph.follow`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/follow.json
public struct GraphFollow: ATRecordProtocol {
    /// The identifier of the lexicon.
    ///
    /// - Warning: The value must not change.
    public private(set) var type: String = "app.bsky.graph.follow"

    /// The subject that the user account wants to "follow."
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

        try container.encode(self.subjectDID, forKey: .subjectDID)
        try container.encode(self._createdAt, forKey: .createdAt)
    }

    enum CodingKeys: String, CodingKey {
        case subjectDID = "subject"
        case createdAt
    }
}
