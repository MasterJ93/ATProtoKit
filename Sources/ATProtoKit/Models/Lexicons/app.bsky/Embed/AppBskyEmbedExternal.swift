//
//  AppBskyEmbedExternal.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-17.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Embed {

    /// A definition model for external embeds.
    ///
    /// - Note: According to the AT Protocol specifications: "A representation of some externally
    /// linked content (eg, a URL and 'card'), embedded in a Bluesky record (eg, a post)."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.embed.external`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/external.json
    public struct ExternalDefinition: Sendable, Codable, Equatable, Hashable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public let type: String = "app.bsky.embed.external"

        /// The external content needed to be embeeded.
        public let external: External

        public init(external: External) {
            self.external = external
        }
        
        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.external = try container.decode(AppBskyLexicon.Embed.ExternalDefinition.External.self, forKey: CodingKeys.external)
        }
        
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(self.type, forKey: CodingKeys.type)
            try container.encode(self.external, forKey: CodingKeys.external)
        }
        
        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case external
        }

        // Enums
        /// An external embed object.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.embed.external`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/external.json
        public struct External: Sendable, Codable, Equatable, Hashable {

            /// The identifier of the lexicon.
            ///
            /// - Warning: The value must not change.
            public let type: String = "app.bsky.embed.external#external"

            /// The URI of the external content.
            public let uri: URL

            /// The title of the external content.
            public let title: String

            /// The description of the external content.
            public let description: String

            /// The thumbnail image of the external content.
            ///
            /// - Warning: The image size can't be higher than 1 MB. Failure to do so will result
            /// in the image failing to upload.
            public let thumbnailImage: ComAtprotoLexicon.Repository.UploadBlobOutput?

            public init(uri: URL, title: String, description: String, thumbnailImage: ComAtprotoLexicon.Repository.UploadBlobOutput?) {
                self.uri = uri
                self.title = title
                self.description = description
                self.thumbnailImage = thumbnailImage
            }
            
            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.uri = try container.decode(URL.self, forKey: CodingKeys.uri)
                self.title = try container.decode(String.self, forKey: CodingKeys.title)
                self.description = try container.decode(String.self, forKey: CodingKeys.description)
                self.thumbnailImage = try container.decodeIfPresent(ComAtprotoLexicon.Repository.UploadBlobOutput.self, forKey: CodingKeys.thumbnailImage)
            }
            
            public func encode(to encoder: any Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(self.type, forKey: CodingKeys.type)
                try container.encode(self.uri, forKey: CodingKeys.uri)
                try container.encode(self.title, forKey: CodingKeys.title)
                try container.encode(self.description, forKey: CodingKeys.description)
                try container.encodeIfPresent(self.thumbnailImage, forKey: CodingKeys.thumbnailImage)
            }
            
            enum CodingKeys: String, CodingKey {
                case type = "$type"
                case uri
                case title
                case description
                case thumbnailImage = "thumb"
            }
        }

        /// A data model for an external view definition.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.embed.external`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/external.json
        public struct View: Sendable, Codable, Equatable, Hashable {

            /// The identifier of the lexicon.
            ///
            /// - Warning: The value must not change.
            public let type: String = "app.bsky.embed.external#view"

            /// The external content embedded in a post.
            public let external: ViewExternal

            public init(external: ViewExternal) {
                self.external = external
            }
            
            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.external = try container.decode(ViewExternal.self, forKey: CodingKeys.external)
            }
            
            public func encode(to encoder: any Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(self.type, forKey: CodingKeys.type)
                try container.encode(self.external, forKey: CodingKeys.external)
            }
            
            enum CodingKeys: String, CodingKey {
                case type = "$type"
                case external
            }
        }

        /// A data model for a definition for the external content.
        public struct ViewExternal: Sendable, Codable, Equatable, Hashable {

            /// The identifier of the lexicon.
            ///
            /// - Warning: The value must not change.
            public let type: String = "app.bsky.embed.external#viewExternal"

            /// The URI of the external content.
            public let uri: String

            /// The title of the external content.
            public let title: String

            /// The description of the external content.
            public let description: String

            /// The thumbnail image URL of the external content.
            public let thumbnailImageURL: URL?

            public init(uri: String, title: String, description: String, thumbnailImageURL: URL?) {
                self.uri = uri
                self.title = title
                self.description = description
                self.thumbnailImageURL = thumbnailImageURL
            }
            
            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.uri = try container.decode(String.self, forKey: CodingKeys.uri)
                self.title = try container.decode(String.self, forKey: CodingKeys.title)
                self.description = try container.decode(String.self, forKey: CodingKeys.description)
                self.thumbnailImageURL = try container.decodeIfPresent(URL.self, forKey: CodingKeys.thumbnailImageURL)
            }
            
            public func encode(to encoder: any Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(self.type, forKey: CodingKeys.type)
                try container.encode(self.uri, forKey: CodingKeys.uri)
                try container.encode(self.title, forKey: CodingKeys.title)
                try container.encode(self.description, forKey: CodingKeys.description)
                try container.encodeIfPresent(self.thumbnailImageURL, forKey: CodingKeys.thumbnailImageURL)
            }
            
            enum CodingKeys: String, CodingKey {
                case type = "$type"
                case uri
                case title
                case description
                case thumbnailImageURL = "thumb"
            }
        }
    }
}
