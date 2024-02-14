//
//  BskyActorDefs.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-25.
//
import Foundation

/// A data model for a basic profile view definition.
///
/// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/9579bec720d30e40c995d09772040212c261d6fb/lexicons/app/bsky/actor/defs.json
public struct ActorProfileViewBasic: Codable {
    /// The decentralized identifier (DID) of the user.
    public let atDID: String
    /// The unique handle of the user.
    public let actorHandle: String
    /// The display name of the user. Optional.
    ///
    /// - Note: Current maximum length is 64 characters.
    public var displayName: String? = nil
    /// The avatar image of the user's profile. Optional.
    public var avatar: String? = nil
    /// The viewer state of the user. Optional.
    public var viewer: ActorViewerState? = nil
    // TODO:  Figure out what this is about.
    /// An array of self-defined [...]. Optional.
    public var labels: [Label]? = nil

    public init(atDID: String, actorHandle: String, displayName: String?, avatar: String?, viewer: ActorViewerState?, labels: [Label]?) {
        self.atDID = atDID
        self.actorHandle = actorHandle
        self.displayName = displayName
        self.avatar = avatar
        self.viewer = viewer
        self.labels = labels
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.atDID = try container.decode(String.self, forKey: .atDID)
        self.actorHandle = try container.decode(String.self, forKey: .actorHandle)
        self.displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
        self.avatar = try container.decodeIfPresent(String.self, forKey: .avatar)
        self.viewer = try container.decodeIfPresent(ActorViewerState.self, forKey: .viewer)
        self.labels = try container.decodeIfPresent([Label].self, forKey: .labels)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.atDID, forKey: .atDID)
        try container.encode(self.actorHandle, forKey: .actorHandle)

        // Truncate `displayName` to 640 characters before encoding
        // `maxGraphemes`'s limit is 64, but `String.count` should respect that limit implictly
        try truncatedEncodeIfPresent(self.displayName, withContainer: &container, forKey: .displayName, upToLength: 640)
        try container.encodeIfPresent(self.avatar, forKey: .avatar)
        try container.encodeIfPresent(self.viewer, forKey: .viewer)
        try container.encodeIfPresent(self.labels, forKey: .labels)
    }

    enum CodingKeys: String, CodingKey {
        case atDID = "did"
        case actorHandle = "handle"
        case displayName
        case avatar
        case viewer
        case labels
    }
}

/// A data model for a profile view definition.
///
/// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/9579bec720d30e40c995d09772040212c261d6fb/lexicons/app/bsky/actor/defs.json
public struct ActorProfileView: Codable {
    /// The decentralized identifier (DID) of the user.
    public let atDID: String
    /// The unique handle of the user.
    public let actorHandle: String
    /// The display name of the user's profile. Optional.
    ///
    /// - Note: Current maximum length is 64 characters.
    public var displayName: String? = nil
    /// The description of the user's profile. Optional.
    ///
    /// - Note: Current maximum length is 256 characters.
    public var description: String? = nil
    /// The avatar image of a user's profile. Optional.
    public let avatar: String?
    /// The date the profile was last indexed. Optional.
    @DateFormattingOptional public var indexedAt: Date? = nil
    /// <#Description#>
    public var viewer: ActorViewerState? = nil
    /// <#Description#>
    public var labels: [Label]? = nil

    public init(atDID: String, actorHandle: String, displayName: String?, description: String?, avatar: String?, indexedAt: Date?, viewer: ActorViewerState?, labels: [Label]?) {
        self.atDID = atDID
        self.actorHandle = actorHandle
        self.displayName = displayName
        self.description = description
        self.avatar = avatar
        self._indexedAt = DateFormattingOptional(wrappedValue: indexedAt)
        self.viewer = viewer
        self.labels = labels
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.atDID = try container.decode(String.self, forKey: .atDID)
        self.actorHandle = try container.decode(String.self, forKey: .actorHandle)
        self.displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.avatar = try container.decodeIfPresent(String.self, forKey: .avatar)
        self.indexedAt = try container.decodeIfPresent(DateFormattingOptional.self, forKey: .indexedAt)?.wrappedValue
        self.viewer = try container.decodeIfPresent(ActorViewerState.self, forKey: .viewer)
        self.labels = try container.decodeIfPresent([Label].self, forKey: .labels)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.atDID, forKey: .atDID)
        try container.encode(self.actorHandle, forKey: .actorHandle)

