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
    public let actorDID: String
    /// The unique handle of the user.
    public let actorHandle: String
    /// The display name of the user. Optional.
    ///
    /// - Important: Current maximum length is 64 characters.
    public var displayName: String? = nil
    /// The avatar image URL of the user's profile. Optional.
    public var avatarImageURL: URL? = nil
    /// The associated profile view. Optional.
    public var associated: ActorProfileAssociated?
    /// The list of metadata relating to the requesting account's relationship with the subject
    /// account. Optional.
    public var viewer: ActorViewerState? = nil
    /// An array of labels created by the user. Optional.
    public var labels: [Label]? = nil

    public init(actorDID: String, actorHandle: String, displayName: String?, avatarImageURL: URL?, associated: ActorProfileAssociated?,
                viewer: ActorViewerState?, labels: [Label]?) {
        self.actorDID = actorDID
        self.actorHandle = actorHandle
        self.displayName = displayName
        self.avatarImageURL = avatarImageURL
        self.associated = associated
        self.viewer = viewer
        self.labels = labels
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.actorDID = try container.decode(String.self, forKey: .actorDID)
        self.actorHandle = try container.decode(String.self, forKey: .actorHandle)
        self.displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
        self.avatarImageURL = try container.decodeIfPresent(URL.self, forKey: .avatarImageURL)
        self.associated = try container.decodeIfPresent(ActorProfileAssociated.self, forKey: .associated)
        self.viewer = try container.decodeIfPresent(ActorViewerState.self, forKey: .viewer)
        self.labels = try container.decodeIfPresent([Label].self, forKey: .labels)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.actorDID, forKey: .actorDID)
        try container.encode(self.actorHandle, forKey: .actorHandle)

        // Truncate `displayName` to 640 characters before encoding
        // `maxGraphemes`'s limit is 64, but `String.count` should respect that limit implictly
        try truncatedEncodeIfPresent(self.displayName, withContainer: &container, forKey: .displayName, upToLength: 640)
        try container.encodeIfPresent(self.avatarImageURL, forKey: .avatarImageURL)
        try container.encodeIfPresent(self.associated, forKey: .associated)
        try container.encodeIfPresent(self.viewer, forKey: .viewer)
        try container.encodeIfPresent(self.labels, forKey: .labels)
    }

    enum CodingKeys: String, CodingKey {
        case actorDID = "did"
        case actorHandle = "handle"
        case displayName
        case avatarImageURL = "avatar"
        case associated
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
    public let actorDID: String
    /// The unique handle of the user.
    public let actorHandle: String
    /// The display name of the user's profile. Optional.
    ///
    /// - Important: Current maximum length is 64 characters.
    public var displayName: String? = nil
    /// The description of the user's profile. Optional.
    ///
    /// - Important: Current maximum length is 256 characters.
    public var description: String? = nil
    /// The avatar image URL of a user's profile. Optional.
    public let avatarImageURL: URL?
    /// The associated profile view. Optional.
    public var associated: ActorProfileAssociated?
    /// The date the profile was last indexed. Optional.
    @DateFormattingOptional public var indexedAt: Date? = nil
    /// The list of metadata relating to the requesting account's relationship with the subject
    /// account. Optional.
    public var viewer: ActorViewerState? = nil
    /// An array of labels created by the user. Optional.
    public var labels: [Label]? = nil

    public init(actorDID: String, actorHandle: String, displayName: String?, description: String?, avatarImageURL: URL?, associated: ActorProfileAssociated?,
                indexedAt: Date?, viewer: ActorViewerState?, labels: [Label]?) {
        self.actorDID = actorDID
        self.actorHandle = actorHandle
        self.displayName = displayName
        self.description = description
        self.avatarImageURL = avatarImageURL
        self.associated = associated
        self._indexedAt = DateFormattingOptional(wrappedValue: indexedAt)
        self.viewer = viewer
        self.labels = labels
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.actorDID = try container.decode(String.self, forKey: .actorDID)
        self.actorHandle = try container.decode(String.self, forKey: .actorHandle)
        self.displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.avatarImageURL = try container.decodeIfPresent(URL.self, forKey: .avatarImageURL)
        self.associated = try container.decodeIfPresent(ActorProfileAssociated.self, forKey: .associated)
        self.indexedAt = try container.decodeIfPresent(DateFormattingOptional.self, forKey: .indexedAt)?.wrappedValue
        self.viewer = try container.decodeIfPresent(ActorViewerState.self, forKey: .viewer)
        self.labels = try container.decodeIfPresent([Label].self, forKey: .labels)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.actorDID, forKey: .actorDID)
        try container.encode(self.actorHandle, forKey: .actorHandle)

        // Truncate `displayName` to 640 characters before encoding
        // `maxGraphemes`'s limit is 64, but `String.count` should respect that limit implictly
        try truncatedEncodeIfPresent(self.displayName, withContainer: &container, forKey: .displayName, upToLength: 640)

        // Truncate `description` to 2560 characters before encoding
        // `maxGraphemes`'s limit is 256, but `String.count` should respect that limit
        try truncatedEncodeIfPresent(self.description, withContainer: &container, forKey: .description, upToLength: 2560)
        try container.encodeIfPresent(self.avatarImageURL, forKey: .avatarImageURL)
        try container.encodeIfPresent(self.associated, forKey: .associated)
        try container.encodeIfPresent(self._indexedAt, forKey: .indexedAt)
        try container.encodeIfPresent(self.viewer, forKey: .viewer)
        try container.encodeIfPresent(self.labels, forKey: .labels)
    }

    enum CodingKeys: String, CodingKey {
        case actorDID = "did"
        case actorHandle = "handle"
        case displayName
        case description
        case avatarImageURL = "avatar"
        case associated
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
    public let actorDID: String
    /// The unique handle of the user.
    public let actorHandle: String
    /// The display name of the user's profile. Optional.
    ///
    /// - Important: Current maximum length is 64 characters.
    public var displayName: String? = nil
    /// The description of the user's profile. Optional.
    ///
    /// - Important: Current maximum length is 256 characters.
    public var description: String? = nil
    /// The avatar image URL of a user's profile. Optional.
    public var avatarImageURL: URL? = nil
    /// The banner image URL of a user's profile. Optional.
    public var bannerImageURL: URL? = nil
    /// The number of followers a user has. Optional.
    public var followerCount: Int? = nil
    /// The number of accounts the user follows. Optional.
    public var followCount: Int? = nil
    /// The number of posts the user has. Optional.
    public var postCount: Int? = nil
    /// The associated profile view. Optional.
    public let associated: ActorProfileAssociated?
    /// The date the profile was last indexed. Optional.
    @DateFormattingOptional public var indexedAt: Date? = nil
    /// The list of metadata relating to the requesting account's relationship with the subject
    /// account. Optional.
    public var viewer: ActorViewerState? = nil
    /// An array of labels created by the user. Optional.
    public var labels: [Label]? = nil

    public init(actorDID: String, actorHandle: String, displayName: String?, description: String?, avatarImageURL: URL?, bannerImageURL: URL?,
                followerCount: Int?, followCount: Int?, postCount: Int?, associated: ActorProfileAssociated?, indexedAt: Date?, viewer: ActorViewerState?, labels: [Label]?) {
        self.actorDID = actorDID
        self.actorHandle = actorHandle
        self.displayName = displayName
        self.description = description
        self.avatarImageURL = avatarImageURL
        self.bannerImageURL = bannerImageURL
        self.followerCount = followerCount
        self.followCount = followCount
        self.postCount = postCount
        self.associated = associated
        self._indexedAt = DateFormattingOptional(wrappedValue: indexedAt)
        self.viewer = viewer
        self.labels = labels
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.actorDID = try container.decode(String.self, forKey: .actorDID)
        self.actorHandle = try container.decode(String.self, forKey: .actorHandle)
        self.displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.avatarImageURL = try container.decodeIfPresent(URL.self, forKey: .avatarImageURL)
        self.bannerImageURL = try container.decodeIfPresent(URL.self, forKey: .bannerImageURL)
        self.followerCount = try container.decodeIfPresent(Int.self, forKey: .followerCount)
        self.followCount = try container.decodeIfPresent(Int.self, forKey: .followCount)
        self.postCount = try container.decodeIfPresent(Int.self, forKey: .postCount)
        self.associated = try container.decodeIfPresent(ActorProfileAssociated.self, forKey: .associated)
        self.indexedAt = try container.decodeIfPresent(DateFormattingOptional.self, forKey: .indexedAt)?.wrappedValue
        self.viewer = try container.decodeIfPresent(ActorViewerState.self, forKey: .viewer)
        self.labels = try container.decodeIfPresent([Label].self, forKey: .labels)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.actorDID, forKey: .actorDID)
        try container.encode(self.actorHandle, forKey: .actorHandle)

        // Truncate `displayName` to 640 characters before encoding
        // `maxGraphemes`'s limit is 64, but `String.count` should respect that limit implictly
        try truncatedEncodeIfPresent(self.displayName, withContainer: &container, forKey: .displayName, upToLength: 640)

        // Truncate `description` to 2560 characters before decoding
        // `maxGraphemes`'s limit is 256, but `String.count` should respect that limit
        try truncatedEncodeIfPresent(self.description, withContainer: &container, forKey: .description, upToLength: 2560)
        try container.encodeIfPresent(self.avatarImageURL, forKey: .avatarImageURL)
        try container.encodeIfPresent(self.bannerImageURL, forKey: .bannerImageURL)
        try container.encodeIfPresent(self.followerCount, forKey: .followerCount)
        try container.encodeIfPresent(self.followCount, forKey: .followCount)
        try container.encodeIfPresent(self.postCount, forKey: .postCount)
        try container.encodeIfPresent(self.associated, forKey: .associated)
        try container.encodeIfPresent(self._indexedAt, forKey: .indexedAt)
        try container.encodeIfPresent(self.viewer, forKey: .viewer)
        try container.encodeIfPresent(self.labels, forKey: .labels)
    }

    enum CodingKeys: String, CodingKey {
        case actorDID = "did"
        case actorHandle = "handle"
        case displayName
        case description
        case avatarImageURL = "avatar"
        case bannerImageURL = "banner"
        case followerCount = "followersCount"
        case followCount = "followsCount"
        case postCount = "postsCount"
        case associated
        case indexedAt
        case viewer
        case labels
    }
}

