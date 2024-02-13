//
//  BskyActorDefs.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-25.
//
import Foundation

public struct ProfileViewBasic: Codable {
    public let atDID: String
    public let actorHandle: String
    public var displayName: String? = nil
    public var avatar: String? = nil
    public var viewer: ActorViewerState? = nil
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

public struct ProfileView: Codable {
    public let atDID: String
    public let actorHandle: String
    public var displayName: String? = nil
    public var description: String? = nil
    public let avatar: String?
    @DateFormattingOptional public var indexedAt: Date? = nil
    public var viewer: ActorViewerState? = nil
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

public struct ProfileViewDetailed: Codable {
    public let atDID: String
    public let actorHandle: String
    public var displayName: String? = nil
    public var description: String? = nil
    public var avatar: String? = nil
    public var banner: String? = nil
    public var followerCount: Int? = nil
    public var followCount: Int? = nil
    public var postCount: Int? = nil
    @DateFormattingOptional public var indexedAt: Date? = nil
    public var viewer: ActorViewerState? = nil
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

public struct ActorViewerState: Codable {
    public let isMuted: Bool? = nil
    public let mutedByList: ListViewBasic? = nil
    public let blockedBy: Bool? = nil
    public let blocking: String? = nil
    public let blockingByList: ListViewBasic? = nil
    public let following: String? = nil
    public let followedBy: String? = nil

    enum CodingKeys: String, CodingKey {
        case isMuted = "muted"
        case mutedByList = "mutedByList"
        case blockedBy = "blockedBy"
        case blocking = "blocking"
        case blockingByList = "blockingByList"
        case following = "following"
        case followedBy = "followedBy"
    }
}

// Define structs for each preference type
public struct ActorPreferences: Codable {
    let preferences: [ActorPreferenceUnion]
}

public struct AdultContentPreferences: Codable {
    var isAdultContentEnabled: Bool = false

    enum CodingKeys: String, CodingKey {
        case isAdultContentEnabled = "enabled"
    }
}

public struct ContentLabelPreferences: Codable {
    let label: String
    let visibility: Visibility

    enum Visibility: String, Codable {
        case show = "show"
        case warn = "warn"
        case hide = "hide"
    }
}

public struct SavedFeedsPreferences: Codable {
    let pinned: [String]
    let saved: [String]
}

public struct PersonalDetailsPreferences: Codable {
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

public struct FeedViewPreferences: Codable {
    let feed: String
    let areRepliesHidden: Bool? = nil
    let areUnfollowedRepliesHidden: Bool? = nil
    let hideRepliesByLikeCount: Int? = nil
    let areRepostsHidden: Bool? = nil
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

public struct ThreadViewPreferences: Codable {
    let sort: SortingMode? = nil
    let areFollowedUsersPrioritized: Bool? = nil

    enum SortingMode: String, Codable {
        case oldest = "oldest"
        case newest = "newest"
        case mostLikes = "most-likes"
        case random = "random"
    }

    enum CodingKeys: String, CodingKey {
        case sort
        case areFollowedUsersPrioritized = "prioritizeFollowedUsers"
    }
}

/// A preference object for the user's preferences for interests.
public struct InterestViewPreferences: Codable {
    /// An array of interest tags. Current maximum limit is 100 tags.
    /// - Note: According to AT Protocol's specifications: "A list of tags which describe the account owner's interests gathered during onboarding."
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

        // Truncate `tags` to 640 characters before encoding
        // `maxGraphemes`'s limit is 64, but `String.count` should respect that limit implictly
        // Then, truncate `tags` to 100 items before encoding
        let truncatedTags = self.tags.map { $0.truncated(toLength: 640) }
        try truncatedEncode(truncatedTags, withContainer: &container, forKey: .tags, upToLength: 100)
    }

    enum CodingKeys: CodingKey {
        case tags
    }
}

// Define an enum to represent the possible preference types
public enum ActorPreferenceUnion: Codable {
    case adultContent(AdultContentPreferences)
    case contentLabel(ContentLabelPreferences)
    case savedFeeds(SavedFeedsPreferences)
    case personalDetails(PersonalDetailsPreferences)
    case feedView(FeedViewPreferences)
    case threadView(ThreadViewPreferences)

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
