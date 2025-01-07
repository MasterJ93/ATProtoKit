//
//  AppBskyGraphStarterpack.swift
//
//
//  Created by Christopher Jr Riley on 2024-06-28.
//

import Foundation

extension AppBskyLexicon.Graph {

    /// A record model for a starter pack.
    ///
    /// - Note: According to the AT Protocol specifications: "Record defining a starter pack of
    /// actors and feeds for new users."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.graph.starterpack`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/starterpack.json
    public struct StarterpackRecord: ATRecordProtocol, Sendable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public static let type: String = "app.bsky.graph.starterpack"

        /// The name of the starter pack.
        ///
        /// - Note: According to the AT Protocol specifications: "Display name for starter pack;
        /// can not be empty."
        public let name: String

        /// The description of the starter pack.
        public let description: String?

        /// An array of the facets within the feed generator's description.
        public let descriptionFacets: [AppBskyLexicon.RichText.Facet]?

        /// The URI of the list record.
        ///
        /// - Note: According to the AT Protocol specifications: "Display name for starter pack;
        /// can not be empty."
        public let listURI: String

        /// An array of feeds.
        public let feeds: [FeedItem]?

        /// The date the starter pack was created..
        public let createdAt: Date

        public init(name: String, description: String?, descriptionFacets: [AppBskyLexicon.RichText.Facet]?, listURI: String, feeds: [FeedItem],
                    createdAt: Date) {
            self.name = name
            self.description = description
            self.descriptionFacets = descriptionFacets
            self.listURI = listURI
            self.feeds = feeds
            self.createdAt = createdAt
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.name = try container.decode(String.self, forKey: .name)
            self.description = try container.decodeIfPresent(String.self, forKey: .description)
            self.descriptionFacets = try container.decodeIfPresent([AppBskyLexicon.RichText.Facet].self, forKey: .descriptionFacets)
            self.listURI = try container.decode(String.self, forKey: .listURI)
            self.feeds = try container.decodeIfPresent([FeedItem].self, forKey: .feeds)
            self.createdAt = try decodeDate(from: container, forKey: .createdAt)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try truncatedEncode(self.name, withContainer: &container, forKey: .name, upToCharacterLength: 50)
            try truncatedEncodeIfPresent(self.name, withContainer: &container, forKey: .name, upToCharacterLength: 300)
            try container.encodeIfPresent(self.descriptionFacets, forKey: .descriptionFacets)
            try container.encode(self.listURI, forKey: .listURI)
            try truncatedEncodeIfPresent(self.feeds, withContainer: &container, forKey: .feeds, upToArrayLength: 3)
            try encodeDate(self.createdAt, with: &container, forKey: .createdAt)
        }

        enum CodingKeys: String, CodingKey {
            case type = "Stype"
            case name
            case description
            case descriptionFacets
            case listURI = "list"
            case feeds
            case createdAt
        }

        /// A feed within the starter pack.
        public struct FeedItem: Sendable, Codable, Equatable, Hashable {

            /// The URI of the feed.
            public let uri: String
        }

    }
}