/// A data model definition for an actor's associated profile.
///
/// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/9579bec720d30e40c995d09772040212c261d6fb/lexicons/app/bsky/actor/defs.json
public struct ActorProfileAssociated: Codable {
    /// The number of lists associated with the user. Optional.
    public let lists: Int?
    /// The number of feed generators associated with the user. Optional.
    public let feedGenerators: Int?
    /// Indicates whether the user account is a labeler. Optional.
    public let isActorLabeler: Bool?

    enum CodingKeys: String, CodingKey {
        case lists
        case feedGenerators = "feedgens"
        case isActorLabeler = "labeler"
    }
}

/// A data model for an actor viewer state definition.
///
/// - Note: From the AT Protocol specification: "Metadata about the requesting account's
/// relationship with the subject account. Only has meaningful content for authed requests."
///
/// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/9579bec720d30e40c995d09772040212c261d6fb/lexicons/app/bsky/actor/defs.json
public struct ActorViewerState: Codable {
    /// Indicates whether the requesting account has been muted by the subject account. Optional.
    public let isMuted: Bool? = nil
    // TODO: Figure out what this is about.
    /// An array of lists that the subject account is muted by.
    public let mutedByArray: GraphListViewBasic? = nil
    /// Indicates whether the requesting account has been blocked by the subject account. Optional.
    public let isBlocked: Bool? = nil
    // TODO: Figure out what this is about.
    /// A URI.
    public let blockingURI: String? = nil
    /// An array of the subject account's lists.
    public let blockingByArray: GraphListViewBasic? = nil
    // TODO: Figure out what this is about.
    /// A URI.
    public let followingURI: String? = nil
    // TODO: Figure out what this is about.
    /// A URI.
    public let followedByURI: String? = nil

