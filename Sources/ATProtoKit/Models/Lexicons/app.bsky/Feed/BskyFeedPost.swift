//
//  BskyFeedPost.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-27.
//

import Foundation

public struct FeedPost: Codable {
    internal let type: String = "app.bsky.feed.post"
    public let text: String
    public var entities: [Entity]? = nil // Deprecated
    public var facets: [Facet]? = nil
    public var reply: ReplyReference? = nil
    public var embed: EmbedUnion? = nil
    public var langs: [String]? = nil
    public var labels: FeedLabelUnion? = nil
    public var tags: [String]? = nil
    @DateFormatting public var createdAt: Date

    public init(text: String, entities: [Entity]? = nil, facets: [Facet]? = nil, reply: ReplyReference? = nil, embed: EmbedUnion? = nil, langs: [String]? = nil, labels: FeedLabelUnion? = nil, tags: [String]? = nil, createdAt: Date) {
        self.text = text
        self.entities = entities
        self.facets = facets
        self.reply = reply
        self.embed = embed
        self.langs = langs
        self.labels = labels
        self.tags = tags
        self._createdAt = DateFormatting(wrappedValue: createdAt)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.text = try container.decode(String.self, forKey: .text)
        self.entities = try container.decodeIfPresent([Entity].self, forKey: .entities)
        self.facets = try container.decodeIfPresent([Facet].self, forKey: .facets)
        self.reply = try container.decodeIfPresent(ReplyReference.self, forKey: .reply)
        self.embed = try container.decodeIfPresent(EmbedUnion.self, forKey: .embed)
        self.langs = try container.decodeIfPresent([String].self, forKey: .langs)
        self.labels = try container.decodeIfPresent(FeedLabelUnion.self, forKey: .labels)
        self.tags = try container.decodeIfPresent([String].self, forKey: .tags)
        self._createdAt = try container.decode(DateFormatting.self, forKey: .createdAt)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.type, forKey: .type)
        try container.encode(self.text, forKey: .text)
        try container.encodeIfPresent(self.entities, forKey: .entities)
        try container.encodeIfPresent(self.facets, forKey: .facets)
        try container.encodeIfPresent(self.reply, forKey: .reply)
        try container.encodeIfPresent(self.embed, forKey: .embed)
        try container.encodeIfPresent(self.langs, forKey: .langs)
        try container.encodeIfPresent(self.labels, forKey: .labels)
        try container.encodeIfPresent(self.tags, forKey: .tags)
        try container.encode(self.createdAt, forKey: .createdAt)
    }

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case text
        case entities
        case facets
        case reply
        case embed
        case langs
        case labels
        case tags
        case createdAt
    }
}

public struct ReplyReference: Codable {
    public let root: StrongReference
    public let parent: StrongReference

    public init(root: StrongReference, parent: StrongReference) {
        self.root = root
        self.parent = parent
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.root = try container.decode(StrongReference.self, forKey: .root)
        self.parent = try container.decode(StrongReference.self, forKey: .parent)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.root, forKey: .root)
        try container.encode(self.parent, forKey: .parent)
    }

    enum CodingKeys: CodingKey {
        case root
        case parent
    }
}

// Deprecated
public struct Entity: Codable {
    public let index: TextSlice
    public let type: String
    public let value: String
}

// Deprecated
public struct TextSlice: Codable {
    public let start: Int
    public let end: Int
}

public enum EmbedUnion: Codable {
    case images(EmbedImages)
    case external(EmbedExternal)
    case record(EmbedRecord)
    case recordWithMedia(EmbedRecordWithMedia)

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let imagesValue = try container.decodeIfPresent(EmbedImages.self, forKey: .images) {
            self = .images(imagesValue)
        } else if let externalValue = try container.decodeIfPresent(EmbedExternal.self, forKey: .external) {
            self = .external(externalValue)
        } else if let recordValue = try container.decodeIfPresent(EmbedRecord.self, forKey: .record) {
            self = .record(recordValue)
        } else if let recordWithMediaValue = try container.decodeIfPresent(EmbedRecordWithMedia.self, forKey: .recordWithMedia) {
            self = .recordWithMedia(recordWithMediaValue)
        } else {
            throw DecodingError.dataCorruptedError(forKey: .images, in: container, debugDescription: "Unable to decode Embed")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
            case .images(let imagesValue):
                try container.encode(imagesValue, forKey: .images)
            case .external(let externalValue):
                try container.encode(externalValue, forKey: .external)
            case .record(let recordValue):
                try container.encode(recordValue, forKey: .record)
            case .recordWithMedia(let recordWithMediaValue):
                try container.encode(recordWithMediaValue, forKey: .recordWithMedia)
        }
    }

    enum CodingKeys: String, CodingKey {
        case images
        case external
        case record
        case recordWithMedia
    }
}



public enum FeedLabelUnion: Codable {
    case selfLabels(SelfLabels)

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let selfLabelsValue = try container.decode(SelfLabels.self, forKey: .selfLabels)
        self = .selfLabels(selfLabelsValue)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        if case .selfLabels(let selfLabelsValue) = self {
            try container.encode(selfLabelsValue, forKey: .selfLabels)
        }
    }

    enum CodingKeys: String, CodingKey {
        case selfLabels
    }
}
