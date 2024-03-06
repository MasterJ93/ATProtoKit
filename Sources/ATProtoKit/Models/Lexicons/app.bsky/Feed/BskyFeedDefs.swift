//
//  BskyFeedDefs.swift
//  
//
//  Created by Christopher Jr Riley on 2024-01-25.
//

import Foundation

/// A data model for a post view definition.
///
/// - SeeAlso: This is based on the [`app.bsky.feed.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/defs.json
public struct FeedPostView: Codable {
    /// The URI of the post.
    public let postURI: String
    /// The CID of the post.
    public let cidHash: String
    /// The author of the post. This will give the basic details of the post author.
    public let author: ActorProfileViewBasic
    /// The record data itself.
    public let record: FeedPost
    /// An embed view of a specific type. Optional.
    public var embed: EmbedViewUnion? = nil
    /// The number of replies in the post. Optional.
    public var replyCount: Int? = nil
    /// The number of reposts in the post. Optional.
    public var repostCount: Int? = nil
    /// The number of likes in the post. Optional.
    public var likeCount: Int? = nil
    /// The last time the post has been indexed.
    @DateFormatting public var indexedAt: Date
    /// The viewer's interaction with the post. Optional.
    public var viewer: FeedViewerState? = nil
    /// An array of labels attached to the post. Optional.
    public var labels: [Label]? = nil
    /// The ruleset of who can reply to the post. Optional.
    public var threadgate: FeedThreadgateView? = nil

    public init(postURI: String, cidHash: String, author: ActorProfileViewBasic, record: FeedPost, embed: EmbedViewUnion?, replyCount: Int?,
                repostCount: Int?, likeCount: Int?, indexedAt: Date, viewer: FeedViewerState?, labels: [Label]?, threadgate: FeedThreadgateView?) {
        self.postURI = postURI
        self.cidHash = cidHash
        self.author = author
        self.record = record
        self.embed = embed
        self.replyCount = replyCount
        self.repostCount = repostCount
        self.likeCount = likeCount
        self._indexedAt = DateFormatting(wrappedValue: indexedAt)
        self.viewer = viewer
        self.labels = labels
        self.threadgate = threadgate
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.postURI = try container.decode(String.self, forKey: .postURI)
        self.cidHash = try container.decode(String.self, forKey: .cidHash)
        self.author = try container.decode(ActorProfileViewBasic.self, forKey: .author)
        self.record = try container.decode(FeedPost.self, forKey: .record)
        self.embed = try container.decodeIfPresent(EmbedViewUnion.self, forKey: .embed)
        self.replyCount = try container.decodeIfPresent(Int.self, forKey: .replyCount)
        self.repostCount = try container.decodeIfPresent(Int.self, forKey: .repostCount)
        self.likeCount = try container.decodeIfPresent(Int.self, forKey: .likeCount)
        self.indexedAt = try container.decode(DateFormatting.self, forKey: .indexedAt).wrappedValue
        self.viewer = try container.decodeIfPresent(FeedViewerState.self, forKey: .viewer)
        self.labels = try container.decodeIfPresent([Label].self, forKey: .labels)
        self.threadgate = try container.decodeIfPresent(FeedThreadgateView.self, forKey: .threadgate)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.postURI, forKey: .postURI)
        try container.encode(self.cidHash, forKey: .cidHash)
        try container.encode(self.author, forKey: .author)
        try container.encode(self.record, forKey: .record)
        try container.encodeIfPresent(self.embed, forKey: .embed)
        try container.encodeIfPresent(self.replyCount, forKey: .replyCount)
        try container.encodeIfPresent(self.repostCount, forKey: .repostCount)
        try container.encodeIfPresent(self.likeCount, forKey: .likeCount)
        try container.encode(self._indexedAt, forKey: .indexedAt)
        try container.encodeIfPresent(self.viewer, forKey: .viewer)
        try container.encodeIfPresent(self.labels, forKey: .labels)
        try container.encodeIfPresent(self.threadgate, forKey: .threadgate)
    }

    enum CodingKeys: String, CodingKey {
        case postURI = "uri"
        case cidHash = "cid"
        case author
        case record
        case embed
        case replyCount
        case repostCount
        case likeCount
        case indexedAt
        case viewer
        case labels
        case threadgate
    }
}

/// A data model for a viewer state definition.
///
/// - Note: According to the AT Protocol specifications: "Metadata about the requesting account's relationship with the subject content. Only has meaningful content for authed requests."
///
/// - SeeAlso: This is based on the [`app.bsky.feed.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/defs.json
public struct FeedViewerState: Codable {
    /// The URI of the requesting account's repost of the subject account's post. Optional.
    public let repostURI: String? = nil
    /// The URI of the requesting account's like of the subject account's post. Optional.
    public let likeURI: String? = nil
    /// Indicates whether the requesting account can reply to the account's post. Optional.
    public let areRepliesDisabled: Bool? = nil