    enum CodingKeys: String, CodingKey {
        case isMuted = "muted"
        case mutedByArray = "mutedByList"
        case isBlocked = "blockedBy"
        case blockingURI = "blocking"
        case blockingByArray = "blockingByList"
        case followingURI = "following"
        case followedByURI = "followedBy"
    }
}

/// A data model for a preferences definition.
///
/// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/9579bec720d30e40c995d09772040212c261d6fb/lexicons/app/bsky/actor/defs.json
public struct ActorPreferences: Codable {
    /// An array of different preferences the user can set.
    public let preferences: [ActorPreferenceUnion]

    public init(preferences: [ActorPreferenceUnion]) {
        self.preferences = preferences
    }
}

/// A data model for an "Adult Content" preference definition.
///
/// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/9579bec720d30e40c995d09772040212c261d6fb/lexicons/app/bsky/actor/defs.json
public struct AdultContentPreferences: Codable {
    /// The identifier of the lexicon.
    ///
    /// - Warning: The value must not change.
    public let type: String = "app.bsky.actor.defs#adultContentPref"
    /// Indicates whether the user will be able to see adult content in their feed. Set to `false`
    /// by default.
    public var isAdultContentEnabled: Bool = false

    public init(isAdultContentEnabled: Bool) {
        self.isAdultContentEnabled = isAdultContentEnabled
    }

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case isAdultContentEnabled = "enabled"
    }
}

