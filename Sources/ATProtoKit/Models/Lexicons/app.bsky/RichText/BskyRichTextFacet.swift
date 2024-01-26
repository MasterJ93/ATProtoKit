//
//  BskyRichTextFacet.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-25.
//

import Foundation

public struct Facet: Codable {
    public let index: ByteSlice
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
public struct ByteSlice: Codable {
    public let byteStart: Int
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

public protocol FeatureCodable: Codable {
    static var type: String { get }
}

// Mention feature
public struct Mention: FeatureCodable {
    public let did: String
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

// Link feature
public struct Link: FeatureCodable {
    public let uri: String
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

// Hashtag feature
public struct Tag: FeatureCodable {
    public let tag: String
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

public enum FeatureUnion: Codable {
    case mention(Mention)
    case link(Link)
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
            throw DecodingError.typeMismatch(FeatureUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unknown FeatureUnion type"))
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
