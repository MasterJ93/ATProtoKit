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
    /// The version number of the label. Optional.
    ///
    /// - Note: According to the AT Protocol specifications: "The AT Protocol version of the label object."
    public let version: Int?
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
    /// - Note: According to the AT Protocol specifications: "Optionally, CID specifying the specific version of 'uri' resource this label
    /// applies to."
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
    /// The date and time the label expires on.
    ///
    /// - Note: According to the AT Protocol specifications: "Timestamp at which this label expires (no longer applies)."
    @DateFormattingOptional public var expiresOn: Date?
    /// The DAG-CBOR-encoded signature. Optional.
    ///
    /// - Note: According to the AT Protocol specifications: "Signature of dag-cbor encoded label."
    public let signature: Data?

    public init(version: Int?, actorDID: String, atURI: String, cidHash: String?, name: String, isNegated: Bool?, timestamp: Date, expiresOn: Date?, signature: Data) {
        self.version = version
        self.actorDID = actorDID
        self.atURI = atURI
        self.cidHash = cidHash
        self.name = name
        self.isNegated = isNegated
        self._timestamp = DateFormatting(wrappedValue: timestamp)
        self._expiresOn = DateFormattingOptional(wrappedValue: expiresOn)
        self.signature = signature
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.version = try container.decodeIfPresent(Int.self, forKey: .version)
        self.actorDID = try container.decode(String.self, forKey: .actorDID)
        self.atURI = try container.decode(String.self, forKey: .atURI)
        self.cidHash = try container.decodeIfPresent(String.self, forKey: .cidHash)
        self.name = try container.decode(String.self, forKey: .name)
        self.isNegated = try container.decodeIfPresent(Bool.self, forKey: .isNegated)
        self.timestamp = try container.decode(DateFormatting.self, forKey: .timestamp).wrappedValue
        self.expiresOn = try container.decodeIfPresent(DateFormattingOptional.self, forKey: .expiresOn)?.wrappedValue
        self.signature = try container.decodeIfPresent(Data.self, forKey: .signature)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(self.version, forKey: .version)
        try container.encode(self.actorDID, forKey: .actorDID)
        try container.encode(self.atURI, forKey: .atURI)
        try container.encodeIfPresent(self.cidHash, forKey: .cidHash)

        // Truncate `name` to 128 characters before encoding
        try truncatedEncode(self.name, withContainer: &container, forKey: .name, upToLength: 128)

        try container.encodeIfPresent(self.isNegated, forKey: .isNegated)
        try container.encode(self._timestamp, forKey: .timestamp)
        try container.encodeIfPresent(self._expiresOn, forKey: .expiresOn)
        try container.encodeIfPresent(self.signature, forKey: .signature)
    }

    enum CodingKeys: String, CodingKey {
        case version = "ver"
        case actorDID = "src"
        case atURI = "uri"
        case cidHash = "cid"
        case name = "val"
        case isNegated = "neg"
        case timestamp = "cts"
        case expiresOn = "exp"
        case signature = "sig"
    }
}

/// A data model for a definition for an array of self-defined labels.
public struct SelfLabels: Codable {
    /// An array of self-defined tags on a record.
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