/// A data model for a "Content Label" preference definition.
///
/// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/9579bec720d30e40c995d09772040212c261d6fb/lexicons/app/bsky/actor/defs.json
public struct ContentLabelPreferences: Codable {
    /// The identifier of the lexicon.
    ///
    /// - Warning: The value must not change.
    public let type: String = "app.bsky.actor.defs#contentLabelPref"
    /// The decentralized identifier of the labeler that this preference applies to.
    ///
    /// - Note: If this field is empty, then the preferences apply to all labels.
    ///
    /// - Note: According to the AT Protocol specifications: "Which labeler does this preference
    /// apply to? If undefined, applies globally."
    public let labelerDID: String?
    /// The name of the content label.
    public let label: String
    /// Indicates the visibility of the label's content.
    public let visibility: Visibility

    public init(labelerDID: String?, label: String, visibility: Visibility) {
        self.labelerDID = labelerDID
        self.label = label
        self.visibility = visibility
    }
    /// Determines how visible a label's content is.
    public enum Visibility: String, Codable {
        /// Indicates the content can be ignored.
        case ignore = "ignore"
        /// Indicates the content can be seen without restriction.
        case show = "show"
        /// Indicates the content can be seen, but will ask if the user wants to view it.
        case warn = "warn"
        /// Indicates the content is fully invisible by the user.
        case hide = "hide"
    }

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case labelerDID = "labelerDid"
        case label
        case visibility
    }
}

/// A data model for a "Saved Feeds" preference definition.
///
/// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/9579bec720d30e40c995d09772040212c261d6fb/lexicons/app/bsky/actor/defs.json
public struct SavedFeedsPreferences: Codable {
    /// The identifier of the lexicon.
    ///
    /// - Warning: The value must not change.
    public let type: String = "app.bsky.actor.defs#savedFeedsPref"
    /// An array of feed URIs that have been saved and pinned.
    public let pinned: [String]
    /// An array of feed URIs that have been saved.
    public let saved: [String]
    // TODO: Find out more about what this does.
    /// The index number of the timeline for the list of feeds. Optional.
    public var timelineIndex: Int? = nil

