//
//  AppBskyBookmarkDefs.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-09-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Bookmark {

    /// A definition model for a bookmark.
    ///
    /// - Note: According to the AT Protocol specifications: "Object used to store bookmark data in stash."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/bookmark/defs.json
    public struct BookmarkDefinition: Sendable, Codable, Equatable, Hashable {

        /// The strong reference of the bookmark.
        ///
        /// - Note: According to the AT Protocol specifications: "A strong ref to the record to
        /// be bookmarked. Currently, only `app.bsky.feed.post` records are supported."
        public let subject: ComAtprotoLexicon.Repository.StrongReference
    }

    /// A definition model for a bookmark view.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/bookmark/defs.json
    public struct BookmarkViewDefinition: Sendable, Codable, Equatable, Hashable {

        /// The strong reference of the bookmark.
        ///
        /// - Note: According to the AT Protocol specifications: "A strong reference to the
        /// bookmarked record."
        public let subject: ComAtprotoLexicon.Repository.StrongReference

        /// The date and time the bookmark was created at. Optional.
        public let createdAt: Date?

        /// The bookmark item itself.
        public let item: Item

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.subject = try container.decode(ComAtprotoLexicon.Repository.StrongReference.self, forKey: .subject)
            self.createdAt = try container.decodeDate(forKey: .createdAt)
            self.item = try container.decode(AppBskyLexicon.Bookmark.BookmarkViewDefinition.Item.self, forKey: .item)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.subject, forKey: .subject)
            try container.encodeDateIfPresent(self.createdAt, forKey: .createdAt)
            try container.encode(self.item, forKey: .item)
        }

        public enum CodingKeys: CodingKey {
            case subject
            case createdAt
            case item
        }

        // Unions
        /// The bookmark item itself.
        public enum Item: ATUnionProtocol, Equatable, Hashable {

            /// The view of a post that's been blocked by the post author.
            case blockedPost(AppBskyLexicon.Feed.BlockedPostDefinition)

            /// The view of a post that may not have been found.
            case notFoundPost(AppBskyLexicon.Feed.NotFoundPostDefinition)

            /// The view of a post.
            case postView(AppBskyLexicon.Feed.PostViewDefinition)

            /// An unknown case.
            case unknown(String, [String: CodableValue])

            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let type = try container.decodeIfPresent(String.self, forKey: .type)

                switch type {
                    case "app.bsky.feed.defs#blockedPost":
                        self = .blockedPost(try AppBskyLexicon.Feed.BlockedPostDefinition(from: decoder))
                    case "app.bsky.feed.defs#notFoundPost":
                        self = .notFoundPost(try AppBskyLexicon.Feed.NotFoundPostDefinition(from: decoder))
                    case "app.bsky.feed.defs#postView":
                        self = .postView(try AppBskyLexicon.Feed.PostViewDefinition(from: decoder))
                    default:
                        let singleValueDecodingContainer = try decoder.singleValueContainer()
                        let dictionary = try Self.decodeDictionary(from: singleValueDecodingContainer, decoder: decoder)

                        self = .unknown(type ?? "unknown", dictionary)
                }
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()

                switch self {
                    case .blockedPost(let value):
                        try container.encode(value)
                    case .notFoundPost(let value):
                        try container.encode(value)
                    case .postView(let value):
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
