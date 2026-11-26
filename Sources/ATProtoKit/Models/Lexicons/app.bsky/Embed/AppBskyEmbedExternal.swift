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
            public let uri: String

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
                uri: String,
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
                self.uri = try container.decode(String.self, forKey: CodingKeys.uri)
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

            /// The hydrated modality-specific data for the external embed. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "Hydrated modality-specific data
            /// for the external embed, when available."
            public let data: DataUnion?

            public init(external: ViewExternal, data: DataUnion? = nil) {
                self.external = external
                self.data = data
            }

            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.external = try container.decode(ViewExternal.self, forKey: CodingKeys.external)
                self.data = try container.decodeIfPresent(DataUnion.self, forKey: CodingKeys.data)
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(self.type, forKey: CodingKeys.type)
                try container.encode(self.external, forKey: CodingKeys.external)
                try container.encodeIfPresent(self.data, forKey: CodingKeys.data)
            }

            enum CodingKeys: String, CodingKey {
                case type = "$type"
                case external
                case data
            }

            // Unions
            /// The hydrated modality-specific data for the external embed.
            public enum DataUnion: ATUnionProtocol, Equatable, Hashable {

                /// The view of an article.
                case viewArticle(AppBskyLexicon.Embed.ExternalDefinition.ViewArticle)

                /// The view of an article publication.
                case viewArticlePublication(AppBskyLexicon.Embed.ExternalDefinition.ViewArticlePublication)

                /// The view of a gallery.
                case viewGallery(AppBskyLexicon.Embed.ExternalDefinition.ViewGallery)

                /// The view of a livestream.
                case viewLivestream(AppBskyLexicon.Embed.ExternalDefinition.ViewLivestream)

                /// An unknown case.
                case unknown(String, [String: CodableValue])

                public init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeys.self)
                    let type = try container.decodeIfPresent(String.self, forKey: .type)

                    switch type {
                        case "app.bsky.embed.external#viewArticle":
                            self = .viewArticle(try AppBskyLexicon.Embed.ExternalDefinition.ViewArticle(from: decoder))
                        case "app.bsky.embed.external#viewArticlePublication":
                            self = .viewArticlePublication(try AppBskyLexicon.Embed.ExternalDefinition.ViewArticlePublication(from: decoder))
                        case "app.bsky.embed.external#viewGallery":
                            self = .viewGallery(try AppBskyLexicon.Embed.ExternalDefinition.ViewGallery(from: decoder))
                        case "app.bsky.embed.external#viewLivestream":
                            self = .viewLivestream(try AppBskyLexicon.Embed.ExternalDefinition.ViewLivestream(from: decoder))
                        default:
                            let singleValueDecodingContainer = try decoder.singleValueContainer()
                            let dictionary = try Self.decodeDictionary(from: singleValueDecodingContainer, decoder: decoder)

                            self = .unknown(type ?? "unknown", dictionary)
                    }
                }

                public func encode(to encoder: any Encoder) throws {
                    var container = encoder.singleValueContainer()

                    switch self {
                        case .viewArticle(let value):
                            try container.encode(value)
                        case .viewArticlePublication(let value):
                            try container.encode(value)
                        case .viewGallery(let value):
                            try container.encode(value)
                        case .viewLivestream(let value):
                            try container.encode(value)
                        case .unknown(_, let dictionary):
                            try container.encode(dictionary)
                    }
                }

                enum CodingKeys: String, CodingKey {
                    case type = "$type"
                }
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

        /// A data model for the view of an article.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.embed.external`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/embed/external.json
        public struct ViewArticle: Sendable, Codable, Equatable, Hashable {

            /// The identifier of the lexicon.
            ///
            /// - Warning: The value must not change.
            public let type: String = "app.bsky.embed.external#viewArticle"

            /// The provider domain of the article. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "Best-effort provider domain for
            /// cosmetic attribution, such as pckt.blog. Not verified provenance."
            ///
            /// - Note: Current maximum length is 128 characters.
            public let providerID: String?

            /// The URI of the article.
            public let uri: String

            /// The title of the article.
            public let title: String

            /// The description of the article.
            public let description: String

            /// The date and time the article was created. Optional.
            public let createdAt: Date?

            /// The date and time the article was last updated. Optional.
            public let updatedAt: Date?

            /// An array of labels attached to the article. Optional.
            public let labels: [ComAtprotoLexicon.Label.LabelDefinition]?

            /// An array of strong references to the Atmosphere records that backed this view. Optional.
            public let associatedRefs: [ComAtprotoLexicon.Repository.StrongReference]?

            /// An array of profiles of the owners of the Atmosphere records that backed this view. Optional.
            public let associatedProfiles: [AppBskyLexicon.Actor.ProfileViewBasicDefinition]?

            /// The image URL of the article. Optional.
            public let imageURL: URL?

            /// The publication the article belongs to. Optional.
            public let publisher: ViewArticlePublication?

            /// The estimated reading time of the article, in minutes. Optional.
            ///
            /// - Note: Current minimum value is `1`.
            public let readingTime: Int?

            /// The viewer state of the article. Optional.
            public let viewer: ViewArticleViewerState?

            /// The number of likes the article has. Optional.
            public let likeCount: Int?

            /// An array of profile previews of user accounts that liked the article. Optional.
            ///
            /// - Important: This property is deprecated. Use ``ViewArticleViewerState/knownLikers``
            /// instead.
            ///
            /// - Note: According to the AT Protocol specifications: "Available profile previews.
            /// Selected deterministically by DID; not a ranking. Deprecated: use viewer.knownLikers
            /// instead."
            ///
            /// - Note: Current maximum length is 3 items.
            public let likers: [AppBskyLexicon.Actor.ProfileViewBasicDefinition]?

            public init(
                providerID: String? = nil,
                uri: String,
                title: String,
                description: String,
                createdAt: Date? = nil,
                updatedAt: Date? = nil,
                labels: [ComAtprotoLexicon.Label.LabelDefinition]? = nil,
                associatedRefs: [ComAtprotoLexicon.Repository.StrongReference]? = nil,
                associatedProfiles: [AppBskyLexicon.Actor.ProfileViewBasicDefinition]? = nil,
                imageURL: URL? = nil,
                publisher: ViewArticlePublication? = nil,
                readingTime: Int? = nil,
                viewer: ViewArticleViewerState? = nil,
                likeCount: Int? = nil,
                likers: [AppBskyLexicon.Actor.ProfileViewBasicDefinition]? = nil
            ) {
                self.providerID = providerID
                self.uri = uri
                self.title = title
                self.description = description
                self.createdAt = createdAt
                self.updatedAt = updatedAt
                self.labels = labels
                self.associatedRefs = associatedRefs
                self.associatedProfiles = associatedProfiles
                self.imageURL = imageURL
                self.publisher = publisher
                self.readingTime = readingTime
                self.viewer = viewer
                self.likeCount = likeCount
                self.likers = likers
            }

            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.providerID = try container.decodeIfPresent(String.self, forKey: CodingKeys.providerID)
                self.uri = try container.decode(String.self, forKey: CodingKeys.uri)
                self.title = try container.decode(String.self, forKey: CodingKeys.title)
                self.description = try container.decode(String.self, forKey: CodingKeys.description)
                self.createdAt = try container.decodeDateIfPresent(forKey: CodingKeys.createdAt)
                self.updatedAt = try container.decodeDateIfPresent(forKey: CodingKeys.updatedAt)
                self.labels = try container.decodeIfPresent([ComAtprotoLexicon.Label.LabelDefinition].self, forKey: CodingKeys.labels)
                self.associatedRefs = try container.decodeIfPresent([ComAtprotoLexicon.Repository.StrongReference].self, forKey: CodingKeys.associatedRefs)
                self.associatedProfiles = try container.decodeIfPresent([AppBskyLexicon.Actor.ProfileViewBasicDefinition].self, forKey: CodingKeys.associatedProfiles)
                self.imageURL = try container.decodeIfPresent(URL.self, forKey: CodingKeys.imageURL)
                self.publisher = try container.decodeIfPresent(ViewArticlePublication.self, forKey: CodingKeys.publisher)
                self.readingTime = try container.decodeIfPresent(Int.self, forKey: CodingKeys.readingTime)
                self.viewer = try container.decodeIfPresent(ViewArticleViewerState.self, forKey: CodingKeys.viewer)
                self.likeCount = try container.decodeIfPresent(Int.self, forKey: CodingKeys.likeCount)
                self.likers = try container.decodeIfPresent([AppBskyLexicon.Actor.ProfileViewBasicDefinition].self, forKey: CodingKeys.likers)
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(self.type, forKey: CodingKeys.type)
                try container.encodeIfPresent(self.providerID, forKey: CodingKeys.providerID)
                try container.encode(self.uri, forKey: CodingKeys.uri)
                try container.encode(self.title, forKey: CodingKeys.title)
                try container.encode(self.description, forKey: CodingKeys.description)
                try container.encodeDateIfPresent(self.createdAt, forKey: CodingKeys.createdAt)
                try container.encodeDateIfPresent(self.updatedAt, forKey: CodingKeys.updatedAt)
                try container.encodeIfPresent(self.labels, forKey: CodingKeys.labels)
                try container.encodeIfPresent(self.associatedRefs, forKey: CodingKeys.associatedRefs)
                try container.encodeIfPresent(self.associatedProfiles, forKey: CodingKeys.associatedProfiles)
                try container.encodeIfPresent(self.imageURL, forKey: CodingKeys.imageURL)
                try container.encodeIfPresent(self.publisher, forKey: CodingKeys.publisher)
                try container.encodeIfPresent(self.readingTime, forKey: CodingKeys.readingTime)
                try container.encodeIfPresent(self.viewer, forKey: CodingKeys.viewer)
                try container.encodeIfPresent(self.likeCount, forKey: CodingKeys.likeCount)
                try container.encodeIfPresent(self.likers, forKey: CodingKeys.likers)
            }

            enum CodingKeys: String, CodingKey {
                case type = "$type"
                case providerID = "providerId"
                case uri
                case title
                case description
                case createdAt
                case updatedAt
                case labels
                case associatedRefs
                case associatedProfiles
                case imageURL = "image"
                case publisher
                case readingTime
                case viewer
                case likeCount
                case likers
            }
        }

        /// A data model for the viewer state of an article.
        ///
        /// - Note: According to the AT Protocol specifications: "Metadata about the requesting
        /// account's relationship with the subject article. Only has meaningful content for
        /// authed requests."
        ///
        /// - SeeAlso: This is based on the [`app.bsky.embed.external`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/embed/external.json
        public struct ViewArticleViewerState: Sendable, Codable, Equatable, Hashable {

            /// The identifier of the lexicon.
            ///
            /// - Warning: The value must not change.
            public let type: String = "app.bsky.embed.external#viewArticleViewerState"

            /// The URI of the requesting user account's recommendation record for the article. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "The requesting account's
            /// site.standard.graph.recommend record for this article, if recommended."
            public let likeURI: String?

            /// An array of user accounts the requesting user account follows that recommended the
            /// article. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "Up to 3 accounts the requesting
            /// account follows that recommended the subject, newest first. Never includes the
            /// requesting account."
            public let knownLikers: [AppBskyLexicon.Actor.ProfileViewBasicDefinition]?

            /// The total number of user accounts the requesting user account follows that recommended
            /// the article. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "Total number of accounts the
            /// requesting account follows that recommended the subject, including those in
            /// knownLikers."
            public let knownLikerCount: Int?

            public init(likeURI: String?, knownLikers: [AppBskyLexicon.Actor.ProfileViewBasicDefinition]?, knownLikerCount: Int?) {
                self.likeURI = likeURI
                self.knownLikers = knownLikers
                self.knownLikerCount = knownLikerCount
            }

            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.likeURI = try container.decodeIfPresent(String.self, forKey: CodingKeys.likeURI)
                self.knownLikers = try container.decodeIfPresent([AppBskyLexicon.Actor.ProfileViewBasicDefinition].self, forKey: CodingKeys.knownLikers)
                self.knownLikerCount = try container.decodeIfPresent(Int.self, forKey: CodingKeys.knownLikerCount)
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(self.type, forKey: CodingKeys.type)
                try container.encodeIfPresent(self.likeURI, forKey: CodingKeys.likeURI)
                try container.encodeIfPresent(self.knownLikers, forKey: CodingKeys.knownLikers)
                try container.encodeIfPresent(self.knownLikerCount, forKey: CodingKeys.knownLikerCount)
            }

            enum CodingKeys: String, CodingKey {
                case type = "$type"
                case likeURI = "like"
                case knownLikers
                case knownLikerCount
            }
        }

        /// A data model for the view of an article publication.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.embed.external`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/embed/external.json
        public struct ViewArticlePublication: Sendable, Codable, Equatable, Hashable {

            /// The identifier of the lexicon.
            ///
            /// - Warning: The value must not change.
            public let type: String = "app.bsky.embed.external#viewArticlePublication"

            /// The provider domain of the publication. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "Best-effort provider domain for
            /// cosmetic attribution, such as pckt.blog. Not verified provenance."
            ///
            /// - Note: Current maximum length is 128 characters.
            public let providerID: String?

            /// The URI of the publication.
            public let uri: String

            /// The title of the publication.
            public let title: String

            /// The description of the publication.
            public let description: String

            /// The date and time the publication was created. Optional.
            public let createdAt: Date?

            /// The date and time the publication was last updated. Optional.
            public let updatedAt: Date?

            /// An array of labels attached to the publication. Optional.
            public let labels: [ComAtprotoLexicon.Label.LabelDefinition]?

            /// An array of strong references to the Atmosphere records that backed this view. Optional.
            public let associatedRefs: [ComAtprotoLexicon.Repository.StrongReference]?

            /// An array of profiles of the owners of the Atmosphere records that backed this view. Optional.
            public let associatedProfiles: [AppBskyLexicon.Actor.ProfileViewBasicDefinition]?

            /// The logo URL of the publication. Optional.
            public let logoURL: URL?

            /// The image URL of the publication. Optional.
            public let imageURL: URL?

            /// The theme colors of the publication. Optional.
            public let theme: ViewArticlePublicationTheme?

            /// The viewer state of the publication. Optional.
            public let viewer: ViewArticlePublicationViewerState?

            /// The number of subscriptions the publication has. Optional.
            public let subscriptionCount: Int?

            /// An array of profile previews of user accounts that subscribed to the publication. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "Available profile previews.
            /// Selected deterministically by DID; not a ranking."
            ///
            /// - Note: Current maximum length is 3 items.
            public let subscribers: [AppBskyLexicon.Actor.ProfileViewBasicDefinition]?

            public init(
                providerID: String? = nil,
                uri: String,
                title: String,
                description: String,
                createdAt: Date? = nil,
                updatedAt: Date? = nil,
                labels: [ComAtprotoLexicon.Label.LabelDefinition]? = nil,
                associatedRefs: [ComAtprotoLexicon.Repository.StrongReference]? = nil,
                associatedProfiles: [AppBskyLexicon.Actor.ProfileViewBasicDefinition]? = nil,
                logoURL: URL? = nil,
                imageURL: URL? = nil,
                theme: ViewArticlePublicationTheme? = nil,
                viewer: ViewArticlePublicationViewerState? = nil,
                subscriptionCount: Int? = nil,
                subscribers: [AppBskyLexicon.Actor.ProfileViewBasicDefinition]? = nil
            ) {
                self.providerID = providerID
                self.uri = uri
                self.title = title
                self.description = description
                self.createdAt = createdAt
                self.updatedAt = updatedAt
                self.labels = labels
                self.associatedRefs = associatedRefs
                self.associatedProfiles = associatedProfiles
                self.logoURL = logoURL
                self.imageURL = imageURL
                self.theme = theme
                self.viewer = viewer
                self.subscriptionCount = subscriptionCount
                self.subscribers = subscribers
            }

            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.providerID = try container.decodeIfPresent(String.self, forKey: CodingKeys.providerID)
                self.uri = try container.decode(String.self, forKey: CodingKeys.uri)
                self.title = try container.decode(String.self, forKey: CodingKeys.title)
                self.description = try container.decode(String.self, forKey: CodingKeys.description)
                self.createdAt = try container.decodeDateIfPresent(forKey: CodingKeys.createdAt)
                self.updatedAt = try container.decodeDateIfPresent(forKey: CodingKeys.updatedAt)
                self.labels = try container.decodeIfPresent([ComAtprotoLexicon.Label.LabelDefinition].self, forKey: CodingKeys.labels)
                self.associatedRefs = try container.decodeIfPresent([ComAtprotoLexicon.Repository.StrongReference].self, forKey: CodingKeys.associatedRefs)
                self.associatedProfiles = try container.decodeIfPresent([AppBskyLexicon.Actor.ProfileViewBasicDefinition].self, forKey: CodingKeys.associatedProfiles)
                self.logoURL = try container.decodeIfPresent(URL.self, forKey: CodingKeys.logoURL)
                self.imageURL = try container.decodeIfPresent(URL.self, forKey: CodingKeys.imageURL)
                self.theme = try container.decodeIfPresent(ViewArticlePublicationTheme.self, forKey: CodingKeys.theme)
                self.viewer = try container.decodeIfPresent(ViewArticlePublicationViewerState.self, forKey: CodingKeys.viewer)
                self.subscriptionCount = try container.decodeIfPresent(Int.self, forKey: CodingKeys.subscriptionCount)
                self.subscribers = try container.decodeIfPresent([AppBskyLexicon.Actor.ProfileViewBasicDefinition].self, forKey: CodingKeys.subscribers)
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(self.type, forKey: CodingKeys.type)
                try container.encodeIfPresent(self.providerID, forKey: CodingKeys.providerID)
                try container.encode(self.uri, forKey: CodingKeys.uri)
                try container.encode(self.title, forKey: CodingKeys.title)
                try container.encode(self.description, forKey: CodingKeys.description)
                try container.encodeDateIfPresent(self.createdAt, forKey: CodingKeys.createdAt)
                try container.encodeDateIfPresent(self.updatedAt, forKey: CodingKeys.updatedAt)
                try container.encodeIfPresent(self.labels, forKey: CodingKeys.labels)
                try container.encodeIfPresent(self.associatedRefs, forKey: CodingKeys.associatedRefs)
                try container.encodeIfPresent(self.associatedProfiles, forKey: CodingKeys.associatedProfiles)
                try container.encodeIfPresent(self.logoURL, forKey: CodingKeys.logoURL)
                try container.encodeIfPresent(self.imageURL, forKey: CodingKeys.imageURL)
                try container.encodeIfPresent(self.theme, forKey: CodingKeys.theme)
                try container.encodeIfPresent(self.viewer, forKey: CodingKeys.viewer)
                try container.encodeIfPresent(self.subscriptionCount, forKey: CodingKeys.subscriptionCount)
                try container.encodeIfPresent(self.subscribers, forKey: CodingKeys.subscribers)
            }

            enum CodingKeys: String, CodingKey {
                case type = "$type"
                case providerID = "providerId"
                case uri
                case title
                case description
                case createdAt
                case updatedAt
                case labels
                case associatedRefs
                case associatedProfiles
                case logoURL = "logo"
                case imageURL = "image"
                case theme
                case viewer
                case subscriptionCount
                case subscribers
            }
        }

        /// A data model for the viewer state of an article publication.
        ///
        /// - Note: According to the AT Protocol specifications: "Metadata about the requesting
        /// account's relationship with the subject publication. Only has meaningful content for
        /// authed requests."
        ///
        /// - SeeAlso: This is based on the [`app.bsky.embed.external`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/embed/external.json
        public struct ViewArticlePublicationViewerState: Sendable, Codable, Equatable, Hashable {

            /// The identifier of the lexicon.
            ///
            /// - Warning: The value must not change.
            public let type: String = "app.bsky.embed.external#viewArticlePublicationViewerState"

            /// The URI of the requesting user account's subscription record for the publication. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "The requesting account's
            /// site.standard.graph.subscription record for this publication, if subscribed."
            public let subscriptionURI: String?

            /// An array of user accounts the requesting user account follows that subscribed to the
            /// publication. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "Up to 3 accounts the requesting
            /// account follows that subscribed to the subject, newest first. Never includes the
            /// requesting account."
            public let knownSubscribers: [AppBskyLexicon.Actor.ProfileViewBasicDefinition]?

            /// The total number of user accounts the requesting user account follows that subscribed
            /// to the publication. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "Total number of accounts the
            /// requesting account follows that subscribed to the subject, including those in
            /// knownSubscribers."
            public let knownSubscriberCount: Int?

            public init(subscriptionURI: String?, knownSubscribers: [AppBskyLexicon.Actor.ProfileViewBasicDefinition]?, knownSubscriberCount: Int?) {
                self.subscriptionURI = subscriptionURI
                self.knownSubscribers = knownSubscribers
                self.knownSubscriberCount = knownSubscriberCount
            }

            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.subscriptionURI = try container.decodeIfPresent(String.self, forKey: CodingKeys.subscriptionURI)
                self.knownSubscribers = try container.decodeIfPresent([AppBskyLexicon.Actor.ProfileViewBasicDefinition].self, forKey: CodingKeys.knownSubscribers)
                self.knownSubscriberCount = try container.decodeIfPresent(Int.self, forKey: CodingKeys.knownSubscriberCount)
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(self.type, forKey: CodingKeys.type)
                try container.encodeIfPresent(self.subscriptionURI, forKey: CodingKeys.subscriptionURI)
                try container.encodeIfPresent(self.knownSubscribers, forKey: CodingKeys.knownSubscribers)
                try container.encodeIfPresent(self.knownSubscriberCount, forKey: CodingKeys.knownSubscriberCount)
            }

            enum CodingKeys: String, CodingKey {
                case type = "$type"
                case subscriptionURI = "subscription"
                case knownSubscribers
                case knownSubscriberCount
            }
        }

        /// A data model for the theme colors of an article publication.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.embed.external`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/embed/external.json
        public struct ViewArticlePublicationTheme: Sendable, Codable, Equatable, Hashable {

            /// The identifier of the lexicon.
            ///
            /// - Warning: The value must not change.
            public let type: String = "app.bsky.embed.external#viewArticlePublicationTheme"

            /// The background color of the publication. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "Hex color string, if available.
            /// Example: '#ffffff'."
            public let background: String?

            /// The foreground color of the publication. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "Hex color string, if available.
            /// Example: '#ffffff'."
            public let foreground: String?

            /// The accent color of the publication. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "Hex color string, if available.
            /// Example: '#ffffff'."
            public let accent: String?

            /// The foreground color used on top of the accent color. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "Hex color string, if available.
            /// Example: '#ffffff'."
            public let accentForeground: String?

            public init(background: String?, foreground: String?, accent: String?, accentForeground: String?) {
                self.background = background
                self.foreground = foreground
                self.accent = accent
                self.accentForeground = accentForeground
            }

            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.background = try container.decodeIfPresent(String.self, forKey: CodingKeys.background)
                self.foreground = try container.decodeIfPresent(String.self, forKey: CodingKeys.foreground)
                self.accent = try container.decodeIfPresent(String.self, forKey: CodingKeys.accent)
                self.accentForeground = try container.decodeIfPresent(String.self, forKey: CodingKeys.accentForeground)
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(self.type, forKey: CodingKeys.type)
                try container.encodeIfPresent(self.background, forKey: CodingKeys.background)
                try container.encodeIfPresent(self.foreground, forKey: CodingKeys.foreground)
                try container.encodeIfPresent(self.accent, forKey: CodingKeys.accent)
                try container.encodeIfPresent(self.accentForeground, forKey: CodingKeys.accentForeground)
            }

            enum CodingKeys: String, CodingKey {
                case type = "$type"
                case background
                case foreground
                case accent
                case accentForeground
            }
        }

        /// A data model for the view of a gallery.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.embed.external`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/embed/external.json
        public struct ViewGallery: Sendable, Codable, Equatable, Hashable {

            /// The identifier of the lexicon.
            ///
            /// - Warning: The value must not change.
            public let type: String = "app.bsky.embed.external#viewGallery"

            /// The provider domain of the gallery. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "Best-effort provider domain for
            /// cosmetic attribution, such as grain.social. Not verified provenance."
            ///
            /// - Note: Current maximum length is 128 characters.
            public let providerID: String?

            /// The URI of the gallery.
            public let uri: String

            /// The title of the gallery.
            public let title: String

            /// The description of the gallery.
            public let description: String

            /// The date and time the gallery was created. Optional.
            public let createdAt: Date?

            /// The date and time the gallery was last updated. Optional.
            public let updatedAt: Date?

            /// An array of labels attached to the gallery. Optional.
            public let labels: [ComAtprotoLexicon.Label.LabelDefinition]?

            /// An array of strong references to the Atmosphere records that backed this view. Optional.
            public let associatedRefs: [ComAtprotoLexicon.Repository.StrongReference]?

            /// An array of profiles of the owners of the Atmosphere records that backed this view. Optional.
            public let associatedProfiles: [AppBskyLexicon.Actor.ProfileViewBasicDefinition]?

            /// An array of media items in the gallery.
            ///
            /// - Note: According to the AT Protocol specifications: "The media items in the gallery.
            /// Each item may be of a different type, but all types must be supported by the client."
            public let items: [ItemUnion]

            /// The total number of photos in the gallery. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "Total number of gallery item
            /// backlinks, independent of the items included in this view."
            public let photoCount: Int?

            /// The viewer state of the gallery. Optional.
            public let viewer: ViewGalleryViewerState?

            /// The number of likes the gallery has. Optional.
            public let likeCount: Int?

            /// An array of profile previews of user accounts that liked the gallery. Optional.
            ///
            /// - Important: This property is deprecated. Use ``ViewGalleryViewerState/knownLikers``
            /// instead.
            ///
            /// - Note: According to the AT Protocol specifications: "Available profile previews.
            /// Selected deterministically by DID; not a ranking. Deprecated: use viewer.knownLikers
            /// instead."
            ///
            /// - Note: Current maximum length is 3 items.
            public let likers: [AppBskyLexicon.Actor.ProfileViewBasicDefinition]?

            public init(
                providerID: String? = nil,
                uri: String,
                title: String,
                description: String,
                createdAt: Date? = nil,
                updatedAt: Date? = nil,
                labels: [ComAtprotoLexicon.Label.LabelDefinition]? = nil,
                associatedRefs: [ComAtprotoLexicon.Repository.StrongReference]? = nil,
                associatedProfiles: [AppBskyLexicon.Actor.ProfileViewBasicDefinition]? = nil,
                items: [ItemUnion],
                photoCount: Int? = nil,
                viewer: ViewGalleryViewerState? = nil,
                likeCount: Int? = nil,
                likers: [AppBskyLexicon.Actor.ProfileViewBasicDefinition]? = nil
            ) {
                self.providerID = providerID
                self.uri = uri
                self.title = title
                self.description = description
                self.createdAt = createdAt
                self.updatedAt = updatedAt
                self.labels = labels
                self.associatedRefs = associatedRefs
                self.associatedProfiles = associatedProfiles
                self.items = items
                self.photoCount = photoCount
                self.viewer = viewer
                self.likeCount = likeCount
                self.likers = likers
            }

            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.providerID = try container.decodeIfPresent(String.self, forKey: CodingKeys.providerID)
                self.uri = try container.decode(String.self, forKey: CodingKeys.uri)
                self.title = try container.decode(String.self, forKey: CodingKeys.title)
                self.description = try container.decode(String.self, forKey: CodingKeys.description)
                self.createdAt = try container.decodeDateIfPresent(forKey: CodingKeys.createdAt)
                self.updatedAt = try container.decodeDateIfPresent(forKey: CodingKeys.updatedAt)
                self.labels = try container.decodeIfPresent([ComAtprotoLexicon.Label.LabelDefinition].self, forKey: CodingKeys.labels)
                self.associatedRefs = try container.decodeIfPresent([ComAtprotoLexicon.Repository.StrongReference].self, forKey: CodingKeys.associatedRefs)
                self.associatedProfiles = try container.decodeIfPresent([AppBskyLexicon.Actor.ProfileViewBasicDefinition].self, forKey: CodingKeys.associatedProfiles)
                self.items = try container.decode([ItemUnion].self, forKey: CodingKeys.items)
                self.photoCount = try container.decodeIfPresent(Int.self, forKey: CodingKeys.photoCount)
                self.viewer = try container.decodeIfPresent(ViewGalleryViewerState.self, forKey: CodingKeys.viewer)
                self.likeCount = try container.decodeIfPresent(Int.self, forKey: CodingKeys.likeCount)
                self.likers = try container.decodeIfPresent([AppBskyLexicon.Actor.ProfileViewBasicDefinition].self, forKey: CodingKeys.likers)
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(self.type, forKey: CodingKeys.type)
                try container.encodeIfPresent(self.providerID, forKey: CodingKeys.providerID)
                try container.encode(self.uri, forKey: CodingKeys.uri)
                try container.encode(self.title, forKey: CodingKeys.title)
                try container.encode(self.description, forKey: CodingKeys.description)
                try container.encodeDateIfPresent(self.createdAt, forKey: CodingKeys.createdAt)
                try container.encodeDateIfPresent(self.updatedAt, forKey: CodingKeys.updatedAt)
                try container.encodeIfPresent(self.labels, forKey: CodingKeys.labels)
                try container.encodeIfPresent(self.associatedRefs, forKey: CodingKeys.associatedRefs)
                try container.encodeIfPresent(self.associatedProfiles, forKey: CodingKeys.associatedProfiles)
                try container.encode(self.items, forKey: CodingKeys.items)
                try container.encodeIfPresent(self.photoCount, forKey: CodingKeys.photoCount)
                try container.encodeIfPresent(self.viewer, forKey: CodingKeys.viewer)
                try container.encodeIfPresent(self.likeCount, forKey: CodingKeys.likeCount)
                try container.encodeIfPresent(self.likers, forKey: CodingKeys.likers)
            }

            enum CodingKeys: String, CodingKey {
                case type = "$type"
                case providerID = "providerId"
                case uri
                case title
                case description
                case createdAt
                case updatedAt
                case labels
                case associatedRefs
                case associatedProfiles
                case items
                case photoCount
                case viewer
                case likeCount
                case likers
            }

            // Unions
            /// A media item in the gallery.
            public enum ItemUnion: ATUnionProtocol, Equatable, Hashable {

                /// The view of a gallery image.
                case viewGalleryImage(AppBskyLexicon.Embed.ExternalDefinition.ViewGalleryImage)

                /// An unknown case.
                case unknown(String, [String: CodableValue])

                public init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeys.self)
                    let type = try container.decodeIfPresent(String.self, forKey: .type)

                    switch type {
                        case "app.bsky.embed.external#viewGalleryImage":
                            self = .viewGalleryImage(try AppBskyLexicon.Embed.ExternalDefinition.ViewGalleryImage(from: decoder))
                        default:
                            let singleValueDecodingContainer = try decoder.singleValueContainer()
                            let dictionary = try Self.decodeDictionary(from: singleValueDecodingContainer, decoder: decoder)

                            self = .unknown(type ?? "unknown", dictionary)
                    }
                }

                public func encode(to encoder: any Encoder) throws {
                    var container = encoder.singleValueContainer()

                    switch self {
                        case .viewGalleryImage(let value):
                            try container.encode(value)
                        case .unknown(_, let dictionary):
                            try container.encode(dictionary)
                    }
                }

                enum CodingKeys: String, CodingKey {
                    case type = "$type"
                }
            }
        }

        /// A data model for the viewer state of a gallery.
        ///
        /// - Note: According to the AT Protocol specifications: "Metadata about the requesting
        /// account's relationship with the subject gallery. Only has meaningful content for
        /// authed requests."
        ///
        /// - SeeAlso: This is based on the [`app.bsky.embed.external`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/embed/external.json
        public struct ViewGalleryViewerState: Sendable, Codable, Equatable, Hashable {

            /// The identifier of the lexicon.
            ///
            /// - Warning: The value must not change.
            public let type: String = "app.bsky.embed.external#viewGalleryViewerState"

            /// The URI of the requesting user account's favorite record for the gallery. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "The requesting account's
            /// social.grain.favorite record for this gallery, if favorited."
            public let likeURI: String?

            /// An array of user accounts the requesting user account follows that favorited the
            /// gallery. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "Up to 3 accounts the requesting
            /// account follows that favorited the subject, newest first. Never includes the
            /// requesting account."
            public let knownLikers: [AppBskyLexicon.Actor.ProfileViewBasicDefinition]?

            /// The total number of user accounts the requesting user account follows that favorited
            /// the gallery. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "Total number of accounts the
            /// requesting account follows that favorited the subject, including those in knownLikers."
            public let knownLikerCount: Int?

            public init(likeURI: String?, knownLikers: [AppBskyLexicon.Actor.ProfileViewBasicDefinition]?, knownLikerCount: Int?) {
                self.likeURI = likeURI
                self.knownLikers = knownLikers
                self.knownLikerCount = knownLikerCount
            }

            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.likeURI = try container.decodeIfPresent(String.self, forKey: CodingKeys.likeURI)
                self.knownLikers = try container.decodeIfPresent([AppBskyLexicon.Actor.ProfileViewBasicDefinition].self, forKey: CodingKeys.knownLikers)
                self.knownLikerCount = try container.decodeIfPresent(Int.self, forKey: CodingKeys.knownLikerCount)
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(self.type, forKey: CodingKeys.type)
                try container.encodeIfPresent(self.likeURI, forKey: CodingKeys.likeURI)
                try container.encodeIfPresent(self.knownLikers, forKey: CodingKeys.knownLikers)
                try container.encodeIfPresent(self.knownLikerCount, forKey: CodingKeys.knownLikerCount)
            }

            enum CodingKeys: String, CodingKey {
                case type = "$type"
                case likeURI = "like"
                case knownLikers
                case knownLikerCount
            }
        }

        /// A data model for the view of an image in a gallery.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.embed.external`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/embed/external.json
        public struct ViewGalleryImage: Sendable, Codable, Equatable, Hashable {

            /// The identifier of the lexicon.
            ///
            /// - Warning: The value must not change.
            public let type: String = "app.bsky.embed.external#viewGalleryImage"

            /// The URL of the image's thumbnail.
            ///
            /// - Note: According to the AT Protocol specifications: "Fully-qualified URL where a
            /// thumbnail of the image can be fetched. For example, CDN location provided by the
            /// App View."
            public let thumbnailImageURL: URL

            /// The URL of the fully-sized image.
            ///
            /// - Note: According to the AT Protocol specifications: "Fully-qualified URL where a
            /// large version of the image can be fetched. May or may not be the exact original blob.
            /// For example, CDN location provided by the App View."
            public let fullSizeImageURL: URL

            /// The alternative text for the image. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "Alt text description of the
            /// image, for accessibility."
            public let altText: String?

            /// The aspect ratio of the image. Optional.
            public let aspectRatio: AppBskyLexicon.Embed.AspectRatioDefinition?

            public init(thumbnailImageURL: URL, fullSizeImageURL: URL, altText: String?, aspectRatio: AppBskyLexicon.Embed.AspectRatioDefinition?) {
                self.thumbnailImageURL = thumbnailImageURL
                self.fullSizeImageURL = fullSizeImageURL
                self.altText = altText
                self.aspectRatio = aspectRatio
            }

            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.thumbnailImageURL = try container.decode(URL.self, forKey: CodingKeys.thumbnailImageURL)
                self.fullSizeImageURL = try container.decode(URL.self, forKey: CodingKeys.fullSizeImageURL)
                self.altText = try container.decodeIfPresent(String.self, forKey: CodingKeys.altText)
                self.aspectRatio = try container.decodeIfPresent(AppBskyLexicon.Embed.AspectRatioDefinition.self, forKey: CodingKeys.aspectRatio)
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(self.type, forKey: CodingKeys.type)
                try container.encode(self.thumbnailImageURL, forKey: CodingKeys.thumbnailImageURL)
                try container.encode(self.fullSizeImageURL, forKey: CodingKeys.fullSizeImageURL)
                try container.encodeIfPresent(self.altText, forKey: CodingKeys.altText)
                try container.encodeIfPresent(self.aspectRatio, forKey: CodingKeys.aspectRatio)
            }

            enum CodingKeys: String, CodingKey {
                case type = "$type"
                case thumbnailImageURL = "thumbnail"
                case fullSizeImageURL = "fullsize"
                case altText = "alt"
                case aspectRatio
            }
        }

        /// A data model for the view of a livestream.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.embed.external`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/embed/external.json
        public struct ViewLivestream: Sendable, Codable, Equatable, Hashable {

            /// The identifier of the lexicon.
            ///
            /// - Warning: The value must not change.
            public let type: String = "app.bsky.embed.external#viewLivestream"

            /// The provider domain of the livestream. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "Best-effort provider domain for
            /// cosmetic attribution, such as stream.place. Not verified provenance."
            ///
            /// - Note: Current maximum length is 128 characters.
            public let providerID: String?

            /// The URI of the livestream.
            public let uri: String

            /// The title of the livestream.
            public let title: String

            /// The description of the livestream.
            public let description: String

            /// The date and time the livestream was created. Optional.
            public let createdAt: Date?

            /// The date and time the livestream was last updated. Optional.
            public let updatedAt: Date?

            /// An array of labels attached to the livestream. Optional.
            public let labels: [ComAtprotoLexicon.Label.LabelDefinition]?

            /// An array of strong references to the Atmosphere records that backed this view. Optional.
            public let associatedRefs: [ComAtprotoLexicon.Repository.StrongReference]?

            /// An array of profiles of the owners of the Atmosphere records that backed this view. Optional.
            public let associatedProfiles: [AppBskyLexicon.Actor.ProfileViewBasicDefinition]?

            /// The image URL of the livestream. Optional.
            public let imageURL: URL?

            /// Indicates whether the livestream is currently active.
            ///
            /// - Note: According to the AT Protocol specifications: "True if the livestream is
            /// currently active at the time this view is served, false if it has ended."
            public let isActive: Bool

            /// The date and time the livestream started. Optional.
            public let startedAt: Date?

            /// The date and time the livestream ended. Optional.
            public let endedAt: Date?

            /// The date and time the livestream last reported that it was live. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "When the livestream last
            /// reported that it was live. A livestream without endedAt is considered active until
            /// two minutes after its last heartbeat; clients can apply the same window to tell
            /// whether a cached view is still live."
            public let lastSeenAt: Date?

            public init(
                providerID: String? = nil,
                uri: String,
                title: String,
                description: String,
                createdAt: Date? = nil,
                updatedAt: Date? = nil,
                labels: [ComAtprotoLexicon.Label.LabelDefinition]? = nil,
                associatedRefs: [ComAtprotoLexicon.Repository.StrongReference]? = nil,
                associatedProfiles: [AppBskyLexicon.Actor.ProfileViewBasicDefinition]? = nil,
                imageURL: URL? = nil,
                isActive: Bool,
                startedAt: Date? = nil,
                endedAt: Date? = nil,
                lastSeenAt: Date? = nil
            ) {
                self.providerID = providerID
                self.uri = uri
                self.title = title
                self.description = description
                self.createdAt = createdAt
                self.updatedAt = updatedAt
                self.labels = labels
                self.associatedRefs = associatedRefs
                self.associatedProfiles = associatedProfiles
                self.imageURL = imageURL
                self.isActive = isActive
                self.startedAt = startedAt
                self.endedAt = endedAt
                self.lastSeenAt = lastSeenAt
            }

            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.providerID = try container.decodeIfPresent(String.self, forKey: CodingKeys.providerID)
                self.uri = try container.decode(String.self, forKey: CodingKeys.uri)
                self.title = try container.decode(String.self, forKey: CodingKeys.title)
                self.description = try container.decode(String.self, forKey: CodingKeys.description)
                self.createdAt = try container.decodeDateIfPresent(forKey: CodingKeys.createdAt)
                self.updatedAt = try container.decodeDateIfPresent(forKey: CodingKeys.updatedAt)
                self.labels = try container.decodeIfPresent([ComAtprotoLexicon.Label.LabelDefinition].self, forKey: CodingKeys.labels)
                self.associatedRefs = try container.decodeIfPresent([ComAtprotoLexicon.Repository.StrongReference].self, forKey: CodingKeys.associatedRefs)
                self.associatedProfiles = try container.decodeIfPresent([AppBskyLexicon.Actor.ProfileViewBasicDefinition].self, forKey: CodingKeys.associatedProfiles)
                self.imageURL = try container.decodeIfPresent(URL.self, forKey: CodingKeys.imageURL)
                self.isActive = try container.decode(Bool.self, forKey: CodingKeys.isActive)
                self.startedAt = try container.decodeDateIfPresent(forKey: CodingKeys.startedAt)
                self.endedAt = try container.decodeDateIfPresent(forKey: CodingKeys.endedAt)
                self.lastSeenAt = try container.decodeDateIfPresent(forKey: CodingKeys.lastSeenAt)
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(self.type, forKey: CodingKeys.type)
                try container.encodeIfPresent(self.providerID, forKey: CodingKeys.providerID)
                try container.encode(self.uri, forKey: CodingKeys.uri)
                try container.encode(self.title, forKey: CodingKeys.title)
                try container.encode(self.description, forKey: CodingKeys.description)
                try container.encodeDateIfPresent(self.createdAt, forKey: CodingKeys.createdAt)
                try container.encodeDateIfPresent(self.updatedAt, forKey: CodingKeys.updatedAt)
                try container.encodeIfPresent(self.labels, forKey: CodingKeys.labels)
                try container.encodeIfPresent(self.associatedRefs, forKey: CodingKeys.associatedRefs)
                try container.encodeIfPresent(self.associatedProfiles, forKey: CodingKeys.associatedProfiles)
                try container.encodeIfPresent(self.imageURL, forKey: CodingKeys.imageURL)
                try container.encode(self.isActive, forKey: CodingKeys.isActive)
                try container.encodeDateIfPresent(self.startedAt, forKey: CodingKeys.startedAt)
                try container.encodeDateIfPresent(self.endedAt, forKey: CodingKeys.endedAt)
                try container.encodeDateIfPresent(self.lastSeenAt, forKey: CodingKeys.lastSeenAt)
            }

            enum CodingKeys: String, CodingKey {
                case type = "$type"
                case providerID = "providerId"
                case uri
                case title
                case description
                case createdAt
                case updatedAt
                case labels
                case associatedRefs
                case associatedProfiles
                case imageURL = "image"
                case isActive = "active"
                case startedAt
                case endedAt
                case lastSeenAt
            }
        }
    }
}