    public init(pinned: [String], saved: [String], timelineIndex: Int?) {
        self.pinned = pinned
        self.saved = saved
        self.timelineIndex = timelineIndex
    }

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case pinned
        case saved
        case timelineIndex
    }
}

/// A data model for a "Personal Details" preference definition.
///
/// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/9579bec720d30e40c995d09772040212c261d6fb/lexicons/app/bsky/actor/defs.json
public struct PersonalDetailsPreferences: Codable {
    /// The identifier of the lexicon.
    ///
    /// - Warning: The value must not change.
    public let type: String = "app.bsky.actor.defs#personalDetailsPref"
    /// The birth date of the user. Optional.
    ///
    /// - Note: From the AT Protocol specification: "The birth date of account owner."
    @DateFormattingOptional public var birthDate: Date? = nil

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

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case birthDate
    }
}

/// A data model for a "Feed View" preference definition.
///
/// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/9579bec720d30e40c995d09772040212c261d6fb/lexicons/app/bsky/actor/defs.json
public struct FeedViewPreferences: Codable {
    /// The identifier of the lexicon.
    ///
    /// - Warning: The value must not change.
    public let type: String = "app.bsky.actor.defs#feedViewPref"
    /// The feed's identifier (typically the URI).
    ///
    /// - Note:From the AT Protocol specification: "The URI of the feed, or an identifier which
    /// describes the feed."
    public let feedURI: String
    /// Indicates whether the replies are hidden from the user. Optional.
    ///
    /// - Note: From the AT Protocol specification: "Hide replies in the feed."
    public let areRepliesHidden: Bool? = nil
    /// Indicates whether replies from users you don't follow are hidden from the user. Optional.
    ///
    /// - Note: From the AT Protocol specification: "Hide replies in the feed if they are not by
    /// followed users."
    public let areUnfollowedRepliesHidden: Bool? = true
    /// Indicates how many likes a post needs in order for the user to see the reply. Optional.
    ///
    /// - Note: From the AT Protocol specification: "Hide replies in the feed if they do not have
    /// this number of likes."
    public let hideRepliesByLikeCount: Int? = nil
    /// Indicates whether reposts are hidden from the user. Optional.
    ///
    /// - Note: From the AT Protocol specification: "Hide reposts in the feed."
    public let areRepostsHidden: Bool? = nil
    /// Indicates whether quote posts are hidden from the user. Optional.
    ///
    /// - Note: From the AT Protocol specification: "Hide quote posts in the feed."
    public let areQuotePostsHidden: Bool? = nil

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case feedURI = "feed"
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
    /// The identifier of the lexicon.
    ///
    /// - Warning: The value must not change.
    public let type: String = "app.bsky.actor.defs#threadViewPref"
    /// The sorting mode of a thread. Optional.
    ///
    /// - Note: From the AT Protocol specification: "Sorting mode for threads."
    public let sortingMode: SortingMode? = nil
    /// Indicates whether users you follow are prioritized over other users. Optional.
    ///
    /// - Note: From the AT Protocol specification: "Show followed users at the top of
    /// all replies."
    public let areFollowedUsersPrioritized: Bool? = nil

    /// The sorting mode for a thread.
    public enum SortingMode: String, Codable {
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
        case type = "$type"
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
    /// The identifier of the lexicon.
    ///
    /// - Warning: The value must not change.
    public let type: String = "app.bsky.actor.defs#interestsPref"
    /// An array of interest tags.
    ///
    /// - Note: According to AT Protocol's specifications: "A list of tags which describe the
    /// account owner's interests gathered during onboarding."
    /// - Important: Current maximum limit is 100 tags. Current maximum length for each tag name
    /// is 64 characters.
    public let tags: [String]

    public init(tags: [String]) {
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

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case tags
    }
}

/// A data model for a definition of the muted word's target.
///
/// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/9579bec720d30e40c995d09772040212c261d6fb/lexicons/app/bsky/actor/defs.json
public enum MutedWordTarget: Codable {
    case content
    case tag
    case other(String)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)

