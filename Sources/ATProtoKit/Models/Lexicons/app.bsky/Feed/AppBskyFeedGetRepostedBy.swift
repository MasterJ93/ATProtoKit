//
//  AppBskyFeedGetRepostedBy.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Feed {

    /// An output model for retrieving an array of users who have reposted the given post.
    ///
    /// - Note: According to the AT Protocol specifications: "Get a list of reposts for a
    /// given post."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.getRepostedBy`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/getRepostedBy.json
    public struct GetRepostedByOutput: Sendable, Codable {

        /// The URI of the post record.
        public let postURI: String

        /// The CID hash of the post record.
        public let postCID: String?

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of user accounts who reposted the post record.
        public let repostedBy: [AppBskyLexicon.Actor.ProfileViewDefinition]

        public init(postURI: String, postCID: String?, cursor: String?, repostedBy: [AppBskyLexicon.Actor.ProfileViewDefinition]) {
            self.postURI = postURI
            self.postCID = postCID
            self.cursor = cursor
            self.repostedBy = repostedBy
        }
        
        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.postURI = try container.decode(String.self, forKey: .postURI)
            self.postCID = try container.decodeIfPresent(String.self, forKey: .postCID)
            self.cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
            self.repostedBy = try container.decode([AppBskyLexicon.Actor.ProfileViewDefinition].self, forKey: .repostedBy)
        }
        
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(self.postURI, forKey: .postURI)
            try container.encodeIfPresent(self.postCID, forKey: .postCID)
            try container.encodeIfPresent(self.cursor, forKey: .cursor)
            try container.encode(self.repostedBy, forKey: .repostedBy)
        }
        
        enum CodingKeys:String, CodingKey {
            case postURI = "uri"
            case postCID = "cid"
            case cursor
            case repostedBy
        }
    }
}