    enum CodingKeys: String, CodingKey {
        case repostURI = "repost"
        case likeURI = "like"
        case areRepliesDisabled = "replyDisabled"
    }
}

/// A data model for a definition of a feed's view.
///
/// - SeeAlso: This is based on the [`app.bsky.feed.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/defs.json
public struct FeedViewPost: Codable {
    /// The post contained in a feed.
    public let post: FeedPostView
    /// The reply reference for the post, if it's a reply. Optional.
    public var reply: FeedReplyReference? = nil
    // TODO: Check to see if this is correct.
    /// The user who reposted the post. Optional.
    public var reason: FeedReasonRepost? = nil
}

/// A data model for a reply reference definition.
///
/// - SeeAlso: This is based on the [`app.bsky.feed.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/defs.json
public struct FeedReplyReference: Codable {
    /// The original post of the thread.
    public let root: PostUnion
    // TODO: Fix up the note's message.
    /// The direct post that the user's post is replying to.
    ///
    /// - Note: If `parent` and `root` are identical, the post is a direct reply to the original post of the thread.
    public let parent: PostUnion
}

/// A data model for a definition for a very stripped down version of a repost.
///
/// - SeeAlso: This is based on the [`app.bsky.feed.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/defs.json
public struct FeedReasonRepost: Codable {
    /// The basic details of the user who reposted the post.
    public let by: ActorProfileViewBasic
    /// The last time the repost was indexed.
    @DateFormatting public var indexedAt: Date

    public init(by: ActorProfileViewBasic, indexedAt: Date) {
        self.by = by
        self._indexedAt = DateFormatting(wrappedValue: indexedAt)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.by = try container.decode(ActorProfileViewBasic.self, forKey: .by)
        self.indexedAt = try container.decode(DateFormatting.self, forKey: .indexedAt).wrappedValue
    }

    enum CodingKeys: CodingKey {
        case by
        case indexedAt
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.by, forKey: .by)
        try container.encode(self._indexedAt, forKey: .indexedAt)
    }
}

/// A data model for a definition of a hydrated version of a repost.
///
/// - SeeAlso: This is based on the [`app.bsky.feed.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/defs.json
public struct FeedThreadViewPost: Codable {
    /// The post contained in a thread.
    public let post: FeedPostView
    /// The direct post that the user's post is replying to. Optional.
    public var parent: ThreadPostUnion? = nil
    /// An array of posts of various types. Optional.
    public var replies: [ThreadPostUnion]? = nil
}

/// A data model for a definition of a post that may not have been found.
///
/// - SeeAlso: This is based on the [`app.bsky.feed.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/defs.json
public struct FeedNotFoundPost: Codable {
    /// The URI of the post.
    public let feedURI: String
    /// Indicates whether the post wasn't found. Defaults to `true`.
    public private(set) var isNotFound: Bool = true

    public init(feedURI: String, isNotFound: Bool = true) {
        self.feedURI = feedURI
        self.isNotFound = isNotFound
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        feedURI = try container.decode(String.self, forKey: .feedURI)
        isNotFound = (try? container.decodeIfPresent(Bool.self, forKey: .isNotFound)) ?? true
    }

    enum CodingKeys: String, CodingKey {
        case feedURI = "uri"
        case isNotFound = "notFound"
    }
}

/// A data model for a definition of a post that may have been blocked.
///
/// - SeeAlso: This is based on the [`app.bsky.feed.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/defs.json
public struct FeedBlockedPost: Codable {
    /// The URI of the post.
    public let feedURI: String
    /// Indicates whether this post has been blocked from the user. Defaults to `true`.
    public private(set) var isBlocked: Bool = true
    /// The author of the post.
    public let author: FeedBlockedAuthor

    public init(feedURI: String, isBlocked: Bool = true, author: FeedBlockedAuthor) {
        self.feedURI = feedURI
        self.isBlocked = isBlocked
        self.author = author
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.feedURI = try container.decode(String.self, forKey: .feedURI)
        self.isBlocked = (try? container.decode(Bool.self, forKey: .isBlocked)) ?? true
        self.author = try container.decode(FeedBlockedAuthor.self, forKey: .author)
    }

    enum CodingKeys: String, CodingKey {
        case feedURI = "uri"
        case isBlocked = "blocked"
        case author
    }
}

/// The data model of a blocked author definition.
///
/// - SeeAlso: This is based on the [`app.bsky.feed.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/defs.json
public struct FeedBlockedAuthor: Codable {
    /// The URI of the author.
    public let authorDID: String
    /// The viewer state of the user. Optional.
    public var viewer: ActorViewerState? = nil

