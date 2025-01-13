//
//  AppBskyFeedDefs.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-18.
//

import Foundation

extension AppBskyLexicon.Feed {

    /// A definition model for a post view.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/defs.json
    public struct PostViewDefinition: Sendable, Codable, Equatable, Hashable {

        /// The URI of the post.
        public let uri: String

        /// The CID hash of the post.
        public let cid: String

        /// The author of the post. This will give the basic details of the post author.
        public let author: AppBskyLexicon.Actor.ProfileViewBasicDefinition

        /// The record data itself.
        public let record: UnknownType

        /// An embed view of a specific type. Optional.
        public var embed: ATUnion.EmbedViewUnion?

        /// The number of replies in the post. Optional.
        public let replyCount: Int?

        /// The number of reposts in the post. Optional.
        public let repostCount: Int?

        /// The number of likes in the post. Optional.
        public let likeCount: Int?

        /// The number of quote posts in the post. Optional.
        public let quoteCount: Int?

        /// The last time the post has been indexed.
        public var indexedAt: Date

        /// The viewer's interaction with the post. Optional.
        public let viewer: ViewerStateDefinition?

        /// An array of labels attached to the post. Optional.
        public let labels: [ComAtprotoLexicon.Label.LabelDefinition]?

        /// The ruleset of who can reply to the post. Optional.
        public let threadgate: ThreadgateViewDefinition?

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.uri = try container.decode(String.self, forKey: .uri)
            self.cid = try container.decode(String.self, forKey: .cid)
            self.author = try container.decode(AppBskyLexicon.Actor.ProfileViewBasicDefinition.self, forKey: .author)
            self.record = try container.decode(UnknownType.self, forKey: .record)
            self.embed = try container.decodeIfPresent(ATUnion.EmbedViewUnion.self, forKey: .embed)
            self.replyCount = try container.decodeIfPresent(Int.self, forKey: .replyCount)
            self.repostCount = try container.decodeIfPresent(Int.self, forKey: .repostCount)
            self.likeCount = try container.decodeIfPresent(Int.self, forKey: .likeCount)
            self.quoteCount = try container.decodeIfPresent(Int.self, forKey: .quoteCount)
            self.indexedAt = try container.decodeDate(forKey: .indexedAt)
            self.viewer = try container.decodeIfPresent(AppBskyLexicon.Feed.ViewerStateDefinition.self, forKey: .viewer)
            self.labels = try container.decodeIfPresent([ComAtprotoLexicon.Label.LabelDefinition].self, forKey: .labels)
            self.threadgate = try container.decodeIfPresent(AppBskyLexicon.Feed.ThreadgateViewDefinition.self, forKey: .threadgate)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.uri, forKey: .uri)
            try container.encode(self.cid, forKey: .cid)
            try container.encode(self.author, forKey: .author)
            try container.encode(self.record, forKey: .record)
            try container.encodeIfPresent(self.embed, forKey: .embed)
            try container.encodeIfPresent(self.replyCount, forKey: .replyCount)
            try container.encodeIfPresent(self.repostCount, forKey: .repostCount)
            try container.encodeIfPresent(self.likeCount, forKey: .likeCount)
            try container.encodeIfPresent(self.quoteCount, forKey: .quoteCount)
            try container.encodeDateIfPresent(self.indexedAt, forKey: .indexedAt)
            try container.encodeIfPresent(self.viewer, forKey: .viewer)
            try container.encodeIfPresent(self.labels, forKey: .labels)
            try container.encodeIfPresent(self.threadgate, forKey: .threadgate)
        }

        enum CodingKeys: CodingKey {
            case uri
            case cid
            case author
            case record
            case embed
            case replyCount
            case repostCount
            case likeCount
            case quoteCount
            case indexedAt
            case viewer
            case labels
            case threadgate
        }
    }

    /// A definition model for a viewer state.
    ///
    /// - Note: According to the AT Protocol specifications: "Metadata about the requesting
    /// account's relationship with the subject content. Only has meaningful content for
    /// authed requests."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/defs.json
    public struct ViewerStateDefinition: Sendable, Codable, Equatable, Hashable {

        /// The URI of the requesting account's repost of the subject account's post. Optional.
        public let repostURI: String?

        /// The URI of the requesting account's like of the subject account's post. Optional.
        public let likeURI: String?

        /// Indicates whether the thread has been muted.
        public let isThreadMuted: Bool

        /// Indicates whether the requesting account can reply to the account's post. Optional.
        public let areRepliesDisabled: Bool?

        /// Indicates whether the post can be embedded. Optional.
        public let isEmbeddingDisabled: Bool?

        /// Indicates whether the post record is pinned. Optional.
        public let isPinned: Bool?

        enum CodingKeys: String, CodingKey {
            case repostURI = "repost"
            case likeURI = "like"
            case isThreadMuted = "threadMuted"
            case areRepliesDisabled = "replyDisabled"
            case isEmbeddingDisabled = "embeddingDisabled"
            case isPinned = "pinned"
        }
    }

    /// A definition model for a feed's view.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/defs.json
    public struct FeedViewPostDefinition: Sendable, Codable, Equatable, Hashable {

        /// The post contained in a feed.
        public let post: PostViewDefinition

        /// The reply reference for the post, if it's a reply. Optional.
        public var reply: ReplyReferenceDefinition?

        /// Determines whether the repost is a normal repost or pinned. Optional.
        public var reason: ATUnion.ReasonRepostUnion?

        /// The feed generator's context. Optional
        ///
        /// - Important: Current maximum length is 2,000 characters (these are raw characters).
        ///
        /// - Note: According to the AT Protocol specifications: "Context provided by
        /// feed generator that may be passed back alongside interactions."
        public let feedContext: String?

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.post, forKey: .post)
            try container.encodeIfPresent(self.reply, forKey: .reply)
            try container.encodeIfPresent(self.reason, forKey: .reason)
            try truncatedEncodeIfPresent(self.feedContext, withContainer: &container, forKey: .feedContext, upToCharacterLength: 300)
        }

        public enum CodingKeys: CodingKey {
            case post
            case reply
            case reason
            case feedContext
        }
    }

    /// A definition model for a reply reference.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/defs.json
    public struct ReplyReferenceDefinition: Sendable, Codable, Equatable, Hashable {

        /// The original post of the thread.
        public let root: ATUnion.ReplyReferenceRootUnion

        /// The direct post that the user's post is replying to.
        ///
        /// If `parent` and `root` are identical, the post is a direct reply to the
        /// original post of the thread.
        public let parent: ATUnion.ReplyReferenceParentUnion

        /// The author of the parent's post. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "When parent is a reply to another
        /// post, this is the author of that post."
        public let grandparentAuthor: AppBskyLexicon.Actor.ProfileViewBasicDefinition?
    }

    /// A definition model for a very stripped down version of a repost.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/defs.json
    public struct ReasonRepostDefinition: Sendable, Codable, Equatable, Hashable {

        /// The basic details of the user who reposted the post.
        public let by: AppBskyLexicon.Actor.ProfileViewBasicDefinition

        /// The date and time the repost was last indexed.
        public let indexedAt: Date

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.by = try container.decode(AppBskyLexicon.Actor.ProfileViewBasicDefinition.self, forKey: .by)
            self.indexedAt = try container.decodeDate(forKey: .indexedAt)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.by, forKey: .by)
            try container.encodeDate(self.indexedAt, forKey: .indexedAt)
        }

        enum CodingKeys: CodingKey {
            case by
            case indexedAt
        }
    }

    /// A definition model for a marker for pinned posts.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/defs.json
    public struct ReasonPinDefinition: Sendable, Codable, Equatable, Hashable {}

    /// A definition model for a hydrated version of a repost.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/defs.json
    public struct ThreadViewPostDefinition: Sendable, Codable {

        /// The post contained in a thread.
        public let post: PostViewDefinition

        /// The direct post that the user's post is replying to. Optional.
        public let parent: ATUnion.ThreadViewPostParentUnion?

        /// An array of posts of various types. Optional.
        public var replies: [ATUnion.ThreadViewPostRepliesUnion]?
    }

    /// A definition model for a post that may not have been found.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/defs.json
    public struct NotFoundPostDefinition: Sendable, Codable, Equatable, Hashable {

        /// The URI of the post.
        public let feedURI: String

        /// Indicates whether the post wasn't found. Defaults to `true`.
        public let isNotFound: Bool = true

        enum CodingKeys: String, CodingKey {
            case feedURI = "uri"
            case isNotFound = "notFound"
        }
    }

    /// A definition model for a post that may have been blocked.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/defs.json
    public struct BlockedPostDefinition: Sendable, Codable, Equatable, Hashable {

        /// The URI of the post.
        public let feedURI: String

        /// Indicates whether this post has been blocked from the user. Defaults to `true`.
        public let isBlocked: Bool

        /// The author of the post.
        public let author: BlockedAuthorDefinition

        public init(feedURI: String, isBlocked: Bool, author: BlockedAuthorDefinition) {
            self.feedURI = feedURI
            self.isBlocked = isBlocked
            self.author = author
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.feedURI = try container.decode(String.self, forKey: .feedURI)
            self.isBlocked = (try? container.decode(Bool.self, forKey: .isBlocked)) ?? true
            self.author = try container.decode(BlockedAuthorDefinition.self, forKey: .author)
        }

        enum CodingKeys: String, CodingKey {
            case feedURI = "uri"
            case isBlocked = "blocked"
            case author
        }
    }

    /// A definition model for a blocked author.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/defs.json
    public struct BlockedAuthorDefinition: Sendable, Codable, Equatable, Hashable {

        /// The decentralized identifier (DID)  of the author.
        public let did: String

        /// The viewer state of the user. Optional.
        public var viewer: AppBskyLexicon.Actor.ViewerStateDefinition?

        enum CodingKeys: CodingKey {
            case did
            case viewer
        }
    }

    /// A definition model for a feed geneator.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/defs.json
    public struct GeneratorViewDefinition: Sendable, Codable, Equatable, Hashable {

        /// The URI of the feed generator.
        public let feedURI: String

        /// The CID hash of the feed generator.
        public let cid: String

        /// The decentralized identifier (DID) of the feed generator.
        public let feedDID: String

        /// The author of the feed generator.
        public let creator: AppBskyLexicon.Actor.ProfileViewDefinition

        /// The display name of the feed generator.
        public let displayName: String

        /// The description of the feed generator. Optional.
        ///
        /// - Important: Current maximum length is 300 characters.
        public var description: String?

        /// An array of the facets within the feed generator's description.
        public let descriptionFacets: [AppBskyLexicon.RichText.Facet]?

        /// The avatar image URL of the feed generator.
        public var avatarImageURL: URL?

        /// The number of likes for the feed generator.
        public var likeCount: Int?

        /// Indicates whether the feed generator can accept interactions.
        ///
        /// - Note: According to the AT Protocol specifications: "Context that will be passed
        /// through to client and may be passed to feed generator back alongside interactions."
        public let canAcceptInteractions: Bool?

        /// An array of labels. Optional.
        public let labels: [ComAtprotoLexicon.Label.LabelDefinition]?

        /// The viewer's state for the feed generator.
        public var viewer: GeneratorViewerStateDefinition?

        /// The last time the feed generator was indexed.
        public var indexedAt: Date

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.feedURI = try container.decode(String.self, forKey: .feedURI)
            self.cid = try container.decode(String.self, forKey: .cid)
            self.feedDID = try container.decode(String.self, forKey: .feedDID)
            self.creator = try container.decode(AppBskyLexicon.Actor.ProfileViewDefinition.self, forKey: .creator)
            self.displayName = try container.decode(String.self, forKey: .displayName)
            self.description = try container.decodeIfPresent(String.self, forKey: .description)
            self.descriptionFacets = try container.decodeIfPresent([AppBskyLexicon.RichText.Facet].self, forKey: .descriptionFacets)
            self.avatarImageURL = try container.decodeIfPresent(URL.self, forKey: .avatarImageURL)
            self.likeCount = try container.decodeIfPresent(Int.self, forKey: .likeCount)
            self.canAcceptInteractions = try container.decodeIfPresent(Bool.self, forKey: .canAcceptInteractions)
            self.labels = try container.decodeIfPresent([ComAtprotoLexicon.Label.LabelDefinition].self, forKey: .labels)
            self.viewer = try container.decodeIfPresent(AppBskyLexicon.Feed.GeneratorViewerStateDefinition.self, forKey: .viewer)
            self.indexedAt = try container.decodeDate(forKey: .indexedAt)
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.feedURI, forKey: .feedURI)
            try container.encode(self.cid, forKey: .cid)
            try container.encode(self.feedDID, forKey: .feedDID)
            try container.encode(self.creator, forKey: .creator)
            try container.encode(self.displayName, forKey: .displayName)
            try truncatedEncodeIfPresent(self.description, withContainer: &container, forKey: .description, upToCharacterLength: 300)
            try container.encodeIfPresent(self.descriptionFacets, forKey: .descriptionFacets)
            try container.encodeIfPresent(self.avatarImageURL, forKey: .avatarImageURL)

            // Assuming `likeCount` is not nil, only encode it if it's 0 or higher
            if let likeCount = self.likeCount, likeCount >= 0 {
                try container.encode(likeCount, forKey: .likeCount)
            }
            try container.encodeIfPresent(self.canAcceptInteractions, forKey: .canAcceptInteractions)
            try container.encodeIfPresent(self.labels, forKey: .labels)
            try container.encodeIfPresent(self.viewer, forKey: .viewer)
            try container.encodeDateIfPresent(self.indexedAt, forKey: .indexedAt)
        }

        enum CodingKeys: String, CodingKey {
            case feedURI = "uri"
            case cid
            case feedDID = "did"
            case creator
            case displayName
            case description
            case descriptionFacets = "descriptionFacets"
            case avatarImageURL = "avatar"
            case likeCount
            case canAcceptInteractions = "acceptsInteractions"
            case labels
            case viewer
            case indexedAt
        }
    }

    /// A definition model for the viewer's state of the feed generator.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/defs.json
    public struct GeneratorViewerStateDefinition: Sendable, Codable, Equatable, Hashable {

        /// The URI of the viewer's like, if they liked the feed generator. Optional.
        public var likeURI: String?

        enum CodingKeys: String, CodingKey {
            case likeURI = "like"
        }
    }

    /// A definition model for a feed's skeleton.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/defs.json
    public struct SkeletonFeedPostDefinition: Sendable, Codable {

        /// The URI of the post in the feed generator.
        ///
        /// - Note: This refers to the original post's URI. If the post is a repost, then `reason`
        /// will contain a value.
        public let postURI: String

        /// The indication that the post was a repost. Optional.
        public var reason: ATUnion.SkeletonReasonRepostUnion?

        /// The feed generator's context. Optional
        ///
        /// - Important: Current maximum length is 2,000 characters (these are raw characters).
        ///
        /// - Note: According to the AT Protocol specifications: "Context provided by
        /// feed generator that may be passed back alongside interactions."
        public let feedContext: String?

        enum CodingKeys: String, CodingKey {
            case postURI = "post"
            case reason
            case feedContext
        }
    }

    /// A definition model for a repost in a feed generator.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/defs.json
    public struct SkeletonReasonRepostDefinition: Sendable, Codable {

        /// The URI of the repost.
        ///
        /// This property uniquely identifies the repost itself, separate from the original post's URI.
        public let uri: String

        enum CodingKeys: String, CodingKey {
            case uri = "repost"
        }
    }

    /// A definition model for a pin in a feed generator.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/defs.json
    public struct SkeletonReasonPinDefinition: Sendable, Codable {}

    /// A definition model for a feed threadgate view.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/defs.json
    public struct ThreadgateViewDefinition: Sendable, Codable, Equatable, Hashable {

        /// The URI of the feed's threadgate.
        public let threadgateURI: String

        /// The CID hash of the feed's threadgate.
        public let cid: String

        /// The record of the feed's threadgate
        public let record: UnknownType

        // TODO: Make sure this is correct.
        /// An array of user lists.
        public let lists: [AppBskyLexicon.Graph.ListViewBasicDefinition]

        enum CodingKeys: String, CodingKey {
            case threadgateURI = "uri"
            case cid
            case record = "record"
            case lists = "lists"
        }
    }

    /// A definition model for an interaction for an item in a feed generator.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/defs.json
    public struct InteractionDefinition: Sendable, Codable {

        /// The URI of the item itself. Optional.
        public let itemURI: String?

        /// The interaction event of the feed generator. Optional.
        public let event: Event?

        /// The feed generator's context. Optional.
        ///
        /// - Important: Current maximum length is 2,000 characters (these are raw characters).
        ///
        /// - Note: According to the AT Protocol specifications: "Context on a feed item that was
        /// originally supplied by the feed generator on getFeedSkeleton."
        public let feedContext: String?

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.itemURI, forKey: .itemURI)
            try container.encode(self.event, forKey: .event)
            try truncatedEncodeIfPresent(self.feedContext, withContainer: &container, forKey: .feedContext, upToCharacterLength: 300)
        }

        enum CodingKeys: String, CodingKey {
            case itemURI = "uri"
            case event
            case feedContext
        }

        // Enums
        /// A definition model for an interaction event.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.feed.defs`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/defs.json
        public enum Event: Sendable, Codable {

            /// Indicates the feed generator should request less content similar to the feed's item.
            ///
            /// - Note: According to the AT Protocol specifications: "Request that less content like the
            /// given feed item be shown in the feed."
            case requestLess

            /// Indicates the feed generator should request more content similar to the feed's item.
            ///
            /// - Note: According to the AT Protocol specifications: "Request that more content like the
            /// given feed item be shown in the feed."
            case requestMore

            /// Indicates the feed generator clicked on the feed's item.
            ///
            /// - Note: According to the AT Protocol specifications: "User clicked through to the
            /// feed item."
            case clickthroughItem

            /// Indicates the user clicked on the author of the feed's item.
            ///
            /// - Note: According to the AT Protocol specifications: "User clicked through to the author
            /// of the feed item."
            case clickthroughAuthor

            /// Indicates the user clicked on the reposter of the feed's item.
            ///
            /// - Note: According to the AT Protocol specifications: "User clicked through to the reposter
            /// of the feed item."
            case clickthroughReposter

            /// Indicates the user clicked on the embedded content of the feed's item.
            ///
            /// - Note: According to the AT Protocol specifications: "User clicked through to the embedded
            /// content of the feed item."
            case clickthroughEmbed

            /// Indicates the user has viewed the item in the feed.
            ///
            /// - Note: According to the AT Protocol specifications: "Feed item was seen by user."
            case interactionSeen

            /// Indicates the user has liked the item of the feed.
            ///
            /// - Note: According to the AT Protocol specifications: "User liked the feed item."
            case interactionLike

            /// Indicates the user has reposted the item of the feed.
            ///
            /// - Note: According to the AT Protocol specifications: "User reposted the feed item."
            case interactionRepost

            /// Indicates the user has replied to the item of the feed.
            ///
            /// - Note: According to the AT Protocol specifications: "User replied to the feed item."
            case interactionReply

            /// Indicates the user has quote posted the feed's item.
            ///
            /// - Note: According to the AT Protocol specifications: "User quoted the feed item."
            case interactionQuote

            /// Indicates the user has shared the feed's item.
            ///
            /// - Note: According to the AT Protocol specifications: "User shared the feed item."
            case interactionShare
        }
    }
}
