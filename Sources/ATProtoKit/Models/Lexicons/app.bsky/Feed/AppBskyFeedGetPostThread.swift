//
//  AppBskyFeedGetPostThread.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension AppBskyLexicon.Feed {

    /// An output model for retrieving a post thread.
    ///
    /// - Note: According to the AT Protocol specifications: "Get posts in a thread. Does not require
    /// auth, but additional metadata and filtering will be applied for authed requests."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.getPostThread`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/getPostThread.json
    public struct GetPostThreadOutput: Sendable, Codable {

        /// The post thread itself.
        public let thread: ThreadUnion

        /// A feed's threadgate view. Optional.
        public let threadgate: AppBskyLexicon.Feed.ThreadgateViewDefinition?

        // Unions
        /// The post thread itself.
        public enum ThreadUnion: ATUnionProtocol {

            /// The view of a post thread.
            case threadViewPost(AppBskyLexicon.Feed.ThreadViewPostDefinition)

            /// The view of a post that may not have been found.
            case notFoundPost(AppBskyLexicon.Feed.NotFoundPostDefinition)

            /// The view of a post that's been blocked by the post author.
            case blockedPost(AppBskyLexicon.Feed.BlockedPostDefinition)

            /// An unknown case.
            case unknown(String, [String: CodableValue])

            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let type = try container.decode(String.self, forKey: .type)

                switch type {
                    case "app.bsky.feed.defs#threadViewPost":
                        self = .threadViewPost(try AppBskyLexicon.Feed.ThreadViewPostDefinition(from: decoder))
                    case "app.bsky.feed.defs#notFoundPost":
                        self = .notFoundPost(try AppBskyLexicon.Feed.NotFoundPostDefinition(from: decoder))
                    case "app.bsky.feed.defs#blockedPost":
                        self = .blockedPost(try AppBskyLexicon.Feed.BlockedPostDefinition(from: decoder))
                    default:
                        let singleValueDecodingContainer = try decoder.singleValueContainer()
                        let dictionary = try Self.decodeDictionary(from: singleValueDecodingContainer, decoder: decoder)

                        self = .unknown(type, dictionary)
                }
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.singleValueContainer()

                switch self {
                    case .threadViewPost(let value):
                        try container.encode(value)
                    case .notFoundPost(let value):
                        try container.encode(value)
                    case .blockedPost(let value):
                        try container.encode(value)
                    default:
                        break
                }
            }

            enum CodingKeys: String, CodingKey {
                case type = "$type"
            }
        }
    }
}
