//
//  AtProtoLabelDefs.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-25.
//

import Foundation

/// The main data model definition for a label.
///
/// - Note: According to the AT Protocol specifications: "Metadata tag on an atproto resource (eg, repo or record)."
///
/// - SeeAlso: This is based on the [`com.atproto.label.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/label/defs.json
public struct Label: Codable {
    /// The decentralized identifier (DID) of the label creator.
    ///
    /// - Note: According to the AT Protocol specifications: "DID of the actor who created this label."
    public let actorDID: String
    /// The URI of the resource the label applies to.
    ///
    /// - Note: According to the AT Protocol specifications: "AT URI of the record, repository (account), or other resource that this label applies to."
    public let atURI: String
    /// The CID hash of the resource the label applies to. Optional.
    ///
    /// - Note: According to the AT Protocol specifications: "Optionally, CID specifying the specific version of 'uri' resource this label applies to."
    public let cidHash: String?
    /// The name of the label.
    ///
    /// - Note: According to the AT Protocol specifications: "The short string name of the value or type of this label."
    ///
    /// - Important: Current maximum length is 128 characters. This library will automatically truncate the `String` to the maximum length if it does go over the limit.
    public var name: String
    /// Indicates whether this label is negating a previously-used label. Optional.
    ///
    /// - Note: According to the AT Protocol specifications: "If true, this is a negation label, overwriting a previous label."
    public let isNegated: Bool?
    /// The date and time the label was created.
    ///
    /// - Note: According to the AT Protocol specifications: "Timestamp when this label was created."
    @DateFormatting public var timestamp: Date

    public init(actorDID: String, atURI: String, cidHash: String?, name: String, isNegated: Bool?, timestamp: Date) {
        self.actorDID = actorDID
        self.atURI = atURI
        self.cidHash = cidHash
        self.name = name
        self.isNegated = isNegated
        self._timestamp = DateFormatting(wrappedValue: timestamp)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.actorDID = try container.decode(String.self, forKey: .actorDID)
        self.atURI = try container.decode(String.self, forKey: .atURI)
        self.cidHash = try container.decodeIfPresent(String.self, forKey: .cidHash)
        self.name = try container.decode(String.self, forKey: .name)
        self.isNegated = try container.decodeIfPresent(Bool.self, forKey: .isNegated)
        self.timestamp = try container.decode(DateFormatting.self, forKey: .timestamp).wrappedValue
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.actorDID, forKey: .actorDID)
        try container.encode(self.atURI, forKey: .atURI)
        try container.encodeIfPresent(self.cidHash, forKey: .cidHash)

        // Truncate `name` to 128 characters before encoding
        try truncatedEncode(self.name, withContainer: &container, forKey: .name, upToLength: 128)

        try container.encodeIfPresent(self.isNegated, forKey: .isNegated)
        try container.encode(self._timestamp, forKey: .timestamp)
    }

    enum CodingKeys: String, CodingKey {
        case actorDID = "src"
        case atURI = "uri"
        case cidHash = "cid"
        case name = "val"
        case isNegated = "neg"
        case timestamp = "cts"
    }
}

/// A data model for a definition for an array of self-defined labels.
public struct SelfLabels: Codable {
    /// An array of self-defined tags on a record..
    ///
    /// - Note: According to the AT Protocol specifications: "Metadata tags on an atproto record, published by the author within the record."
    ///
    /// - Important: Current maximum length is 10 tags. This library will automatically truncate the `Array` to the maximum length if it does go over the limit.
    ///
    /// - SeeAlso: This is based on the [`com.atproto.label.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/label/defs.json
    public let values: [SelfLabel]

    public init(values: [SelfLabel]) {
        self.values = values
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.values = try container.decode([SelfLabel].self, forKey: .values)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        // Truncate `values` to 10 items before encoding
        try truncatedEncode(self.values, withContainer: &container, forKey: .values, upToLength: 10)
    }

    enum CodingKeys: CodingKey {
        case values
    }
}

/// A data model for a definition for a user-defined label.
///
/// - Note: According to the AT Protocol specifications: "Metadata tag on an atproto record, published by the author within the record. Note that schemas should use #selfLabels, not #selfLabel.",
///
/// - SeeAlso: This is based on the [`com.atproto.label.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/label/defs.json
public struct SelfLabel: Codable {
    /// A user-defined label.
    ///
    /// - Note: According to the AT Protocol specifications: "The short string name of the value or type of this label."
    ///
    /// - Important: Current maximum length is 128 characters. This library will automatically truncate the `String` to the maximum length if it does go over the limit.
    public let value: String

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        // Truncate `value` to 128 characters before encoding
        try truncatedEncode(self.value, withContainer: &container, forKey: .value, upToLength: 128)
    }

    enum CodingKeys: String, CodingKey {
        case value = "val"
    }
}