        // Truncate `displayName` to 640 characters before encoding
        // `maxGraphemes`'s limit is 64, but `String.count` should respect that limit implictly
        try truncatedEncodeIfPresent(self.displayName, withContainer: &container, forKey: .displayName, upToLength: 640)

        // Truncate `description` to 2560 characters before encoding
        // `maxGraphemes`'s limit is 256, but `String.count` should respect that limit
        try truncatedEncodeIfPresent(self.description, withContainer: &container, forKey: .description, upToLength: 2560)
        try container.encodeIfPresent(self.avatar, forKey: .avatar)
        try container.encodeIfPresent(self._indexedAt, forKey: .indexedAt)
        try container.encodeIfPresent(self.viewer, forKey: .viewer)
        try container.encodeIfPresent(self.labels, forKey: .labels)
    }

    enum CodingKeys: String, CodingKey {
        case atDID = "did"
        case actorHandle = "handle"
        case displayName
        case description
        case avatar
        case indexedAt
        case viewer
        case labels
    }
}

/// A data model for a detailed profile view definition.
///
/// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/9579bec720d30e40c995d09772040212c261d6fb/lexicons/app/bsky/actor/defs.json
public struct ActorProfileViewDetailed: Codable {
    /// The decentralized identifier (DID) of the user.
    public let atDID: String
    /// The unique handle of the user.
    public let actorHandle: String
    /// The display name of the user's profile. Optional.
    ///
    /// - Note: Current maximum length is 64 characters.
    public var displayName: String? = nil
    /// The description of the user's profile. Optional.
    ///
    /// - Note: Current maximum length is 256 characters.
    public var description: String? = nil
    /// The avatar image of a user's profile. Optional.
    public var avatar: String? = nil
    /// The banner image of a user's profile. Optional.
    public var banner: String? = nil
    /// The number of followers a user has. Optional.
    public var followerCount: Int? = nil
    /// The number of accounts the user follows. Optional.
    public var followCount: Int? = nil
    /// The number of posts the user has. Optional.
    public var postCount: Int? = nil
    /// The date the profile was last indexed. Optional.
    @DateFormattingOptional public var indexedAt: Date? = nil
    /// The viewer state of the user. Optional.
    public var viewer: ActorViewerState? = nil
    // TODO:  Figure out what this is about.
    /// An array of self-defined [...]. Optional.
    public var labels: [Label]? = nil

    public init(atDID: String, actorHandle: String, displayName: String?, description: String?, avatar: String?, banner: String?, followerCount: Int?, followCount: Int?, postCount: Int?, indexedAt: Date?, viewer: ActorViewerState?, labels: [Label]?) {
        self.atDID = atDID
        self.actorHandle = actorHandle
        self.displayName = displayName
        self.description = description
        self.avatar = avatar
        self.banner = banner
        self.followerCount = followerCount
        self.followCount = followCount
        self.postCount = postCount
        self._indexedAt = DateFormattingOptional(wrappedValue: indexedAt)
        self.viewer = viewer
        self.labels = labels
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.atDID = try container.decode(String.self, forKey: .atDID)
        self.actorHandle = try container.decode(String.self, forKey: .actorHandle)
        self.displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.avatar = try container.decodeIfPresent(String.self, forKey: .avatar)
        self.banner = try container.decodeIfPresent(String.self, forKey: .banner)
        self.followerCount = try container.decodeIfPresent(Int.self, forKey: .followerCount)
        self.followCount = try container.decodeIfPresent(Int.self, forKey: .followCount)
        self.postCount = try container.decodeIfPresent(Int.self, forKey: .postCount)
        self.indexedAt = try container.decodeIfPresent(DateFormattingOptional.self, forKey: .indexedAt)?.wrappedValue
        self.viewer = try container.decodeIfPresent(ActorViewerState.self, forKey: .viewer)
        self.labels = try container.decodeIfPresent([Label].self, forKey: .labels)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.atDID, forKey: .atDID)
        try container.encode(self.actorHandle, forKey: .actorHandle)

