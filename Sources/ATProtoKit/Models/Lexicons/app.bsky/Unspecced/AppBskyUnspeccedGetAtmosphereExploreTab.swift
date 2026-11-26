//
//  AppBskyUnspeccedGetAtmosphereExploreTab.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Unspecced {

    /// The main data model definition for getting Atmosphere Explore content.
    ///
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    public struct GetAtmosphereExploreTab: Sendable, Codable {

        /// A list of articles.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.unspecced.getAtmosphereExploreTab`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getAtmosphereExploreTab.json
        public struct ArticleList: Sendable, Codable {

            /// An array of article items.
            public let items: [AppBskyLexicon.Unspecced.GetAtmosphereExploreTab.ArticleItem]

            /// A Snowflake ID for recommendation events. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "Snowflake for this list's
            /// recommendation, use when submitting recommendation events. Omitted when the list is
            /// not algorithmically recommended."
            public let recommendationIDString: String?

            enum CodingKeys: String, CodingKey {
                case items
                case recommendationIDString = "recIdStr"
            }
        }

        /// A list of publications.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.unspecced.getAtmosphereExploreTab`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getAtmosphereExploreTab.json
        public struct PublicationList: Sendable, Codable {

            /// An array of publication items.
            public let items: [AppBskyLexicon.Unspecced.GetAtmosphereExploreTab.PublicationItem]

            /// A Snowflake ID for recommendation events. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "Snowflake for this list's
            /// recommendation, use when submitting recommendation events. Omitted when the list is
            /// not algorithmically recommended."
            public let recommendationIDString: String?

            enum CodingKeys: String, CodingKey {
                case items
                case recommendationIDString = "recIdStr"
            }
        }

        /// A list of galleries.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.unspecced.getAtmosphereExploreTab`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getAtmosphereExploreTab.json
        public struct GalleryList: Sendable, Codable {

            /// An array of gallery items.
            public let items: [AppBskyLexicon.Unspecced.GetAtmosphereExploreTab.GalleryItem]

            /// A Snowflake ID for recommendation events. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "Snowflake for this list's
            /// recommendation, use when submitting recommendation events. Omitted when the list is
            /// not algorithmically recommended."
            public let recommendationIDString: String?

            enum CodingKeys: String, CodingKey {
                case items
                case recommendationIDString = "recIdStr"
            }
        }

        /// A list of livestreams.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.unspecced.getAtmosphereExploreTab`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getAtmosphereExploreTab.json
        public struct LivestreamList: Sendable, Codable {

            /// An array of livestream items.
            public let items: [AppBskyLexicon.Unspecced.GetAtmosphereExploreTab.LivestreamItem]

            /// A Snowflake ID for recommendation events. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "Snowflake for this list's
            /// recommendation, use when submitting recommendation events. Omitted when the list is
            /// not algorithmically recommended."
            public let recommendationIDString: String?

            enum CodingKeys: String, CodingKey {
                case items
                case recommendationIDString = "recIdStr"
            }
        }

        /// An article item.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.unspecced.getAtmosphereExploreTab`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getAtmosphereExploreTab.json
        public struct ArticleItem: Sendable, Codable {

            /// Indicates whether the item is featured.
            ///
            /// - Important: This property is deprecated. The value is always `false`.
            ///
            /// - Note: According to the AT Protocol specifications: "Deprecated. Retained for
            /// compatibility; always false."
            public let isFeatured: Bool

            /// A strong reference to the Bluesky post associated with the article. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "The Bluesky post associated with
            /// the article, as declared by its author. The referenced post may not be available."
            public let blueskyPostReference: ComAtprotoLexicon.Repository.StrongReference?

            /// The hydrated Bluesky post associated with the article. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "The hydrated Bluesky post
            /// associated with the article, as declared by its author. Omitted when the post is
            /// unavailable to the viewer."
            public let blueskyPostView: AppBskyLexicon.Feed.PostViewDefinition?

            /// The view of the article.
            public let view: AppBskyLexicon.Embed.ExternalDefinition.ViewArticle

            enum CodingKeys: String, CodingKey {
                case isFeatured = "featured"
                case blueskyPostReference = "bskyPostRef"
                case blueskyPostView = "viewBskyPost"
                case view
            }
        }

        /// A publication item.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.unspecced.getAtmosphereExploreTab`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getAtmosphereExploreTab.json
        public struct PublicationItem: Sendable, Codable {

            /// Indicates whether the item is featured.
            ///
            /// - Important: This property is deprecated. The value is always `false`.
            ///
            /// - Note: According to the AT Protocol specifications: "Deprecated. Retained for
            /// compatibility; always false."
            public let isFeatured: Bool

            /// The view of the publication.
            public let view: AppBskyLexicon.Embed.ExternalDefinition.ViewArticlePublication

            enum CodingKeys: String, CodingKey {
                case isFeatured = "featured"
                case view
            }
        }

        /// A gallery item.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.unspecced.getAtmosphereExploreTab`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getAtmosphereExploreTab.json
        public struct GalleryItem: Sendable, Codable {

            /// Indicates whether the item is featured.
            ///
            /// - Important: This property is deprecated. The value is always `false`.
            ///
            /// - Note: According to the AT Protocol specifications: "Deprecated. Retained for
            /// compatibility; always false."
            public let isFeatured: Bool

            /// The view of the gallery.
            public let view: AppBskyLexicon.Embed.ExternalDefinition.ViewGallery

            enum CodingKeys: String, CodingKey {
                case isFeatured = "featured"
                case view
            }
        }

        /// A livestream item.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.unspecced.getAtmosphereExploreTab`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getAtmosphereExploreTab.json
        public struct LivestreamItem: Sendable, Codable {

            /// Indicates whether the item is featured.
            ///
            /// - Important: This property is deprecated. The value is always `false`.
            ///
            /// - Note: According to the AT Protocol specifications: "Deprecated. Retained for
            /// compatibility; always false."
            public let isFeatured: Bool

            /// A strong reference to the Bluesky post that announced the livestream. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "The Bluesky post that announced
            /// the livestream, as declared by its author. The referenced post may not be available."
            public let blueskyPostReference: ComAtprotoLexicon.Repository.StrongReference?

            /// The hydrated Bluesky post that announced the livestream. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "The hydrated Bluesky post that
            /// announced the livestream, as declared by its author. Omitted when the post is
            /// unavailable to the viewer."
            public let blueskyPostView: AppBskyLexicon.Feed.PostViewDefinition?

            /// The view of the livestream.
            public let view: AppBskyLexicon.Embed.ExternalDefinition.ViewLivestream

            enum CodingKeys: String, CodingKey {
                case isFeatured = "featured"
                case blueskyPostReference = "bskyPostRef"
                case blueskyPostView = "viewBskyPost"
                case view
            }
        }

        /// An announcement banner.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.unspecced.getAtmosphereExploreTab`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getAtmosphereExploreTab.json
        public struct AnnouncementBanner: Sendable, Codable {

            /// The ID of the banner. Optional.
            public let id: String?

            /// The title of the banner. Optional.
            public let title: String?

            /// The description of the banner. Optional.
            public let description: String?

            /// The URL the banner links to. Optional.
            public let url: URL?

            /// The image URL of the banner. Optional.
            public let imageURL: URL?

            /// The overlay color of the banner. Optional.
            public let overlayColor: String?

            /// The text color of the banner. Optional.
            public let textColor: String?

            enum CodingKeys: String, CodingKey {
                case id
                case title
                case description
                case url
                case imageURL = "image"
                case overlayColor
                case textColor
            }
        }

        /// A card of an Atmosphere app.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.unspecced.getAtmosphereExploreTab`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getAtmosphereExploreTab.json
        public struct AppCard: Sendable, Codable {

            /// The ID of the app. Optional.
            public let id: String?

            /// The title of the app. Optional.
            public let title: String?

            /// The description of the app. Optional.
            public let description: String?

            /// The logo URL of the app. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "The profile avatar when
            /// available, otherwise the editorial logo."
            public let logoURL: URL?

            /// The background image URL of the app. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "The profile banner when
            /// available, otherwise the editorial background image."
            public let backgroundImageURL: URL?

            /// The overlay color of the card. Optional.
            ///
            /// - Important: This property is deprecated.
            ///
            /// - Note: According to the AT Protocol specifications: "Deprecated. Retained for
            /// compatibility."
            public let overlayColor: String?

            /// The text color of the card. Optional.
            ///
            /// - Important: This property is deprecated.
            ///
            /// - Note: According to the AT Protocol specifications: "Deprecated. Retained for
            /// compatibility."
            public let textColor: String?

            /// The URL of the app. Optional.
            public let url: URL?

            /// The category of the app. Optional.
            public let category: String?

            /// The Bluesky profile of the app. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "The app's optional Bluesky
            /// account profile. Omitted when no profile is configured or the profile is unavailable."
            public let profile: AppBskyLexicon.Actor.ProfileViewDetailedDefinition?

            enum CodingKeys: String, CodingKey {
                case id
                case title
                case description
                case logoURL = "logo"
                case backgroundImageURL = "backgroundImage"
                case overlayColor
                case textColor
                case url
                case category
                case profile
            }
        }
    }

    /// An output model for getting Atmosphere Explore content.
    ///
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    ///
    /// - Note: According to the AT Protocol specifications: "Get Atmosphere Explore content. Articles
    /// and photo galleries are recommended when their algorithmic recommendations are enabled for
    /// the request, and curated otherwise; other sections are curated. Curated content is selected
    /// using the x-atproto-bsky-geo-country, x-atproto-bsky-geo-region, and x-atproto-bsky-topics
    /// request headers. Authentication is optional; authenticated requests include viewer-specific
    /// profile state."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.getAtmosphereExploreTab`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getAtmosphereExploreTab.json
    public struct GetAtmosphereExploreTabOutput: Sendable, Codable {

        /// The announcement banner. Optional.
        public let announcementBanner: AppBskyLexicon.Unspecced.GetAtmosphereExploreTab.AnnouncementBanner?

        /// A list of articles.
        public let articles: AppBskyLexicon.Unspecced.GetAtmosphereExploreTab.ArticleList

        /// A list of publications.
        public let publications: AppBskyLexicon.Unspecced.GetAtmosphereExploreTab.PublicationList

        /// A list of photo galleries.
        public let photos: AppBskyLexicon.Unspecced.GetAtmosphereExploreTab.GalleryList

        /// A list of livestreams.
        public let livestreams: AppBskyLexicon.Unspecced.GetAtmosphereExploreTab.LivestreamList

        /// An array of app cards.
        public let apps: [AppBskyLexicon.Unspecced.GetAtmosphereExploreTab.AppCard]
    }
}
