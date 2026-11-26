//
//  AppBskyUnspeccedGetAtmosphereApps.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Unspecced {

    /// The main data model definition for getting curated Atmosphere apps.
    ///
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    public struct GetAtmosphereApps: Sendable, Codable {

        /// A card of an Atmosphere app.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.unspecced.getAtmosphereApps`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getAtmosphereApps.json
        public struct AppCard: Sendable, Codable {

            /// The ID of the app. Optional.
            public let id: String?

            /// The title of the app. Optional.
            public let title: String?

            /// The description of the app. Optional.
            public let description: String?

            /// The logo URL of the app. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "The app's logo, using its
            /// account avatar when available."
            public let logoURL: URL?

            /// The banner URL of the app. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "The app's banner, using its
            /// account banner when available."
            public let bannerURL: URL?

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
                case bannerURL = "banner"
                case url
                case category
                case profile
            }
        }
    }

    /// An output model for getting curated Atmosphere apps.
    ///
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    ///
    /// - Note: According to the AT Protocol specifications: "Get curated Atmosphere apps.
    /// Authentication is optional; authenticated requests include viewer-specific profile state
    /// and known followers."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.getAtmosphereApps`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getAtmosphereApps.json
    public struct GetAtmosphereAppsOutput: Sendable, Codable {

        /// An array of app cards.
        public let apps: [AppBskyLexicon.Unspecced.GetAtmosphereApps.AppCard]
    }
}
