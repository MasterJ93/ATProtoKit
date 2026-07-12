//
//  AppBskyFeedGetQuotes.swift
//
//
//  Created by Christopher Jr Riley on 2024-08-23.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Feed {

    /// An output model for getting the quote posts of a given post.
    ///
    /// - Note: According to the AT Protocol specifications: "Get posts in a thread. Does not require
    /// auth, but additional metadata and filtering will be applied for authed requests."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.getPostThread`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/getPostThread.json
    public struct GetQuotesOutput: Sendable, Codable {

        /// The URI of the given post.
        public let postURI: String

        /// The CID hash of the given post.
        public let postCID: String?

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of quote posts.
        public let posts: [AppBskyLexicon.Feed.PostViewDefinition]

        public init(postURI: String, postCID: String?, cursor: String?, posts: [AppBskyLexicon.Feed.PostViewDefinition]) {
            self.postURI = postURI
            self.postCID = postCID
            self.cursor = cursor
            self.posts = posts
        }
        
        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.postURI = try container.decode(String.self, forKey: .postURI)
            self.postCID = try container.decodeIfPresent(String.self, forKey: .postCID)
            self.cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
            self.posts = try container.decode([AppBskyLexicon.Feed.PostViewDefinition].self, forKey: .posts)
        }
        
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(self.postURI, forKey: .postURI)
            try container.encodeIfPresent(self.postCID, forKey: .postCID)
            try container.encodeIfPresent(self.cursor, forKey: .cursor)
            try container.encode(self.posts, forKey: .posts)
        }
        
        enum CodingKeys: String, CodingKey {
            case postURI = "uri"
            case postCID = "cid"
            case cursor
            case posts
        }
    }
}