        switch value {
            case "content":
                self = .content
            case "tag":
                self = .tag
                // Handle other known cases
            default:
                self = .other(value)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
            case .content:
                try container.encode("content")
            case .tag:
                try container.encode("tag")
            case .other(let other):
                // Truncate `other` to 640 characters before decoding
                // `maxGraphemes`'s limit is 64, but `String.count` should respect that limit
                let truncatedOther = other.truncated(toLength: 640)
                try container.encode(truncatedOther)
        }
    }
}

/// A data model for a muted word definition.
///
/// - Note: According to the AT Protocol specifications: "A word that the account owner has muted."
///
/// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/9579bec720d30e40c995d09772040212c261d6fb/lexicons/app/bsky/actor/defs.json
public struct MutedWord: Codable {
    public let value: String
    public let targets: [MutedWordTarget]

    public init(value: String, targets: [MutedWordTarget]) {
        self.value = value
        self.targets = targets
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.value = try container.decode(String.self, forKey: .value)
        self.targets = try container.decode([MutedWordTarget].self, forKey: .targets)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        // Truncate `value` to 1000 characters before decoding
        // `maxGraphemes`'s limit is 100, but `String.count` should respect that limit
        try truncatedEncode(self.value, withContainer: &container, forKey: .value, upToLength: 1000)
        try container.encode(self.targets, forKey: .targets)
    }

    enum CodingKeys: CodingKey {
        case value
        case targets
    }
}

/// A data model for a "Muted Words" preference definition.
///
/// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/9579bec720d30e40c995d09772040212c261d6fb/lexicons/app/bsky/actor/defs.json
public struct MutedWordsPreferences: Codable {
    /// The identifier of the lexicon.
    ///
    /// - Warning: The value must not change.
    public let type: String = "app.bsky.actor.defs#mutedWordsPref"
    /// An array of items the user has muted.
    ///
    /// - Note: According to the AT Protocol specifications: "A list of words the account owner
    /// has muted."
    public let mutedItems: [MutedWord]

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case mutedItems = "items"
    }
}

/// A data model for a "Hidden Posts" preference definition.
///
/// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/9579bec720d30e40c995d09772040212c261d6fb/lexicons/app/bsky/actor/defs.json
public struct HiddenPostsPreferences: Codable {
    /// The identifier of the lexicon.
    ///
    /// - Warning: The value must not change.
    public let type: String = "app.bsky.actor.defs#hiddenPostsPref"
    /// An array of URIs related to posts that the user wants to hide.
    ///
    /// - Note: According to the AT Protocol specifications: "A list of URIs of posts the account
    /// owner has hidden."
    public let items: [String]

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case items
    }
}

/// A data model for a "Labelers" preference definition.
///
/// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/9579bec720d30e40c995d09772040212c261d6fb/lexicons/app/bsky/actor/defs.json
public struct LabelersPreferences: Codable {
    /// An array of labeler items.
    public let labelers: [String]
}

/// A data model definition for a labeler item.
///
/// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/9579bec720d30e40c995d09772040212c261d6fb/lexicons/app/bsky/actor/defs.json
public struct LabelersPreferenceItem: Codable {
    /// The decentralized identifier (DID) of the labeler.
    public let atDID: String
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
    /// The "Muted Words" preference.
    case mutedWordsPreferences(MutedWordsPreferences)
    /// The Hidden Posts" preference.
    case hiddenPostsPreferences(HiddenPostsPreferences)

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
        } else if let value = try? container.decode(MutedWordsPreferences.self) {
            self = .mutedWordsPreferences(value)
        } else if let value = try? container.decode(HiddenPostsPreferences.self) {
            self = .hiddenPostsPreferences(value)
        } else {
            throw DecodingError.typeMismatch(
                ActorPreferenceUnion.self, DecodingError.Context(
                    codingPath: decoder.codingPath, debugDescription: "Unknown ActorPreference type"))
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
            case .mutedWordsPreferences(let preference):
                try container.encode(preference)
            case .hiddenPostsPreferences(let preference):
                try container.encode(preference)
        }
    }
}
