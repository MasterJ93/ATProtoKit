//
//  BskyEmbedRecordWithMedia.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-27.
//

import Foundation

public struct EmbedRecordWithMedia: Codable {
    public let type: String = "app.bsky.embed.recordWithMedia"
    public let record: EmbedRecord
    public let media: MediaUnion

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case record
        case media
    }
}

public struct EmbedRecordWithMediaView: Codable {
    public let record: EmbedRecordView
    public let media: MediaViewUnion
}

public enum MediaUnion: Codable {
    case embedImages(EmbedImages)
    case embedExternal(EmbedExternal)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let value = try? container.decode(EmbedImages.self) {
            self = .embedImages(value)
        } else if let value = try? container.decode(EmbedExternal.self) {
            self = .embedExternal(value)
        } else {
            throw DecodingError.typeMismatch(PostUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unknown MediaUnion type"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
            case .embedImages(let media):
                try container.encode(media)
            case .embedExternal(let media):
                try container.encode(media)
        }
    }
}

public enum MediaViewUnion: Codable {
    case embedImagesView(EmbedImagesView)
    case embedExternalView(EmbedExternalView)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let value = try? container.decode(EmbedImagesView.self) {
            self = .embedImagesView(value)
        } else if let value = try? container.decode(EmbedExternalView.self) {
            self = .embedExternalView(value)
        } else {
            throw DecodingError.typeMismatch(PostUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unknown MediaViewUnion type"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
            case .embedImagesView(let mediaView):
                try container.encode(mediaView)
            case .embedExternalView(let mediaView):
                try container.encode(mediaView)
        }
    }
}
