//
//  BskyFeedGetPostThread.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-05.
//

import Foundation

/// The main data model definition for the output of retrieving a post thread.
///
/// - Note: According to the AT Protocol specifications: "Get posts in a thread. Does not require auth, but additional metadata and filtering will be applied for authed requests."
///
/// - SeeAlso: This is based on the [`app.bsky.feed.getPostThread`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/getPostThread.json
public struct FeedGetPostThreadOutput: Codable {
    /// The post thread itself.
    public let thread: FeedGetPostThreadUnion
}

/// A reference containing the list of the state of a post thread.
public enum FeedGetPostThreadUnion: Codable {
    /// A post thread.
    case threadViewPost(FeedThreadViewPost)
    /// The post thread wasn't found.
    case notFoundPost(FeedNotFoundPost)
    /// The post thread was made by someone who blocked the user account.
    case blockedPost(FeedBlockedPost)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let value = try? container.decode(FeedThreadViewPost.self) {
            self = .threadViewPost(value)
        } else if let value = try? container.decode(FeedNotFoundPost.self) {
            self = .notFoundPost(value)
        } else if let value = try? container.decode(FeedBlockedPost.self) {
            self = .blockedPost(value)
        } else {
            throw DecodingError.typeMismatch(FeedGetPostThreadUnion.self,
                                             DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unknown FeedGetPostThread type"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
            case .threadViewPost(let threadViewPost):
                try container.encode(threadViewPost)
            case .notFoundPost(let notFoundPost):
                try container.encode(notFoundPost)
            case .blockedPost(let blockedPost):
                try container.encode(blockedPost)
        }
    }
}
