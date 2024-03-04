//
//  BskyRichTextFacet.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-25.
//

import Foundation

// MARK: - Main definition
/// The main data model definition for a facet.
///
/// - Note: According to the AT Protocol specifications: "Annotation of a sub-string within rich text."
///
/// - SeeAlso: This is based on the [`app.bsky.richtext.facet`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/richtext/facet.json
public struct Facet: Codable {
    /// The range of characters related to the facet.
    public let index: ByteSlice
    /// The facet's feature type.
    public let features: [FeatureUnion]

    public init(index: ByteSlice, features: [FeatureUnion]) {
        self.index = index
        self.features = features
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.index = try container.decode(ByteSlice.self, forKey: .index)
        self.features = try container.decode([FeatureUnion].self, forKey: .features)
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.index, forKey: .index)
        try container.encode(self.features, forKey: .features)
    }

    enum CodingKeys: String, CodingKey {
        case index
        case features
    }
}

// Represents the ByteSlice
/// The data model definition for the byte slice.
///
/// - Note: According to the AT Protocol specifications: "Specifies the sub-string range a facet feature applies to. Start index is inclusive, end index is exclusive. Indices are zero-indexed, counting bytes of the
/// UTF-8 encoded text. NOTE: some languages, like Javascript, use UTF-16 or Unicode codepoints for string slice indexing; in these languages, convert to byte arrays before working with facets."
///
/// - SeeAlso: This is based on the [`app.bsky.richtext.facet`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/richtext/facet.json
public struct ByteSlice: Codable {
    /// The start index of the byte slice.
    public let byteStart: Int
    /// The end index of the byte slice.
    public let byteEnd: Int

    public init(byteStart: Int, byteEnd: Int) {
        self.byteStart = byteStart
        self.byteEnd = byteEnd
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.byteStart = try container.decode(Int.self, forKey: .byteStart)
        self.byteEnd = try container.decode(Int.self, forKey: .byteEnd)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.byteStart, forKey: .byteStart)
        try container.encode(self.byteEnd, forKey: .byteEnd)
    }

    enum CodingKeys: String, CodingKey {
        case byteStart
        case byteEnd
    }
}

/// A data model protocol for Features.
///
/// - SeeAlso: This is based on the [`app.bsky.richtext.facet`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/richtext/facet.json
internal protocol FeatureCodable: Codable {
    /// The identifier of the lexicon.
    ///
    /// - Warning: The value must not change.
    static var type: String { get }
}


/// A data model for the Mention feature definition.
///
/// - Note: According to the AT Protocol specifications: "Facet feature for mention of another account. The text is usually a handle, including a '@' prefix, but the facet reference is a DID."
///
/// - SeeAlso: This is based on the [`app.bsky.richtext.facet`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/richtext/facet.json
public struct Mention: FeatureCodable {
    /// The decentralized identifier (DID) of the feature.
    public let did: String
    /// The identifier of the lexicon.
    ///
    /// - Warning: The value must not change.
    static public var type: String = "app.bsky.richtext.facet#mention"

    public init(did: String) {
        self.did = did
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.did = try container.decode(String.self, forKey: .did)
        Mention.type = try container.decode(String.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.did, forKey: .did)
        try container.encode(Mention.type, forKey: .type)
    }

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case did
    }
}


/// A data model for the Link feature definition.
///
/// - Note: According to the AT Protocol specifications: "Facet feature for a URL. The text URL may have been simplified or truncated, but the facet reference should be a complete URL."
///
/// - SeeAlso: This is based on the [`app.bsky.richtext.facet`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/richtext/facet.json
public struct Link: FeatureCodable {
    /// The URI of the feature.
    public let uri: String
    /// The identifier of the lexicon.
    ///
    /// - Warning: The value must not change.
    static public var type: String = "app.bsky.richtext.facet#link"

    public init(uri: String) {
        self.uri = uri
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.uri = try container.decode(String.self, forKey: .uri)
        Link.type = try container.decode(String.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.uri, forKey: .uri)
        try container.encode(Link.type, forKey: .type)
    }

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case uri
    }
}

/// A data model for the Tag feature definition.
///
/// - Note: According to the AT Protocol specifications: "Facet feature for a hashtag. The text usually includes a '#' prefix, but the facet reference should not (except in the case of 'double hash tags')."
///
/// - SeeAlso: This is based on the [`app.bsky.richtext.facet`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/richtext/facet.json
public struct Tag: FeatureCodable {
    /// The
    public let tag: String
    /// The identifier of the lexicon.
    ///
    /// - Warning: The value must not change.
    static public var type: String = "app.bsky.richtext.facet#tag"

    public init(tag: String) {
        self.tag = tag
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.tag = try container.decode(String.self, forKey: .tag)
        Tag.type = try container.decode(String.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.tag, forKey: .tag)
        try container.encode(Tag.type, forKey: .type)
    }

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case tag
    }
}

// MARK: - Union types
/// A reference containing the list of feature types.
///
/// - SeeAlso: This is based on the [`app.bsky.richtext.facet`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/richtext/facet.json
public enum FeatureUnion: Codable {
    /// The Mention feature.
    case mention(Mention)
    /// The Link feature.
    case link(Link)
    /// The Tag feature.
    case tag(Tag)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let value = try? container.decode(Mention.self) {
            self = .mention(value)
        } else if let value = try? container.decode(Link.self) {
            self = .link(value)
        } else if let value = try? container.decode(Tag.self) {
            self = .tag(value)
        } else {
            throw DecodingError.typeMismatch(FeatureUnion.self,
                                             DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unknown FeatureUnion type"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
            case .mention(let feature):
                try container.encode(feature)
            case .link(let feature):
                try container.encode(feature)
            case .tag(let feature):
                try container.encode(feature)
        }
    }
}
