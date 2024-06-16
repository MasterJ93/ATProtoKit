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
    public struct PostViewDefinition: Codable {

        /// The URI of the post.
        public let postURI: String

        /// The CID of the post.
        public let cidHash: String

        /// The author of the post. This will give the basic details of the post author.
        public let author: AppBskyLexicon.Actor.ProfileViewBasicDefinition

        /// The record data itself.
        public let record: UnknownType

        /// An embed view of a specific type. Optional.
        public var embed: ATUnion.EmbedViewUnion?

        /// The number of replies in the post. Optional.
        public var replyCount: Int?

        /// The number of reposts in the post. Optional.
        public var repostCount: Int?

        /// The number of likes in the post. Optional.
        public var likeCount: Int?

        /// The last time the post has been indexed.
        @DateFormatting public var indexedAt: Date

        /// The viewer's interaction with the post. Optional.
        public var viewer: ViewerStateDefinition?

        /// An array of labels attached to the post. Optional.
        public var labels: [ComAtprotoLexicon.Label.LabelDefinition]?

        /// The ruleset of who can reply to the post. Optional.
        public var threadgate: ThreadgateViewDefinition?

        public init(postURI: String, cidHash: String, author: AppBskyLexicon.Actor.ProfileViewBasicDefinition, record: UnknownType,
                    embed: ATUnion.EmbedViewUnion?, replyCount: Int?, repostCount: Int?, likeCount: Int?, indexedAt: Date, viewer: ViewerStateDefinition?,
                    labels: [ComAtprotoLexicon.Label.LabelDefinition]?, threadgate: ThreadgateViewDefinition?) {
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
            self.author = try container.decode(AppBskyLexicon.Actor.ProfileViewBasicDefinition.self, forKey: .author)
            self.record = try container.decode(UnknownType.self, forKey: .record)
            self.embed = try container.decodeIfPresent(ATUnion.EmbedViewUnion.self, forKey: .embed)
            self.replyCount = try container.decodeIfPresent(Int.self, forKey: .replyCount)
            self.repostCount = try container.decodeIfPresent(Int.self, forKey: .repostCount)
            self.likeCount = try container.decodeIfPresent(Int.self, forKey: .likeCount)
            self.indexedAt = try container.decode(DateFormatting.self, forKey: .indexedAt).wrappedValue
            self.viewer = try container.decodeIfPresent(ViewerStateDefinition.self, forKey: .viewer)
            self.labels = try container.decodeIfPresent([ComAtprotoLexicon.Label.LabelDefinition].self, forKey: .labels)
            self.threadgate = try container.decodeIfPresent(ThreadgateViewDefinition.self, forKey: .threadgate)
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

    /// A definition model for a viewer state.
    ///
    /// - Note: According to the AT Protocol specifications: "Metadata about the requesting
    /// account's relationship with the subject content. Only has meaningful content for
    /// authed requests."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/defs.json
    public struct ViewerStateDefinition: Codable {

        /// The URI of the requesting account's repost of the subject account's post. Optional.
        public let repostURI: String?

        /// The URI of the requesting account's like of the subject account's post. Optional.
        public let likeURI: String?

        /// Indicates whether the thread has been muted.
        public let isThreadMuted: Bool

        /// Indicates whether the requesting account can reply to the account's post. Optional.
        public let areRepliesDisabled: Bool?

        enum CodingKeys: String, CodingKey {
            case repostURI = "repost"
            case likeURI = "like"
            case isThreadMuted = "threadMuted"
            case areRepliesDisabled = "replyDisabled"
        }
    }

    /// A definition model for a feed's view.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/defs.json
    public struct FeedViewPostDefinition: Codable {

        /// The post contained in a feed.
        public let post: PostViewDefinition

        /// The reply reference for the post, if it's a reply. Optional.
        public var reply: ReplyReferenceDefinition?

        // TODO: Check to see if this is correct.
        /// The user who reposted the post. Optional.
        public var reason: ATUnion.ReasonRepostUnion?

        /// The feed generator's context. Optional
        ///
        /// - Note: According to the AT Protocol specifications: "Context provided by
        /// feed generator that may be passed back alongside interactions."
        public let feedContext: String?

        public init(post: PostViewDefinition, reply: ReplyReferenceDefinition?, reason: ATUnion.ReasonRepostUnion?, feedContext: String?) {
            self.post = post
            self.reply = reply
            self.reason = reason
            self.feedContext = feedContext
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.post = try container.decode(PostViewDefinition.self, forKey: .post)
            self.reply = try container.decodeIfPresent(ReplyReferenceDefinition.self, forKey: .reply)
            self.reason = try container.decodeIfPresent(ATUnion.ReasonRepostUnion.self, forKey: .reason)
            self.feedContext = try container.decodeIfPresent(String.self, forKey: .feedContext)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.post, forKey: .post)
            try container.encodeIfPresent(self.reply, forKey: .reply)
            try container.encodeIfPresent(self.reason, forKey: .reason)
            // Truncate `description` to 2000 characters before encoding
            // `maxGraphemes`'s limit is 300, but `String.count` should respect that limit
            try truncatedEncodeIfPresent(self.feedContext, withContainer: &container, forKey: .feedContext, upToLength: 2000)
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
    public struct ReplyReferenceDefinition: Codable {

        /// The original post of the thread.
        public let root: ATUnion.ReplyReferenceRootUnion

        // TODO: Fix up the note's message.
        /// The direct post that the user's post is replying to.
        ///
        /// - Note: If `parent` and `root` are identical, the post is a direct reply to the
        /// original post of the thread.
        public let parent: ATUnion.ReplyReferenceParentUnion

        /// The author of the parent's post.
        ///
        /// - Note: According to the AT Protocol specifications: "When parent is a reply to another
        /// post, this is the author of that post."
        public let grandparentAuthor: AppBskyLexicon.Actor.ProfileViewBasicDefinition
    }

    /// A definition model for a very stripped down version of a repost.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/defs.json
    public struct ReasonRepostDefinition: Codable {

        /// The basic details of the user who reposted the post.
        public let by: AppBskyLexicon.Actor.ProfileViewBasicDefinition

        /// The last time the repost was indexed.
        @DateFormatting public var indexedAt: Date

        public init(by: AppBskyLexicon.Actor.ProfileViewBasicDefinition, indexedAt: Date) {
            self.by = by
            self._indexedAt = DateFormatting(wrappedValue: indexedAt)
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.by = try container.decode(AppBskyLexicon.Actor.ProfileViewBasicDefinition.self, forKey: .by)
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

    /// A definition model for a hydrated version of a repost.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/defs.json
    public struct ThreadViewPostDefinition: Codable {

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
    public struct NotFoundPostDefinition: Codable {

        /// The URI of the post.
        public let feedURI: String

        /// Indicates whether the post wasn't found. Defaults to `true`.
        public private(set) var isNotFound: Bool

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

    /// A definition model for a post that may have been blocked.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/defs.json
    public struct BlockedPostDefinition: Codable {

        /// The URI of the post.
        public let feedURI: String

        /// Indicates whether this post has been blocked from the user. Defaults to `true`.
        public private(set) var isBlocked: Bool = true

        /// The author of the post.
        public let author: BlockedAuthorDefinition

        public init(feedURI: String, isBlocked: Bool = true, author: BlockedAuthorDefinition) {
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
    public struct BlockedAuthorDefinition: Codable {

        /// The URI of the author.
        public let authorDID: String

        /// The viewer state of the user. Optional.
        public var viewer: AppBskyLexicon.Actor.ViewerStateDefinition?

        enum CodingKeys: String, CodingKey {
            case authorDID = "did"
            case viewer
        }
    }

    /// A definition model for a feed geneator.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/defs.json
    public struct GeneratorViewDefinition: Codable {

        /// The URI of the feed generator.
        public let feedURI: String

        /// The CID of the feed generator.
        public let cidHash: String

        /// The decentralized identifier (DID) of the feed generator.
        public let feedDID: String

        /// The author of the feed generator.
        public let creator: AppBskyLexicon.Actor.ProfileViewDefinition

        /// The display name of the feed generator.
        public let displayName: String

        /// The description of the feed generator. Optional.
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
        @DateFormatting public var indexedAt: Date

        public init(feedURI: String, cidHash: String, feedDID: String, creator: AppBskyLexicon.Actor.ProfileViewDefinition, displayName: String,
                    description: String?, descriptionFacets: [AppBskyLexicon.RichText.Facet]?, avatarImageURL: URL?, likeCount: Int?,
                    canAcceptInteractions: Bool?, labels: [ComAtprotoLexicon.Label.LabelDefinition]?,
                    viewer: GeneratorViewerStateDefinition?, indexedAt: Date) {
            self.feedURI = feedURI
            self.cidHash = cidHash
            self.feedDID = feedDID
            self.creator = creator
            self.displayName = displayName
            self.description = description
            self.descriptionFacets = descriptionFacets
            self.avatarImageURL = avatarImageURL
            self.likeCount = likeCount
            self.canAcceptInteractions = canAcceptInteractions
            self.labels = labels
            self.viewer = viewer
            self._indexedAt = DateFormatting(wrappedValue: indexedAt)
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.feedURI = try container.decode(String.self, forKey: .feedURI)
            self.cidHash = try container.decode(String.self, forKey: .cidHash)
            self.feedDID = try container.decode(String.self, forKey: .feedDID)
            self.creator = try container.decode(AppBskyLexicon.Actor.ProfileViewDefinition.self, forKey: .creator)
            self.displayName = try container.decode(String.self, forKey: .displayName)
            self.description = try container.decodeIfPresent(String.self, forKey: .description)
            self.descriptionFacets = try container.decodeIfPresent([AppBskyLexicon.RichText.Facet].self, forKey: .descriptionFacets)
            self.avatarImageURL = try container.decodeIfPresent(URL.self, forKey: .avatarImageURL)
            self.likeCount = try container.decodeIfPresent(Int.self, forKey: .likeCount)
            self.canAcceptInteractions = try container.decodeIfPresent(Bool.self, forKey: .canAcceptInteractions)
            self.labels = try container.decodeIfPresent([ComAtprotoLexicon.Label.LabelDefinition].self, forKey: .labels)
            self.viewer = try container.decodeIfPresent(GeneratorViewerStateDefinition.self, forKey: .viewer)
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
            try truncatedEncodeIfPresent(self.description, withContainer: &container, forKey: .description, upToLength: 3000)

            try container.encodeIfPresent(self.descriptionFacets, forKey: .descriptionFacets)
            try container.encodeIfPresent(self.avatarImageURL, forKey: .avatarImageURL)

            // Assuming `likeCount` is not nil, only encode it if it's 0 or higher
            if let likeCount = self.likeCount, likeCount >= 0 {
                try container.encode(likeCount, forKey: .likeCount)
            }
            try container.encodeIfPresent(self.canAcceptInteractions, forKey: .canAcceptInteractions)
            try container.encodeIfPresent(self.labels, forKey: .labels)
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
    public struct GeneratorViewerStateDefinition: Codable {

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
    public struct SkeletonFeedPostDefinition: Codable {

        /// The URI of the post in the feed generator.
        ///
        /// - Note: This refers to the original post's URI. If the post is a repost, then `reason`
        /// will contain a value.
        public let postURI: String

        /// The indication that the post was a repost. Optional.
        public var reason: ATUnion.SkeletonReasonRepostUnion?

        enum CodingKeys: String, CodingKey {
            case postURI = "post"
            case reason
        }
    }

    /// A definition model for a repost in a feed generator.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/defs.json
    public struct SkeletonReasonRepostDefinition: Codable {

        /// The URI of the repost.
        ///
        /// This property uniquely identifies the repost itself, separate from the original post's URI.
        public let repostURI: String

        enum CodingKeys: String, CodingKey {
            case repostURI = "repost"
        }
    }

    /// A definition model for  a feed threadgate view.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/defs.json
    public struct ThreadgateViewDefinition: Codable {

        /// The URI of the feed's threadgate.
        public let threadgateURI: String

        /// The CID of the feed's threadgate.
        public let cidHash: String

        /// The record of the feed's threadgate
        public let record: UnknownType

        // TODO: Make sure this is correct.
        /// An array of user lists.
        public let lists: [AppBskyLexicon.Graph.ListViewBasicDefinition]

        enum CodingKeys: String, CodingKey {
            case threadgateURI = "uri"
            case cidHash = "cid"
            case record = "record"
            case lists = "lists"
        }
    }

    /// A definition model for an interaction for an item in a feed generator.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/defs.json
    public struct InteractionDefinition: Codable {

        /// The item itself. Optional.
        public let item: String?

        /// The interaction event of the feed generator. Optional.
        public let event: Event?

        /// The feed generator's context. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Context on a feed item that was
        /// orginally supplied by the feed generator on getFeedSkeleton."
        public let feedContext: String?

        public init(item: String, event: Event, feedContext: String) {
            self.item = item
            self.event = event
            self.feedContext = feedContext
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.item = try container.decode(String.self, forKey: .item)
            self.event = try container.decode(Event.self, forKey: .event)
            self.feedContext = try container.decode(String.self, forKey: .feedContext)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.item, forKey: .item)
            try container.encode(self.event, forKey: .event)
            // Truncate `description` to 2000 characters before encoding
            // `maxGraphemes`'s limit is 300, but `String.count` should respect that limit
            try truncatedEncodeIfPresent(self.feedContext, withContainer: &container, forKey: .feedContext, upToLength: 2000)
        }

        enum CodingKeys: CodingKey {
            case item
            case event
            case feedContext
        }

        // Enums
        /// A definition model for an interaction event.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.feed.defs`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/defs.json
        public enum Event: Codable {

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