        // Truncate `displayName` to 640 characters before encoding
        // `maxGraphemes`'s limit is 64, but `String.count` should respect that limit implictly
        try truncatedEncodeIfPresent(self.displayName, withContainer: &container, forKey: .displayName, upToLength: 640)

        // Truncate `description` to 2560 characters before decoding
        // `maxGraphemes`'s limit is 256, but `String.count` should respect that limit
        try truncatedEncodeIfPresent(self.description, withContainer: &container, forKey: .description, upToLength: 2560)
        try container.encodeIfPresent(self.avatar, forKey: .avatar)
        try container.encodeIfPresent(self.banner, forKey: .banner)
        try container.encodeIfPresent(self.followerCount, forKey: .followerCount)
        try container.encodeIfPresent(self.followCount, forKey: .followCount)
        try container.encodeIfPresent(self.postCount, forKey: .postCount)
        try container.encodeIfPresent(self._indexedAt, forKey: .indexedAt)
        try container.encodeIfPresent(self.viewer, forKey: .viewer)
        try container.encodeIfPresent(self.labels, forKey: .labels)
    }

    enum CodingKeys: String, CodingKey {
        case atDID = "did"
        case actorHandle = "handle"
        case displayName
        case description
        case avatar
        case banner
        case followerCount = "followersCount"
        case followCount = "followsCount"
        case postCount = "postsCount"
        case indexedAt
        case viewer
        case labels
    }
}

/// A data model for an actor viewer state definition.
///
/// - Note: From the AT Protocol specification: "Metadata about the requesting account's relationship with the subject account.
/// Only has meaningful content for authed requests."
/// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/9579bec720d30e40c995d09772040212c261d6fb/lexicons/app/bsky/actor/defs.json
public struct ActorViewerState: Codable {
    /// Indicates whether the requesting account has been muted by the subject account. Optional.
    public let isMuted: Bool? = nil
    /// An array of
    public let mutedByArray: ListViewBasic? = nil
    /// Indicates whether the requesting account has been blocked by the subject account. Optional.
    public let isBlocked: Bool? = nil
    // TODO: Figure out what this is about.
    /// A URI.
    public let blocking: String? = nil
    /// An array of the subject account's lists.
    public let blockingByArray: ListViewBasic? = nil
    // TODO: Figure out what this is about.
    /// A URI.
    public let following: String? = nil
    // TODO: Figure out what this is about.
    /// A URI.
    public let followedBy: String? = nil

    enum CodingKeys: String, CodingKey {
        case isMuted = "muted"
        case mutedByArray = "mutedByList"
        case isBlocked = "blockedBy"
        case blocking
        case blockingByArray = "blockingByList"
        case following = "following"
        case followedBy = "followedBy"
    }
}

/// A data model for a preferences definition.
///
/// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/9579bec720d30e40c995d09772040212c261d6fb/lexicons/app/bsky/actor/defs.json
public struct ActorPreferences: Codable {
    /// An array of different preferences the user can view and set.
    let preferences: [ActorPreferenceUnion]
}

/// A data model for an "Adult Content" preference definition.
///
/// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/9579bec720d30e40c995d09772040212c261d6fb/lexicons/app/bsky/actor/defs.json
public struct AdultContentPreferences: Codable {
    /// Indicates whether the user will be able to see adult content in their feed. Set to `false` by default.
    var isAdultContentEnabled: Bool = false

    enum CodingKeys: String, CodingKey {
        case isAdultContentEnabled = "enabled"
    }
}