    enum CodingKeys: String, CodingKey {
        case authorDID = "did"
        case viewer
    }
}

/// The data model of a feed generator definition.
///
/// - SeeAlso: This is based on the [`app.bsky.feed.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/defs.json
public struct FeedGeneratorView: Codable {
    /// The URI of the feed generator.
    public let feedURI: String
    /// The CID of the feed generator.
    public let cidHash: String
    /// The decentralized identifier (DID) of the feed generator.
    public let feedDID: String
    /// The author of the feed generator.
    public let creator: ActorProfileView
    /// The display name of the feed generator.
    public let displayName: String
    /// The description of the feed generator. Optional.
    public var description: String? = nil
    /// An array of the facets within the feed generator's description.
    public let descriptionFacets: [Facet]?
    /// The avatar image URL of the feed generator.
    public var avatarImageURL: URL? = nil
    /// The number of likes for the feed generator.
    public let likeCount: Int? = nil
    /// The viewer's state for the feed generator.
    public var viewer: FeedGeneratorViewerState? = nil
    /// The last time the feed generator was indexed.
    @DateFormatting public var indexedAt: Date

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.feedURI = try container.decode(String.self, forKey: .feedURI)
        self.cidHash = try container.decode(String.self, forKey: .cidHash)
        self.feedDID = try container.decode(String.self, forKey: .feedDID)
        self.creator = try container.decode(ActorProfileView.self, forKey: .creator)
        self.displayName = try container.decode(String.self, forKey: .displayName)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.descriptionFacets = try container.decodeIfPresent([Facet].self, forKey: .descriptionFacets)
        self.avatarImageURL = try container.decodeIfPresent(URL.self, forKey: .avatarImageURL)
        self.viewer = try container.decodeIfPresent(FeedGeneratorViewerState.self, forKey: .viewer)
        self.indexedAt = try container.decode(DateFormatting.self, forKey: .indexedAt).wrappedValue
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.feedURI, forKey: .feedURI)
        try container.encode(self.cidHash, forKey: .cidHash)
        try container.encode(self.feedDID, forKey: .feedDID)
        try container.encode(self.creator, forKey: .creator)
        try container.encode(self.displayName, forKey: .displayName)

        // Truncate `description` to 3000 characters before encoding
        // `maxGraphemes`'s limit is 300, but `String.count` should respect that limit
        try truncatedEncodeIfPresent(self.description, withContainer: &container, forKey: .displayName, upToLength: 3000)

        try container.encodeIfPresent(self.descriptionFacets, forKey: .descriptionFacets)
        try container.encodeIfPresent(self.avatarImageURL, forKey: .avatarImageURL)

        // Assuming `likeCount` is not nil, only encode it if it's 0 or higher
        if let likeCount = self.likeCount, likeCount >= 0 {
            try container.encode(likeCount, forKey: .likeCount)
        }
        try container.encodeIfPresent(self.viewer, forKey: .viewer)
        try container.encode(self._indexedAt, forKey: .indexedAt)
    }

    enum CodingKeys: String, CodingKey {
        case feedURI = "uri"
        case cidHash = "cid"
        case feedDID = "did"
        case creator
        case displayName
        case description
        case descriptionFacets = "descriptionFacets"
        case avatarImageURL = "avatar"
        case likeCount = "likeCount"
        case viewer
        case indexedAt
    }
}

/// The data model of a definition for the viewer's state of the feed generator.
///
/// - SeeAlso: This is based on the [`app.bsky.feed.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/defs.json
public struct FeedGeneratorViewerState: Codable {
    /// The URI of the viewer's like, if they liked the feed generator. Optional.
    public var likeURI: String? = nil

    enum CodingKeys: String, CodingKey {
        case likeURI = "like"
    }
}

/// The data model of a feed's skeleton
public struct FeedSkeletonFeedPost: Codable {
    /// The URI of the post in the feed generator.
    ///
    /// - Note: This refers to the original post's URI. If the post is a repost, then `reason` will contain a value.
    public let postURI: String
    /// The indication that the post was a repost. Optional.
    public var reason: FeedSkeletonReasonRepost? = nil

    enum CodingKeys: String, CodingKey {
        case postURI = "post"
        case reason
    }
}

/// The data model of a definition for a respost in a feed generator.
///
/// - SeeAlso: This is based on the [`app.bsky.feed.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/defs.json
public struct FeedSkeletonReasonRepost: Codable {
    /// The URI of the repost.
    ///
    /// This property uniquely identifies the repost itself, separate from the original post's URI.
    public let repostURI: String

    enum CodingKeys: String, CodingKey {
        case repostURI = "repost"
    }
}

