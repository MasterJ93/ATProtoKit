//
//  AppBskyFeedDescribeFeedGenerator.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-18.
//

import Foundation

extension AppBskyLexicon.Feed {

    /// A definition model for the output ofretrieving information about a feed generator.
    ///
    /// - Note: According to the AT Protocol specifications: "Get information about a
    /// feed generator, including policies and offered feed URIs. Does not require auth;
    /// implemented by Feed Generator services (not App View)."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.describeFeedGenerator`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/describeFeedGenerator.json
    public struct DescribeFeedGeneratorOutput: Sendable, Codable {

        /// The decentralized identifier (DID) of the feed generator.
        public let did: String

        /// An array of feed generators.
        public let feeds: [Feed]

        /// The URL of the Privacy Policy and Terms of Service. Optional.
        public let links: Links?

        enum CodingKeys: CodingKey {
            case did
            case feeds
            case links
        }

        // Enums
        /// A data model definiion for the feed generator.
        public struct Feed: Sendable, Codable {

            /// The URI of the feed.
            public let uri: String

            enum CodingKeys: CodingKey {
                case uri
            }
        }

        /// A data model definition for the Privacy Policy and Terms of Service URLs.
        public struct Links: Sendable, Codable {

            /// The URL to the Privacy Policy.
            public let privacyPolicy: URL?

            /// The URL to the Terms of Service.
            public let termsOfService: URL?
        }
    }
}
