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

            /// An array of strong references to the Atmosphere records that back this embed. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "StrongRefs (uri+cid) of the
            /// Atmosphere records that backed this view."
            public let associatedRefs: [ComAtprotoLexicon.Repository.StrongReference]?

            public init(
                uri: URL,
                title: String,
                description: String,
                thumbnailImage: ComAtprotoLexicon.Repository.UploadBlobOutput?,
                associatedRefs: [ComAtprotoLexicon.Repository.StrongReference]? = nil
            ) {
                self.uri = uri
                self.title = title
                self.description = description
                self.thumbnailImage = thumbnailImage
                self.associatedRefs = associatedRefs
            }

            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.uri = try container.decode(URL.self, forKey: CodingKeys.uri)
                self.title = try container.decode(String.self, forKey: CodingKeys.title)
                self.description = try container.decode(String.self, forKey: CodingKeys.description)
                self.thumbnailImage = try container.decodeIfPresent(ComAtprotoLexicon.Repository.UploadBlobOutput.self, forKey: CodingKeys.thumbnailImage)
                self.associatedRefs = try container.decodeIfPresent([ComAtprotoLexicon.Repository.StrongReference].self, forKey: CodingKeys.associatedRefs)
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(self.type, forKey: CodingKeys.type)
                try container.encode(self.uri, forKey: CodingKeys.uri)
                try container.encode(self.title, forKey: CodingKeys.title)
                try container.encode(self.description, forKey: CodingKeys.description)
                try container.encodeIfPresent(self.thumbnailImage, forKey: CodingKeys.thumbnailImage)
                try container.encodeIfPresent(self.associatedRefs, forKey: CodingKeys.associatedRefs)
            }

            enum CodingKeys: String, CodingKey {
                case type = "$type"
                case uri
                case title
                case description
                case thumbnailImage = "thumb"
                case associatedRefs
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

            /// The date and time the external content was created. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "When the external content was
            /// created, if available. Example: a publication date, for an article."
            public let createdAt: Date?

            /// The date and time the external content was last updated. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "When the external content was
            /// updated, if available."
            public let updatedAt: Date?

            /// The estimated reading time of the external content, in minutes. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "Estimated reading time in
            /// minutes, if applicable and available."
            public let readingTime: Int?

            /// An array of labels attached to the external content. Optional.
            public let labels: [ComAtprotoLexicon.Label.LabelDefinition]?

            /// The source of the external content. Optional.
            public let source: ViewExternalSource?

            /// An array of strong references to the Atmosphere records that backed this view. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "StrongRefs (uri+cid) of the
            /// Atmosphere records that backed this view."
            public let associatedRefs: [ComAtprotoLexicon.Repository.StrongReference]?

            /// An array of profiles of the owners of the Atmosphere records that backed this view. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "Profiles of the owners of the
            /// Atmosphere records that backed this view."
            public let associatedProfiles: [AppBskyLexicon.Actor.ProfileViewBasicDefinition]?

            public init(
                uri: String,
                title: String,
                description: String,
                thumbnailImageURL: URL?,
                createdAt: Date? = nil,
                updatedAt: Date? = nil,
                readingTime: Int? = nil,
                labels: [ComAtprotoLexicon.Label.LabelDefinition]? = nil,
                source: ViewExternalSource? = nil,
                associatedRefs: [ComAtprotoLexicon.Repository.StrongReference]? = nil,
                associatedProfiles: [AppBskyLexicon.Actor.ProfileViewBasicDefinition]? = nil
            ) {
                self.uri = uri
                self.title = title
                self.description = description
                self.thumbnailImageURL = thumbnailImageURL
                self.createdAt = createdAt
                self.updatedAt = updatedAt
                self.readingTime = readingTime
                self.labels = labels
                self.source = source
                self.associatedRefs = associatedRefs
                self.associatedProfiles = associatedProfiles
            }

            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.uri = try container.decode(String.self, forKey: CodingKeys.uri)
                self.title = try container.decode(String.self, forKey: CodingKeys.title)
                self.description = try container.decode(String.self, forKey: CodingKeys.description)
                self.thumbnailImageURL = try container.decodeIfPresent(URL.self, forKey: CodingKeys.thumbnailImageURL)
                self.createdAt = try container.decodeDateIfPresent(forKey: CodingKeys.createdAt)
                self.updatedAt = try container.decodeDateIfPresent(forKey: CodingKeys.updatedAt)
                self.readingTime = try container.decodeIfPresent(Int.self, forKey: CodingKeys.readingTime)
                self.labels = try container.decodeIfPresent([ComAtprotoLexicon.Label.LabelDefinition].self, forKey: CodingKeys.labels)
                self.source = try container.decodeIfPresent(ViewExternalSource.self, forKey: CodingKeys.source)
                self.associatedRefs = try container.decodeIfPresent([ComAtprotoLexicon.Repository.StrongReference].self, forKey: CodingKeys.associatedRefs)
                self.associatedProfiles = try container.decodeIfPresent([AppBskyLexicon.Actor.ProfileViewBasicDefinition].self, forKey: CodingKeys.associatedProfiles)
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(self.type, forKey: CodingKeys.type)
                try container.encode(self.uri, forKey: CodingKeys.uri)
                try container.encode(self.title, forKey: CodingKeys.title)
                try container.encode(self.description, forKey: CodingKeys.description)
                try container.encodeIfPresent(self.thumbnailImageURL, forKey: CodingKeys.thumbnailImageURL)
                try container.encodeDateIfPresent(self.createdAt, forKey: CodingKeys.createdAt)
                try container.encodeDateIfPresent(self.updatedAt, forKey: CodingKeys.updatedAt)
                try container.encodeIfPresent(self.readingTime, forKey: CodingKeys.readingTime)
                try container.encodeIfPresent(self.labels, forKey: CodingKeys.labels)
                try container.encodeIfPresent(self.source, forKey: CodingKeys.source)
                try container.encodeIfPresent(self.associatedRefs, forKey: CodingKeys.associatedRefs)
                try container.encodeIfPresent(self.associatedProfiles, forKey: CodingKeys.associatedProfiles)
            }

            enum CodingKeys: String, CodingKey {
                case type = "$type"
                case uri
                case title
                case description
                case thumbnailImageURL = "thumb"
                case createdAt
                case updatedAt
                case readingTime
                case labels
                case source
                case associatedRefs
                case associatedProfiles
            }
        }

        /// A data model for the source of external content.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.embed.external`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/external.json
        public struct ViewExternalSource: Sendable, Codable, Equatable, Hashable {

            /// The identifier of the lexicon.
            ///
            /// - Warning: The value must not change.
            public let type: String = "app.bsky.embed.external#viewExternalSource"

            /// The URI of the source.
            ///
            /// - Note: According to the AT Protocol specifications: "URI of the source, if available.
            /// Example: the https:// URL of a site.standard.publication record."
            public let uri: URL

            /// The URL of an icon representing the source. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "Fully-qualified URL where an
            /// icon representing the source can be fetched. For example, CDN location provided by
            /// the App View."
            public let icon: URL?

            /// The title of the source.
            public let title: String

            /// The description of the source. Optional.
            public let description: String?

            /// The theme colors of the source. Optional.
            public let theme: ViewExternalSourceTheme?

            public init(uri: URL, icon: URL?, title: String, description: String?, theme: ViewExternalSourceTheme?) {
                self.uri = uri
                self.icon = icon
                self.title = title
                self.description = description
                self.theme = theme
            }

            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.uri = try container.decode(URL.self, forKey: CodingKeys.uri)
                self.icon = try container.decodeIfPresent(URL.self, forKey: CodingKeys.icon)
                self.title = try container.decode(String.self, forKey: CodingKeys.title)
                self.description = try container.decodeIfPresent(String.self, forKey: CodingKeys.description)
                self.theme = try container.decodeIfPresent(ViewExternalSourceTheme.self, forKey: CodingKeys.theme)
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(self.type, forKey: CodingKeys.type)
                try container.encode(self.uri, forKey: CodingKeys.uri)
                try container.encodeIfPresent(self.icon, forKey: CodingKeys.icon)
                try container.encode(self.title, forKey: CodingKeys.title)
                try container.encodeIfPresent(self.description, forKey: CodingKeys.description)
                try container.encodeIfPresent(self.theme, forKey: CodingKeys.theme)
            }

            enum CodingKeys: String, CodingKey {
                case type = "$type"
                case uri
                case icon
                case title
                case description
                case theme
            }
        }

        /// A data model for the theme colors of an external source.
        ///
        /// - Note: According to the AT Protocol specifications: "The theme colors of an external
        /// source, such as a site.standard.publication. These colors may be used when rendering an
        /// embed from that source."
        ///
        /// - SeeAlso: This is based on the [`app.bsky.embed.external`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/external.json
        public struct ViewExternalSourceTheme: Sendable, Codable, Equatable, Hashable {

            /// The identifier of the lexicon.
            ///
            /// - Warning: The value must not change.
            public let type: String = "app.bsky.embed.external#viewExternalSourceTheme"

            /// The background color of the source. Optional.
            public let backgroundRGB: ColorRGB?

            /// The foreground color of the source. Optional.
            public let foregroundRGB: ColorRGB?

            /// The accent color of the source. Optional.
            public let accentRGB: ColorRGB?

            /// The foreground color used on top of the accent color. Optional.
            public let accentForegroundRGB: ColorRGB?

            public init(backgroundRGB: ColorRGB?, foregroundRGB: ColorRGB?, accentRGB: ColorRGB?, accentForegroundRGB: ColorRGB?) {
                self.backgroundRGB = backgroundRGB
                self.foregroundRGB = foregroundRGB
                self.accentRGB = accentRGB
                self.accentForegroundRGB = accentForegroundRGB
            }

            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.backgroundRGB = try container.decodeIfPresent(ColorRGB.self, forKey: CodingKeys.backgroundRGB)
                self.foregroundRGB = try container.decodeIfPresent(ColorRGB.self, forKey: CodingKeys.foregroundRGB)
                self.accentRGB = try container.decodeIfPresent(ColorRGB.self, forKey: CodingKeys.accentRGB)
                self.accentForegroundRGB = try container.decodeIfPresent(ColorRGB.self, forKey: CodingKeys.accentForegroundRGB)
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(self.type, forKey: CodingKeys.type)
                try container.encodeIfPresent(self.backgroundRGB, forKey: CodingKeys.backgroundRGB)
                try container.encodeIfPresent(self.foregroundRGB, forKey: CodingKeys.foregroundRGB)
                try container.encodeIfPresent(self.accentRGB, forKey: CodingKeys.accentRGB)
                try container.encodeIfPresent(self.accentForegroundRGB, forKey: CodingKeys.accentForegroundRGB)
            }

            enum CodingKeys: String, CodingKey {
                case type = "$type"
                case backgroundRGB
                case foregroundRGB
                case accentRGB
                case accentForegroundRGB
            }
        }

        /// A data model for an RGB color definition.
        ///
        /// - Note: According to the AT Protocol specifications: "RGB color definition, inspired by
        /// site.standard.theme.color#rgb."
        ///
        /// - SeeAlso: This is based on the [`app.bsky.embed.external`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/external.json
        public struct ColorRGB: Sendable, Codable, Equatable, Hashable {

            /// The identifier of the lexicon.
            ///
            /// - Warning: The value must not change.
            public let type: String = "app.bsky.embed.external#colorRGB"

            /// The red color channel.
            ///
            /// - Note: This value can be between `0` and `255`.
            public let r: Int

            /// The green color channel.
            ///
            /// - Note: This value can be between `0` and `255`.
            public let g: Int

            /// The blue color channel.
            ///
            /// - Note: This value can be between `0` and `255`.
            public let b: Int

            public init(r: Int, g: Int, b: Int) {
                self.r = r
                self.g = g
                self.b = b
            }

            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.r = try container.decode(Int.self, forKey: CodingKeys.r)
                self.g = try container.decode(Int.self, forKey: CodingKeys.g)
                self.b = try container.decode(Int.self, forKey: CodingKeys.b)
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(self.type, forKey: CodingKeys.type)
                try container.encode(self.r, forKey: CodingKeys.r)
                try container.encode(self.g, forKey: CodingKeys.g)
                try container.encode(self.b, forKey: CodingKeys.b)
            }

            enum CodingKeys: String, CodingKey {
                case type = "$type"
                case r
                case g
                case b
            }
        }
    }
}