/// The data model of a feed threadgate view definition.
///
/// - SeeAlso: This is based on the [`app.bsky.feed.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/defs.json
public struct FeedThreadgateView: Codable {
    /// The URI of the feed's threadgate.
    public let threadgateURI: String
    /// The CID of the feed's threadgate.
    public let cidHash: String
    /// The record of the feed's threadgate
    public let record: UnknownType
    // TODO: Make sure this is correct.
    /// An array of user lists.
    public let lists: [GraphListViewBasic]

    enum CodingKeys: String, CodingKey {
        case threadgateURI = "uri"
        case cidHash = "cid"
        case record = "record"
        case lists = "lists"
    }
}

// MARK: - Union Types
/// A reference containing the list of the types of embeds.
///
/// - Note: This is based on the following lexicons:\
///\- `app.bsky.embed.record`\
///\- `app.bsky.feed.defs`
///
/// - SeeAlso: The lexicons can be viewed in their GitHub repo pages:\
/// \- [`app.bsky.embed.record`][embed_record]\
/// \- [`app.bsky.feed.defs`][feed_def]
///
/// [embed_record]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/record.json
/// [feed_def]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/defs.json
public enum EmbedViewUnion: Codable {
    /// The view of an external embed.
    case embedExternalView(EmbedExternalView)
    /// The view of an image embed.
    case embedImagesView(EmbedImagesView)
    /// The view of a record embed.
    case embedRecordView(EmbedRecordView)
    /// The view of a record embed alongside an embed of some compatible media.
    case embedRecordWithMediaView(EmbedRecordWithMediaView)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let value = try? container.decode(EmbedExternalView.self) {
            self = .embedExternalView(value)
        } else if let value = try? container.decode(EmbedImagesView.self) {
            self = .embedImagesView(value)
        } else if let value = try? container.decode(EmbedRecordView.self) {
            self = .embedRecordView(value)
        } else if let value = try? container.decode(EmbedRecordWithMediaView.self) {
            self = .embedRecordWithMediaView(value)
        } else {
            throw DecodingError.typeMismatch(EmbedViewUnion.self,
                                             DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unknown EmbedView type"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
            case .embedExternalView(let embedView):
                try container.encode(embedView)
            case .embedImagesView(let embedView):
                try container.encode(embedView)
            case .embedRecordView(let embedView):
                try container.encode(embedView)
            case .embedRecordWithMediaView(let embedView):
                try container.encode(embedView)
        }
    }
}

/// A reference containing the list of the states of a post.
///
/// - SeeAlso: This is based on the [`app.bsky.feed.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/defs.json
public enum PostUnion: Codable {
    /// The view of a post.
    case postView(FeedPostView)
    /// The view of a post that may not have been found.
    case notFoundPost(FeedNotFoundPost)
    /// The view of a post that's been blocked by the post author.
    case blockedPost(FeedBlockedPost)

    // Custom coding keys and init(from:) / encode(to:) will be needed here for Codable conformance.
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let value = try? container.decode(FeedPostView.self) {
            self = .postView(value)
        } else if let value = try? container.decode(FeedNotFoundPost.self) {
            self = .notFoundPost(value)
        } else if let value = try? container.decode(FeedBlockedPost.self) {
            self = .blockedPost(value)
        } else {
            throw DecodingError.typeMismatch(
                PostUnion.self, DecodingError.Context(
                    codingPath: decoder.codingPath, debugDescription: "Unknown PostUnion type"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
            case .postView(let union):
                try container.encode(union)
            case .notFoundPost(let union):
                try container.encode(union)
            case .blockedPost(let union):
                try container.encode(union)
        }
    }
}

/// A reference containing the list of the states of a post.
///
/// - SeeAlso: This is based on the [`app.bsky.feed.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/defs.json
public indirect enum ThreadPostUnion: Codable {
    /// The view of a post thread.
    case threadViewPost(FeedThreadViewPost)
    /// The view of a post that may not have been found.
    case notFoundPost(FeedNotFoundPost)
    /// The view of a post that's been blocked by the post author.
    case blockedPost(FeedBlockedPost)

    // Custom coding keys and init(from:) / encode(to:) will be needed here for Codable conformance.
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let value = try? container.decode(FeedThreadViewPost.self) {
            self = .threadViewPost(value)
        } else if let value = try? container.decode(FeedNotFoundPost.self) {
            self = .notFoundPost(value)
        } else if let value = try? container.decode(FeedBlockedPost.self) {
            self = .blockedPost(value)
        } else {
            throw DecodingError.typeMismatch(
                ThreadPostUnion.self, DecodingError.Context(
                    codingPath: decoder.codingPath, debugDescription: "Unknown ThreadPostUnion type"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
            case .threadViewPost(let union):
                try container.encode(union)
            case .notFoundPost(let union):
                try container.encode(union)
            case .blockedPost(let union):
                try container.encode(union)
        }
    }
}
