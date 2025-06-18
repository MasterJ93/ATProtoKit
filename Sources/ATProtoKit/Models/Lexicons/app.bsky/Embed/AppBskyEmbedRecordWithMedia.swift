//
//  AppBskyEmbedRecordWithMedia.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-17.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Embed {

    /// A definition model for a record embedded with some form of compatible media.
    ///
    /// - Note: According to the AT Protocol specifications: "A representation of a record
    /// embedded in a Bluesky record (eg, a post), alongside other compatible embeds. For example,
    /// a quote post and image, or a quote post and external URL card."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.embed.recordWithMedia][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/recordWithMedia.json
    public struct RecordWithMediaDefinition: Sendable, Codable, Equatable, Hashable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public let type: String = "app.bsky.embed.recordWithMedia"

        /// The record that will be embedded.
        public let record: RecordDefinition

        /// The media of a specific type.
        public let media: MediaUnion

        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case record
            case media
        }

        // Unions
        /// The media of a specific type.
        public enum MediaUnion: ATUnionProtocol, Equatable, Hashable {

            /// An image that will be embedded.
            case embedImages(AppBskyLexicon.Embed.ImagesDefinition)

            /// An external link that will be embedded.
            case embedExternal(AppBskyLexicon.Embed.ExternalDefinition)

            /// A video that will be embedded.
            case embedVideo(AppBskyLexicon.Embed.VideoDefinition)

            /// An unknown case.
            case unknown(String, [String: CodableValue])

            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let type = try container.decode(String.self, forKey: .type)

                switch type {
                    case "app.bsky.embed.images":
                        self = .embedImages(try AppBskyLexicon.Embed.ImagesDefinition(from: decoder))
                    case "app.bsky.embed.video":
                        self = .embedVideo(try AppBskyLexicon.Embed.VideoDefinition(from: decoder))
                    case "app.bsky.embed.external":
                        self = .embedExternal(try AppBskyLexicon.Embed.ExternalDefinition(from: decoder))
                    default:
                        let singleValueDecodingContainer = try decoder.singleValueContainer()
                        let dictionary = try Self.decodeDictionary(from: singleValueDecodingContainer, decoder: decoder)

                        self = .unknown(type, dictionary)
                }
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()

                switch self {
                    case .embedImages(let media):
                        try container.encode(media)
                    case .embedExternal(let media):
                        try container.encode(media)
                    case .embedVideo(let value):
                        try container.encode(value)
                    default:
                        break
                }
            }

            enum CodingKeys: String, CodingKey {
                case type = "$type"
            }
        }

        /// A data model for a definition which contains an embedded record and embedded media.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.embed.recordWithMedia`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/recordWithMedia.json
        public struct View: Sendable, Codable, Equatable, Hashable {

            /// The identifier of the lexicon.
            ///
            /// - Warning: The value must not change.
            public let type: String = "app.bsky.embed.recordWithMedia#view"

            /// The embeded record.
            public let record: AppBskyLexicon.Embed.RecordDefinition.View

            /// The embedded media.
            public let media: MediaUnion

            enum CodingKeys: String, CodingKey {
                case type = "$type"
                case record
                case media
            }

            // Unions
            /// The embedded media.
            public enum MediaUnion: ATUnionProtocol, Equatable, Hashable {

                /// An image that's been embedded.
                case embedImagesView(AppBskyLexicon.Embed.ImagesDefinition.View)

                /// A video tht's been embedded.
                case embedVideoView(AppBskyLexicon.Embed.VideoDefinition.View)

                /// An external link that's been embedded.
                case embedExternalView(AppBskyLexicon.Embed.ExternalDefinition.View)

                /// An unknown case.
                case unknown(String, [String: CodableValue])

                public init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeys.self)
                    let type = try container.decode(String.self, forKey: .type)

                    switch type {
                        case "app.bsky.embed.images#view":
                            self = .embedImagesView(try AppBskyLexicon.Embed.ImagesDefinition.View(from: decoder))
                        case "app.bsky.embed.video#view":
                            self = .embedVideoView(try AppBskyLexicon.Embed.VideoDefinition.View(from: decoder))
                        case "app.bsky.embed.external#view":
                            self = .embedExternalView(try AppBskyLexicon.Embed.ExternalDefinition.View(from: decoder))
                        default:
                            let singleValueDecodingContainer = try decoder.singleValueContainer()
                            let dictionary = try Self.decodeDictionary(from: singleValueDecodingContainer, decoder: decoder)

                            self = .unknown(type, dictionary)
                    }
                }

                public func encode(to encoder: Encoder) throws {
                    var container = encoder.singleValueContainer()

                    switch self {
                        case .embedImagesView(let value):
                            try container.encode(value)
                        case .embedVideoView(let value):
                            try container.encode(value)
                        case .embedExternalView(let value):
                            try container.encode(value)
                        default:
                            break
                    }
                }

                enum CodingKeys: String, CodingKey {
                    case type = "$type"
                }
            }
        }
    }
}
