//
//  AppBskyUnspeccedDefs.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension AppBskyLexicon.Unspecced {

    /// A definition model for a skeleton post in a search context.
    ///
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/unspecced/defs.json
    public struct SkeletonSearchPostDefinition: Sendable, Codable {

        /// The URI of the skeleton post.
        public let postURI: String

        enum CodingKeys: String, CodingKey {
            case postURI = "uri"
        }
    }

    /// A definition model for a skeleton post in a search context.
    ///
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/unspecced/defs.json
    public struct SkeletonSearchActorDefinition: Sendable, Codable {

        /// The URI of the skeleton actor.
        public let did: String

        enum CodingKeys: String, CodingKey {
            case did
        }
    }

    /// A definition model for a skeleton starter pack in a search context.
    ///
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/unspecced/defs.json
    public struct SkeletonSearchStarterPackDefinition: Sendable, Codable {

        /// The URI of the skeleton starter pack.
        public let uri: String
    }

    /// A definition model for a trending topic.
    ///
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/unspecced/defs.json
    public struct TrendingTopic: Sendable, Codable {

        /// The topic itself.
        public let topic: String

        /// The display name of the topic. Optional.
        public let displayName: String?

        /// A description about the topic. Optional.
        public let description: String?

        /// The link the trending topic is located.
        public let link: String
    }
}