/// A data model for a "Content Label" preference definition.
///
/// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/9579bec720d30e40c995d09772040212c261d6fb/lexicons/app/bsky/actor/defs.json
public struct ContentLabelPreferences: Codable {
    /// The name of the content label.
    let label: String
    /// Indicates the visibility of the label's content.
    let visibility: Visibility

    /// Determines how visible a label's content is.
    enum Visibility: String, Codable {
        /// Indicates the content can be seen without restriction.
        case show = "show"
        /// Indicates the content can be seen, but will ask if the user wants to view it.
        case warn = "warn"
        /// Indicates the content is fully invisible by the user.
        case hide = "hide"
    }
}

/// A data model for a "Saved Feeds" preference definition.
///
/// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/9579bec720d30e40c995d09772040212c261d6fb/lexicons/app/bsky/actor/defs.json
public struct SavedFeedsPreferences: Codable {
    /// An array of feeds that have been saved and pinned.
    let pinned: [String]
    /// An array of feeds that have been saved.
    let saved: [String]
}

/// A data model for a "Personal Details" preference definition.
///
/// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/9579bec720d30e40c995d09772040212c261d6fb/lexicons/app/bsky/actor/defs.json
public struct PersonalDetailsPreferences: Codable {
    /// The birth date of the user. Optional.
    ///
    /// - Note: From the AT Protocol specification: "The birth date of account owner."
    @DateFormattingOptional var birthDate: Date? = nil

    public init(birthDate: Date) {
        self._birthDate = DateFormattingOptional(wrappedValue: birthDate)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.birthDate = try container.decodeIfPresent(DateFormattingOptional.self, forKey: .birthDate)?.wrappedValue
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(self._birthDate, forKey: .birthDate)
    }

    enum CodingKeys: CodingKey {
        case birthDate
    }
}

/// A data model for a "Feed View" preference definition.
///
/// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/9579bec720d30e40c995d09772040212c261d6fb/lexicons/app/bsky/actor/defs.json
public struct FeedViewPreferences: Codable {
    /// The feed's identifier (typically the URI).
    ///
    /// - Note:From the AT Protocol specification: "The URI of the feed, or an identifier which describes the feed."
    let feed: String
    /// Indicates whether the replies are hidden from the user. Optional.
    ///
    /// - Note: From the AT Protocol specification: "Hide replies in the feed."
    let areRepliesHidden: Bool? = nil
    /// Indicates whether replies from users you don't follow are hidden from the user. Optional.
    ///
    /// - Note: From the AT Protocol specification: "Hide replies in the feed if they are not by followed users."
    let areUnfollowedRepliesHidden: Bool? = nil
    /// Indicates how many likes a post needs in order for the user to see the reply. Optional.
    ///
    /// - Note: From the AT Protocol specification: "Hide replies in the feed if they do not have this number of likes."
    let hideRepliesByLikeCount: Int? = nil
    /// Indicates whether reposts are hidden from the user. Optional.
    ///
    /// - Note: From the AT Protocol specification: "Hide reposts in the feed."
    let areRepostsHidden: Bool? = nil
    /// Indicates whether quote posts are hidden from the user. Optional.
    ///
    /// - Note: From the AT Protocol specification: "Hide quote posts in the feed."
    let areQuotePostsHidden: Bool? = nil

    enum CodingKeys: String, CodingKey {
        case feed
        case areRepliesHidden = "hideReplies"
        case areUnfollowedRepliesHidden = "hideRepliesByUnfollowed"
        case hideRepliesByLikeCount
        case areRepostsHidden = "hideReposts"
        case areQuotePostsHidden = "hideQuotePosts"
    }
}

/// A data model for a "Thread View" preference definition.
///
/// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/9579bec720d30e40c995d09772040212c261d6fb/lexicons/app/bsky/actor/defs.json
public struct ThreadViewPreferences: Codable {
    /// The sorting mode of a thread. Optional.
    ///
    /// - Note: From the AT Protocol specification: "Sorting mode for threads."
    let sortingMode: SortingMode? = nil
    /// Indicates whether users you follow are prioritized over other users. Optional.
    ///
    /// - Note: From the AT Protocol specification: "Show followed users at the top of all replies."
    let areFollowedUsersPrioritized: Bool? = nil

