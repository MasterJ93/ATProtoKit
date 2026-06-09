//
//  AppBskyEmbedGallery.swift
//
//
//  Created on 2026-06-08.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Embed {

    /// A definition model for gallery embeds.
    ///
    /// - Note: According to the AT Protocol specifications: "A set of images embedded in a Bluesky
    /// record (eg, a post). Successor to `app.bsky.embed.images`, supporting a larger number
    /// of images per post."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.embed.gallery`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/gallery.json
    public struct GalleryDefinition: Sendable, Codable, Equatable, Hashable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public let type: String = "app.bsky.embed.gallery"

        /// The items in the gallery
        ///
        /// - Important: The schema-level maxLength of 20 is a future-proof ceiling. Clients should currently enforce a soft limit of 10 items in authoring UIs.
        public let items: [ItemUnion]
        
        
        public init(items: [ItemUnion]) {
            self.items = items
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            self.items = try container.decode([ItemUnion].self, forKey: .items)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(self.type, forKey: CodingKeys.type)
            try container.truncatedEncodeIfPresent(self.items, forKey: CodingKeys.items, upToArrayLength: 10)
        }

        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case items
        }

        // Unions
        /// A specific gallery item
        public enum ItemUnion: ATUnionProtocol, Equatable, Hashable {
            
            /// A gallery image.
            case itemImage(AppBskyLexicon.Embed.GalleryDefinition.Image)
            
            // An unknown case.
            case unknown(String, [String: CodableValue])
            
            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let type = try container.decodeIfPresent(String.self, forKey: .type)
                
                switch type {
                    case "app.bsky.embed.gallery#image":
                        self = .itemImage(try AppBskyLexicon.Embed.GalleryDefinition.Image(from: decoder))
                    default:
                        let singleValueDecodingContainer = try decoder.singleValueContainer()
                        let dictionary = try Self.decodeDictionary(from: singleValueDecodingContainer, decoder: decoder)

                        self = .unknown(type ?? "unknown", dictionary)
                }
            }
            
            public func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()
                
                switch self {
                    case .itemImage(let value):
                        try container.encode(value)
                    default:
                        break
                }
            }
            
            enum CodingKeys: String, CodingKey {
                case type = "$type"
            }
        }
        
        // Enums
        /// A data model for an external definition.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.embed.gallery`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/gallery.json
        public struct Image: Sendable, Codable, Equatable, Hashable {

            /// The identifier of the lexicon.
            ///
            /// - Warning: The value must not change.
            public static let type: String = "app.bsky.embed.gallery#image"

            /// The image that needs to be uploaded.
            ///
            /// - Warning: The image size can't be higher than 2 MB. Failure to do so will result
            /// in the image failing to upload.
            public let imageBlob: ComAtprotoLexicon.Repository.UploadBlobOutput

            /// The alternative text for the image.
            ///
            /// - Note: From the AT Protocol specification: "Alt text description of the image,
            /// for accessibility."
            public let altText: String

            /// The aspect ratio of the image. Optional.
            public let aspectRatio: AspectRatioDefinition?

            public init(imageBlob: ComAtprotoLexicon.Repository.UploadBlobOutput, altText: String, aspectRatio: AspectRatioDefinition?) {
                self.imageBlob = imageBlob
                self.altText = altText
                self.aspectRatio = aspectRatio
            }

            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.imageBlob = try container.decode(ComAtprotoLexicon.Repository.UploadBlobOutput.self, forKey: CodingKeys.imageBlob)
                self.altText = try container.decode(String.self, forKey: CodingKeys.altText)
                self.aspectRatio = try container.decodeIfPresent(AppBskyLexicon.Embed.AspectRatioDefinition.self, forKey: CodingKeys.aspectRatio)
            }
            
            public func encode(to encoder: any Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(Self.type, forKey: CodingKeys.type)
                try container.encode(self.imageBlob, forKey: CodingKeys.imageBlob)
                try container.encode(self.altText, forKey: CodingKeys.altText)
                try container.encodeIfPresent(self.aspectRatio, forKey: CodingKeys.aspectRatio)
            }
            
            enum CodingKeys: String, CodingKey {
                case type = "$type"
                case imageBlob = "image"
                case altText = "alt"
                case aspectRatio
            }
        }
        /// A data model for the embed gallery view definition.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.embed.gallery`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/gallery.json
        public struct View: Sendable, Codable, Equatable, Hashable {

            /// The identifier of the lexicon.
            ///
            /// - Warning: The value must not change.
            public let type: String = "app.bsky.embed.gallery#view"

            /// An array of images.
            public let items: [ViewImage]

            public init(items: [ViewImage]) {
                self.items = items
            }

            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                self.items = try container.decode([AppBskyLexicon.Embed.GalleryDefinition.ViewImage].self, forKey: .items)
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)

                try container.encode(self.type, forKey: .type)
                try container.encode(self.items, forKey: .items)
            }

            public enum CodingKeys: String, CodingKey {
                case type = "$type"
                case items
            }
        }

        /// A data model for a definition related to viewing a gallery image.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.embed.gallery`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/gallery.json
        public struct ViewImage: Sendable, Codable, Equatable, Hashable {

            /// The identifier of the lexicon.
            ///
            /// - Warning: The value must not change.
            public let type: String = "app.bsky.embed.gallery#viewImage"

            /// The URI of the image's thumbnail.
            ///
            /// - Note: From the AT Protocol specification: "Fully-qualified URL where a thumbnail
            /// of the image can be fetched. For example, CDN location provided by the App View."
            public let thumbnailImageURL: URL

            /// The URI of the fully-sized image.
            ///
            /// - Note: From the AT Protocol specification: "Fully-qualified URL where a large
            /// version of the image can be fetched. May or may not be the exact original blob.
            /// For example, CDN location provided by the App View."
            public let fullSizeImageURL: URL

            /// The alternative text for the image.
            ///
            /// - Note: From the AT Protocol specification: "Alt text description of the image,
            /// for accessibility."
            public let altText: String

            /// The aspect ratio of the image. Optional.
            public let aspectRatio: AspectRatioDefinition?

            public init(thumbnailImageURL: URL, fullSizeImageURL: URL, altText: String, aspectRatio: AspectRatioDefinition?) {
                self.thumbnailImageURL = thumbnailImageURL
                self.fullSizeImageURL = fullSizeImageURL
                self.altText = altText
                self.aspectRatio = aspectRatio
            }

            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.thumbnailImageURL = try container.decode(URL.self, forKey: CodingKeys.thumbnailImageURL)
                self.fullSizeImageURL = try container.decode(URL.self, forKey: CodingKeys.fullSizeImageURL)
                self.altText = try container.decode(String.self, forKey: CodingKeys.altText)
                self.aspectRatio = try container.decodeIfPresent(AppBskyLexicon.Embed.AspectRatioDefinition.self, forKey: CodingKeys.aspectRatio)
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)

                try container.encode(self.type, forKey: .type)
                try container.encode(self.thumbnailImageURL, forKey: .thumbnailImageURL)
                try container.encode(self.fullSizeImageURL, forKey: .fullSizeImageURL)
                try container.encode(self.altText, forKey: .altText)
                try container.encodeIfPresent(self.aspectRatio, forKey: .aspectRatio)
            }

            enum CodingKeys: String, CodingKey {
                case type = "$type"
                case thumbnailImageURL = "thumbnail"
                case fullSizeImageURL = "fullsize"
                case altText = "alt"
                case aspectRatio
            }
        }
    }
}
