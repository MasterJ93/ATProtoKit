//
//  AppBskyFeedSearchPostsV2.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-10.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Feed {

    /// The main data model definition for the results of the v2 post search query.
    public struct SearchPostsV2: Sendable, Codable {

        /// Determines the ranking order for the search results.
        ///
        /// - Note: According to the AT Protocol specifications: "Ranking order for results."
        ///
        /// - SeeAlso: This is based on the [`app.bsky.feed.searchPostsV2`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/searchPostsV2.json
        public enum SortRanking: String, Sendable, Codable {

            /// Indicates the results will be sorted by recency.
            case recent

            /// Indicates the results will be sorted by search ranking.
            case top
        }

        /// The language analyzer hint for query text processing.
        ///
        /// - Note: According to the AT Protocol specifications: "Language analyzer hint for the
        /// query text. If unset, the server auto-detects when possible."
        ///
        /// - SeeAlso: This is based on the [`app.bsky.feed.searchPostsV2`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/searchPostsV2.json
        public enum QueryLanguage: Sendable, Codable, ExpressibleByStringLiteral {

            /// Japanese.
            case japanese

            /// Chinese.
            case chinese

            /// Korean.
            case korean

            /// Thai.
            case thai

            /// Arabic.
            case arabic

            /// An unknown value that the object may contain.
            case unknown(String)

            public var rawValue: String {
                switch self {
                    case .japanese:
                        return "ja"
                    case .chinese:
                        return "zh"
                    case .korean:
                        return "ko"
                    case .thai:
                        return "th"
                    case .arabic:
                        return "ar"
                    case .unknown(let value):
                        return value
                }
            }

            public init(stringLiteral value: String) {
                self = .unknown(value)
            }

            public init(from decoder: Decoder) throws {
                let container = try decoder.singleValueContainer()
                let value = try container.decode(String.self)

                switch value {
                    case "ja":
                        self = .japanese
                    case "zh":
                        self = .chinese
                    case "ko":
                        self = .korean
                    case "th":
                        self = .thai
                    case "ar":
                        self = .arabic
                    default:
                        self = .unknown(value)
                }
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()
                try container.encode(self.rawValue)
            }
        }
    }

    /// An output model for the results of the v2 post search query.
    ///
    /// - Note: According to the AT Protocol specifications: "Find posts matching a search query
    /// or filters, returning search hits for matching post records."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.searchPostsV2`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/searchPostsV2.json
    public struct SearchPostsV2Output: Sendable, Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// Estimated total number of matching hits. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "May be rounded or truncated."
        public let hitsTotal: Int?

        /// Hydrated views of matching posts.
        public let posts: [PostViewDefinition]

        /// Query languages detected for CJK, Thai, or Arabic text. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Empty or omitted for other scripts."
        public let detectedQueryLanguages: [AppBskyLexicon.Feed.SearchPostsV2.QueryLanguage]?
    }
}