    /// The sorting mode for a thread.
    enum SortingMode: String, Codable {
        /// Indicates the thread will be sorted from the oldest post.
        case oldest = "oldest"
        /// Indicates the thread will be sorted from the newest post.
        case newest = "newest"
        /// Indicates the thread will be sorted from the posts with the most number of likes.
        case mostLikes = "most-likes"
        /// Indicates the thread will be completely random.
        case random = "random"
    }

    enum CodingKeys: String, CodingKey {
        case sortingMode = "sort"
        case areFollowedUsersPrioritized = "prioritizeFollowedUsers"
    }
}

/// A data model for an "Interest View" preference definition.
///
/// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/9579bec720d30e40c995d09772040212c261d6fb/lexicons/app/bsky/actor/defs.json
public struct InterestViewPreferences: Codable {
    /// An array of interest tags.
    ///
    /// - Note: According to AT Protocol's specifications: "A list of tags which describe the account owner's interests gathered during onboarding."
    /// - Note: Current maximum limit is 100 tags. Current maximum length for each tag name is 64 characters.
    public let tags: [String]

    init(tags: [String]) {
        self.tags = tags
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.tags = try container.decode([String].self, forKey: .tags)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        // Truncate `tags` to 640 characters before encoding.
        // `maxGraphemes`'s limit is 64, but `String.count` should respect that limit implictly.
        // Then, truncate `tags` to 100 items before encoding.
        let truncatedTags = self.tags.map { $0.truncated(toLength: 640) }
        try truncatedEncode(truncatedTags, withContainer: &container, forKey: .tags, upToLength: 100)
    }

    enum CodingKeys: CodingKey {
        case tags
    }
}

// MARK: - Union types
/// A reference containing the list of preferences.
///
/// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/9579bec720d30e40c995d09772040212c261d6fb/lexicons/app/bsky/actor/defs.json
public enum ActorPreferenceUnion: Codable {
    /// The "Adult Content" preference.
    case adultContent(AdultContentPreferences)
    /// The "Content Label" preference.
    case contentLabel(ContentLabelPreferences)
    /// The "Saved Feeds" preference.
    case savedFeeds(SavedFeedsPreferences)
    /// The "Personal Details" preference.
    case personalDetails(PersonalDetailsPreferences)
    /// The "Feed View" preference.
    case feedView(FeedViewPreferences)
    /// The "Thread View" preference.
    case threadView(ThreadViewPreferences)
    /// The "Interest View" preference.
    case interestViewPreferences(InterestViewPreferences)

    // Implement custom decoding
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let value = try? container.decode(AdultContentPreferences.self) {
            self = .adultContent(value)
        } else if let value = try? container.decode(ContentLabelPreferences.self) {
            self = .contentLabel(value)
        } else if let value = try? container.decode(SavedFeedsPreferences.self) {
            self = .savedFeeds(value)
        } else if let value = try? container.decode(PersonalDetailsPreferences.self) {
            self = .personalDetails(value)
        } else if let value = try? container.decode(FeedViewPreferences.self) {
            self = .feedView(value)
        } else if let value = try? container.decode(ThreadViewPreferences.self) {
            self = .threadView(value)
        } else if let value = try? container.decode(InterestViewPreferences.self) {
            self = .interestViewPreferences(value)
        } else {
            throw DecodingError.typeMismatch(ActorPreferenceUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unknown ActorPreference type"))
        }
    }

    // Implement custom encoding
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
            case .adultContent(let preference):
                try container.encode(preference)
            case .contentLabel(let preference):
                try container.encode(preference)
            case .savedFeeds(let preference):
                try container.encode(preference)
            case .personalDetails(let preference):
                try container.encode(preference)
            case .feedView(let preference):
                try container.encode(preference)
            case .threadView(let preference):
                try container.encode(preference)
            case .interestViewPreferences(let preference):
                try container.encode(preference)
        }
    }
}
