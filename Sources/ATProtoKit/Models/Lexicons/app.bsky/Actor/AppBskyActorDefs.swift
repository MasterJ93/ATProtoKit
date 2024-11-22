//
//  AppBskyActorDefs.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-16.
//

import Foundation

extension AppBskyLexicon.Actor {

    /// A definition model for a basic profile view.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct ProfileViewBasicDefinition: Sendable, Codable {

        /// The decentralized identifier (DID) of the user.
        public let actorDID: String

        /// The unique handle of the user.
        public let actorHandle: String

        /// The display name of the user. Optional.
        ///
        /// - Important: Current maximum length is 64 characters.
        public let displayName: String?

        /// The avatar image URL of the user's profile. Optional.
        public let avatarImageURL: URL?

        /// The associated profile view. Optional.
        public let associated: ProfileAssociatedDefinition?

        /// The list of metadata relating to the requesting account's relationship with the subject
        /// account. Optional.
        public let viewer: ViewerStateDefinition?

        /// An array of labels created by the user. Optional.
        public let labels: [ComAtprotoLexicon.Label.LabelDefinition]?

        /// The date and time the profile was created. Optional.
        public let createdAt: Date?

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.actorDID = try container.decode(String.self, forKey: .actorDID)
            self.actorHandle = try container.decode(String.self, forKey: .actorHandle)
            self.displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
            self.avatarImageURL = try container.decodeIfPresent(URL.self, forKey: .avatarImageURL)
            self.associated = try container.decodeIfPresent(AppBskyLexicon.Actor.ProfileAssociatedDefinition.self, forKey: .associated)
            self.viewer = try container.decodeIfPresent(AppBskyLexicon.Actor.ViewerStateDefinition.self, forKey: .viewer)
            self.labels = try container.decodeIfPresent([ComAtprotoLexicon.Label.LabelDefinition].self, forKey: .labels)
            self.createdAt = try decodeDateIfPresent(from: container, forKey: .createdAt)
        }

        @_documentation(visibility: private)
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(self.actorDID, forKey: .actorDID)
            try container.encode(self.actorHandle, forKey: .actorHandle)
            
            // Truncate `displayName` to 640 characters before encoding
            // `maxGraphemes`'s limit is 64, but `String.count` should respect that limit implictly
            try truncatedEncodeIfPresent(self.displayName, withContainer: &container, forKey: .displayName, upToCharacterLength: 64)
            try container.encodeIfPresent(self.avatarImageURL, forKey: .avatarImageURL)
            try container.encodeIfPresent(self.associated, forKey: .associated)
            try container.encodeIfPresent(self.viewer, forKey: .viewer)
            try container.encodeIfPresent(self.labels, forKey: .labels)
            try encodeDateIfPresent(self.createdAt, with: &container, forKey: .createdAt)
        }

        enum CodingKeys: String, CodingKey {
            case actorDID = "did"
            case actorHandle = "handle"
            case displayName
            case avatarImageURL = "avatar"
            case associated
            case viewer
            case labels
            case createdAt
        }
    }

    /// A definition model for a profile view.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct ProfileViewDefinition: Sendable, Codable {

        /// The decentralized identifier (DID) of the user.
        public let actorDID: String

        /// The unique handle of the user.
        public let actorHandle: String

        /// The display name of the user's profile. Optional.
        ///
        /// - Important: Current maximum length is 64 characters.
        public var displayName: String?

        /// The description of the user's profile. Optional.
        ///
        /// - Important: Current maximum length is 256 characters.
        public var description: String?

        /// The avatar image URL of a user's profile. Optional.
        public let avatarImageURL: URL?

        /// The associated profile view. Optional.
        public var associated: ProfileAssociatedDefinition?

        /// The date the profile was last indexed. Optional.
        public var indexedAt: Date?

        /// The date and time the profile was created. Optional.
        public var createdAt: Date?

        /// The list of metadata relating to the requesting account's relationship with the subject
        /// account. Optional.
        public var viewer: ViewerStateDefinition?

        /// An array of labels created by the user. Optional.
        public var labels: [ComAtprotoLexicon.Label.LabelDefinition]?

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.actorDID = try container.decode(String.self, forKey: .actorDID)
            self.actorHandle = try container.decode(String.self, forKey: .actorHandle)
            self.displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
            self.description = try container.decodeIfPresent(String.self, forKey: .description)
            self.avatarImageURL = try container.decodeIfPresent(URL.self, forKey: .avatarImageURL)
            self.associated = try container.decodeIfPresent(AppBskyLexicon.Actor.ProfileAssociatedDefinition.self, forKey: .associated)
            self.indexedAt = try decodeDateIfPresent(from: container, forKey: .indexedAt)
            self.createdAt = try decodeDateIfPresent(from: container, forKey: .createdAt)
            self.viewer = try container.decodeIfPresent(AppBskyLexicon.Actor.ViewerStateDefinition.self, forKey: .viewer)
            self.labels = try container.decodeIfPresent([ComAtprotoLexicon.Label.LabelDefinition].self, forKey: .labels)
        }

        @_documentation(visibility: private)
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(self.actorDID, forKey: .actorDID)
            try container.encode(self.actorHandle, forKey: .actorHandle)
            
            // Truncate `displayName` to 640 characters before encoding
            // `maxGraphemes`'s limit is 64, but `String.count` should respect that limit implictly
            try truncatedEncodeIfPresent(self.displayName, withContainer: &container, forKey: .displayName, upToCharacterLength: 64)

            // Truncate `description` to 2560 characters before encoding
            // `maxGraphemes`'s limit is 256, but `String.count` should respect that limit
            try truncatedEncodeIfPresent(self.description, withContainer: &container, forKey: .description, upToCharacterLength: 256)
            try container.encodeIfPresent(self.avatarImageURL, forKey: .avatarImageURL)
            try container.encodeIfPresent(self.associated, forKey: .associated)
            try encodeDateIfPresent(self.indexedAt, with: &container, forKey: .indexedAt)
            try encodeDateIfPresent(self.createdAt, with: &container, forKey: .createdAt)
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
            case createdAt
            case viewer
            case labels
        }
    }

    /// A definition model for a detailed profile view.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct ProfileViewDetailedDefinition: Sendable, Codable {

        /// The decentralized identifier (DID) of the user.
        public let actorDID: String

        /// The unique handle of the user.
        public let actorHandle: String

        /// The display name of the user's profile. Optional.
        ///
        /// - Important: Current maximum length is 64 characters.
        public var displayName: String?

        /// The description of the user's profile. Optional.
        ///
        /// - Important: Current maximum length is 256 characters.
        public var description: String?

        /// The avatar image URL of a user's profile. Optional.
        public var avatarImageURL: URL?

        /// The banner image URL of a user's profile. Optional.
        public var bannerImageURL: URL?

        /// The number of followers a user has. Optional.
        public var followerCount: Int?

        /// The number of accounts the user follows. Optional.
        public var followCount: Int?

        /// The number of posts the user has. Optional.
        public var postCount: Int?

        /// The associated profile view. Optional.
        public let associated: ProfileAssociatedDefinition?

        /// The starter pack the user account used to join Bluesky. Optional.
        public let joinedViaStarterPack: AppBskyLexicon.Graph.StarterpackRecord?

        /// The date the profile was last indexed. Optional.
        public let indexedAt: Date?

        /// The list of metadata relating to the requesting account's relationship with the subject
        /// account. Optional.
        public var viewer: ViewerStateDefinition?

        /// An array of labels created by the user. Optional.
        public var labels: [ComAtprotoLexicon.Label.LabelDefinition]?

        /// A post record that's pinned to the profile. Optional.
        public let pinnedPost: ComAtprotoLexicon.Repository.StrongReference?

        @_documentation(visibility: private)
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(self.actorDID, forKey: .actorDID)
            try container.encode(self.actorHandle, forKey: .actorHandle)
            
            // Truncate `displayName` to 640 characters before encoding
            // `maxGraphemes`'s limit is 64, but `String.count` should respect that limit implictly
            try truncatedEncodeIfPresent(self.displayName, withContainer: &container, forKey: .displayName, upToCharacterLength: 64)

            // Truncate `description` to 2560 characters before decoding
            // `maxGraphemes`'s limit is 256, but `String.count` should respect that limit
            try truncatedEncodeIfPresent(self.description, withContainer: &container, forKey: .description, upToCharacterLength: 256)
            try container.encodeIfPresent(self.avatarImageURL, forKey: .avatarImageURL)
            try container.encodeIfPresent(self.bannerImageURL, forKey: .bannerImageURL)
            try container.encodeIfPresent(self.followerCount, forKey: .followerCount)
            try container.encodeIfPresent(self.followCount, forKey: .followCount)
            try container.encodeIfPresent(self.postCount, forKey: .postCount)
            try container.encodeIfPresent(self.associated, forKey: .associated)
            try container.encodeIfPresent(self.joinedViaStarterPack, forKey: .joinedViaStarterPack)
            try encodeDateIfPresent(self.indexedAt, with: &container, forKey: .indexedAt)
            try container.encodeIfPresent(self.viewer, forKey: .viewer)
            try container.encodeIfPresent(self.labels, forKey: .labels)
            try container.encodeIfPresent(self.pinnedPost, forKey: .pinnedPost)
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
            case joinedViaStarterPack
            case associated
            case indexedAt
            case viewer
            case labels
            case pinnedPost
        }
    }

    /// A definition model for an actor's associated profile.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct ProfileAssociatedDefinition: Sendable, Codable {

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

    /// A definition model for an actor viewer state.
    ///
    /// - Note: From the AT Protocol specification: "Metadata about the requesting account's
    /// relationship with the subject account. Only has meaningful content for authed requests."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct ViewerStateDefinition: Sendable, Codable {

        /// Indicates whether the requesting account has been muted by the subject
        /// account. Optional.
        public let isMuted: Bool?

        /// An array of lists that the subject account is muted by.
        public let mutedByArray: AppBskyLexicon.Graph.ListViewBasicDefinition?

        /// Indicates whether the requesting account has been blocked by the subject
        /// account. Optional.
        public let isBlocked: Bool?

        /// A URI which indicates the user has blocked the requesting account.
        public let blockingURI: String?

        /// An array of the subject account's lists.
        public let blockingByArray: AppBskyLexicon.Graph.ListViewBasicDefinition?

        /// A URI which indicates the user is following the requesting account.
        public let followingURI: String?

        /// A URI which indicates the user is being followed by the requesting account.
        public let followedByURI: String?

        /// An array of mutual followers. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "The subject's followers whom you
        /// also follow."
        public let knownFollowers: KnownFollowers?

        enum CodingKeys: String, CodingKey {
            case isMuted = "muted"
            case mutedByArray = "mutedByList"
            case isBlocked = "blockedBy"
            case blockingURI = "blocking"
            case blockingByArray = "blockingByList"
            case followingURI = "following"
            case followedByURI = "followedBy"
            case knownFollowers
        }
    }

    /// A definition model for mutual followers.
    ///
    /// - Note: According to the AT Protocol specifications: "The subject's followers whom you
    /// also follow."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct KnownFollowers: Sendable, Codable {

        /// The number of mutual followers related to the parent structure's specifications.
        public let count: Int

        /// An array of user accounts that follow the viewer.
        public let followers: [ProfileViewBasicDefinition]

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.count, forKey: .count)

            // Truncate `displayName` to 5 items before encoding
            try truncatedEncode(self.followers, withContainer: &container, forKey: .followers, upToArrayLength: 5)
        }
    }

    /// A definition model for preferences.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public typealias PreferencesDefinition = [ATUnion.ActorPreferenceUnion]

    /// A definition model for an "Adult Content" preference.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct AdultContentPreferencesDefinition: Sendable, Codable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public let type: String = "app.bsky.actor.defs#adultContentPref"

        /// Indicates whether the user will be able to see adult content in their feed. Set to
        /// `false` by default.
        public var isAdultContentEnabled: Bool = false

        @_documentation(visibility: private)
        public init(isAdultContentEnabled: Bool) {
            self.isAdultContentEnabled = isAdultContentEnabled
        }

        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case isAdultContentEnabled = "enabled"
        }
    }

    /// A definition model for a "Content Label" preference.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct ContentLabelPreferencesDefinition: Sendable, Codable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public let type: String = "app.bsky.actor.defs#contentLabelPref"

        /// The decentralized identifier of the labeler that this preference applies to.
        ///
        /// - Note: If this field is empty, then the preferences apply to all labels.
        ///
        /// - Note: According to the AT Protocol specifications: "Which labeler does this
        /// preference apply to? If undefined, applies globally."
        public let labelerDID: String?

        /// The name of the content label.
        public let label: String

        /// Indicates the visibility of the label's content.
        public let visibility: Visibility

        @_documentation(visibility: private)
        public init(labelerDID: String?, label: String, visibility: Visibility) {
            self.labelerDID = labelerDID
            self.label = label
            self.visibility = visibility
        }

        /// Determines how visible a label's content is.
        public enum Visibility: String, Sendable, Codable {

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

    /// A definition model for a saved feed.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct SavedFeed: Sendable, Codable {

        /// The ID for the saved feed.
        public let feedID: String

        /// The type of feed generator is.
        ///
        /// This is usually referring to the location of the feed in context to the
        /// user account's choice of placement within Bluesky.
        public let type: FeedType

        /// The value of the saved feed generator.
        public let value: String

        /// Indicated whether the saved feed generator is pinned.
        public let isPinned: Bool

        /// The type of feed generator.
        ///
        /// This is usually referring to the location of the feed in context to the
        /// user account's choice of placement within Bluesky.
        public enum FeedType: String, Sendable, Codable {

            /// Indicates the feed generator resides only in the "Feeds" section of Bluesky.
            case feed

            /// Indicates the feed generator additionally resides in a list.
            case list

            /// Indicates the feed generator additionally resides within the
            /// user account's timeline.
            case timeline
        }

        enum CodingKeys: String, CodingKey {
            case feedID = "id"
            case type
            case value
            case isPinned = "pinned"
        }
    }

    /// A definition model for version 2 of a "Saved Feeds" preference.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct SavedFeedPreferencesVersion2Definition: Sendable, Codable {

        /// An array of saved feed generators.
        public let items: SavedFeed
    }

    /// A definition model for a "Saved Feeds" preference.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct SavedFeedsPreferencesDefinition: Sendable, Codable {

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
        public var timelineIndex: Int?

        @_documentation(visibility: private)
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

    /// A definition model for a "Personal Details" preference.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct PersonalDetailsPreferencesDefinition: Sendable, Codable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public let type: String = "app.bsky.actor.defs#personalDetailsPref"

        /// The birth date of the user. Optional.
        ///
        /// - Note: From the AT Protocol specification: "The birth date of account owner."
        public var birthDate: Date?

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.birthDate = try decodeDateIfPresent(from: container, forKey: .birthDate)
        }

        @_documentation(visibility: private)
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try encodeDateIfPresent(self.birthDate, with: &container, forKey: .birthDate)
        }

        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case birthDate
        }
    }

    /// A definition model for a "Feed View" preference.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct FeedViewPreferencesDefinition: Sendable, Codable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public let type: String = "app.bsky.actor.defs#feedViewPref"

        /// The feed's identifier (typically the URI).
        ///
        /// - Note:From the AT Protocol specification: "The URI of the feed, or an identifier
        /// which describes the feed."
        public let feedURI: String

        /// Indicates whether the replies are hidden from the user. Optional.
        ///
        /// - Note: From the AT Protocol specification: "Hide replies in the feed."
        public let areRepliesHidden: Bool?

        /// Indicates whether replies from users you don't follow are hidden from the user. Optional.
        ///
        /// - Note: From the AT Protocol specification: "Hide replies in the feed if they are not
        /// by followed users."
        public let areUnfollowedRepliesHidden: Bool?

        /// Indicates how many likes a post needs in order for the user to see the
        /// reply. Optional.
        ///
        /// - Note: From the AT Protocol specification: "Hide replies in the feed if they do not
        /// have this number of likes."
        public let hideRepliesByLikeCount: Int?

        /// Indicates whether reposts are hidden from the user. Optional.
        ///
        /// - Note: From the AT Protocol specification: "Hide reposts in the feed."
        public let areRepostsHidden: Bool?

        /// Indicates whether quote posts are hidden from the user. Optional.
        ///
        /// - Note: From the AT Protocol specification: "Hide quote posts in the feed."
        public let areQuotePostsHidden: Bool?

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

    /// A definition model for a "Thread View" preference.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct ThreadViewPreferencesDefinition: Sendable, Codable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public let type: String = "app.bsky.actor.defs#threadViewPref"

        /// The sorting mode of a thread. Optional.
        ///
        /// - Note: From the AT Protocol specification: "Sorting mode for threads."
        public let sortingMode: SortingMode?

        /// Indicates whether users you follow are prioritized over other users. Optional.
        ///
        /// - Note: From the AT Protocol specification: "Show followed users at the top of
        /// all replies."
        public let areFollowedUsersPrioritized: Bool?

        /// The sorting mode for a thread.
        public enum SortingMode: String, Sendable, Codable {

            /// Indicates the thread will be sorted from the oldest post.
            case oldest = "oldest"

            /// Indicates the thread will be sorted from the newest post.
            case newest = "newest"

            /// Indicates the thread will be sorted from the posts with the most number
            /// of likes.
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

    /// A definition model for an "Interest View" preference.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct InterestViewPreferencesDefinition: Sendable, Codable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public let type: String = "app.bsky.actor.defs#interestsPref"

        /// An array of interest tags.
        ///
        /// - Note: According to AT Protocol's specifications: "A list of tags which describe the
        /// account owner's interests gathered during onboarding."
        ///
        /// - Important: Current maximum limit is 100 tags. Current maximum length for each tag
        /// name is 64 characters.
        public let tags: [String]

        @_documentation(visibility: private)
        public init(tags: [String]) {
            self.tags = tags
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.tags = try container.decode([String].self, forKey: .tags)
        }

        @_documentation(visibility: private)
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            // Truncate `tags` to 640 characters before encoding.
            // `maxGraphemes`'s limit is 64, but `String.count` should respect that limit implictly.
            // Then, truncate `tags` to 100 items before encoding.
            try truncatedEncode(self.tags, withContainer: &container, forKey: .tags, upToCharacterLength: 64, upToArrayLength: 100)
        }

        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case tags
        }
    }

    /// A definition model for the muted word's target.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public enum MutedWordTarget: Sendable, Codable {

        /// Indicates the muted word is within the content itself.
        case content

        /// Indicates the muted word is a tag.
        case tag

        /// Indicates the muted word is located at an unknown area.
        ///
        /// This case shouldn't be used. If it does appear, then Bluesky may have updated
        /// something that ATProtoKit doesn't yet recognize.
        case other(String)

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            let value = try container.decode(String.self)

            switch value {
                case "content":
                    self = .content
                case "tag":
                    self = .tag
                default:
                    self = .other(value)
            }
        }

        @_documentation(visibility: private)
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

    /// A definition model for a muted word.
    ///
    /// - Note: According to the AT Protocol specifications: "A word that the account owner
    /// has muted."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct MutedWord: Sendable, Codable {

        /// The ID of the muted word.
        public let id: String?

        /// The word to mute.
        public let value: String

        /// An array of intended targets for the muted word.
        public let targets: [MutedWordTarget]

        /// Determines whether the muted word applies to all or a select array of user accounts.
        ///
        /// If this field if left as `nil`, then the muted word will apply to all user accounts.
        ///
        /// - Note: According to the AT Protocol specifications: ""Groups of users to apply the
        /// muted word to. If undefined, applies to all users."
        public let actorTarget: ActorTarget?

        /// The date and time the muted word will no longer be in the user account's list.
        ///
        /// - Note: According to the AT Protocol specifications: "The date and time at which the
        /// muted word will expire and no longer be applied."
        public let expiresAt: Date?

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.id = try container.decodeIfPresent(String.self, forKey: .id)
            self.value = try container.decode(String.self, forKey: .value)
            self.targets = try container.decode([AppBskyLexicon.Actor.MutedWordTarget].self, forKey: .targets)
            self.actorTarget = try container.decodeIfPresent(AppBskyLexicon.Actor.MutedWord.ActorTarget.self, forKey: .actorTarget)
            self.expiresAt = try decodeDateIfPresent(from: container, forKey: .expiresAt)
        }

        @_documentation(visibility: private)
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encodeIfPresent(self.id, forKey: .id)
            // Truncate `value` to 1000 characters before decoding
            // `maxGraphemes`'s limit is 100, but `String.count` should respect that limit
            try truncatedEncode(self.value, withContainer: &container, forKey: .value, upToCharacterLength: 100)
            try container.encode(self.targets, forKey: .targets)
            try container.encodeIfPresent(self.actorTarget, forKey: .actorTarget)
            try encodeDateIfPresent(self.expiresAt, with: &container, forKey: .expiresAt)
        }

        enum CodingKeys: CodingKey {
            case id
            case value
            case targets
            case actorTarget
            case expiresAt
        }

        /// An array of user accounts that the muted word applies to.
        public enum ActorTarget: String, Sendable, Codable {

            /// The muted word applies to everyone.
            case all

            /// The muted word applies to everyone but a select array of user accounts.
            case excludeFollowing = "exclude-following"
        }
    }

    /// A definition model for a "Muted Words" preference.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct MutedWordsPreferencesDefinition: Sendable, Codable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public let type: String = "app.bsky.actor.defs#mutedWordsPref"

        /// An array of items the user has muted.
        ///
        /// - Note: According to the AT Protocol specifications: "A list of words the account
        /// owner has muted."
        public let mutedItems: [MutedWord]

        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case mutedItems = "items"
        }
    }

    /// A definition model for a "Hidden Posts" preference.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct HiddenPostsPreferencesDefinition: Sendable, Codable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public let type: String = "app.bsky.actor.defs#hiddenPostsPref"

        /// An array of URIs related to posts that the user wants to hide.
        ///
        /// - Note: According to the AT Protocol specifications: "A list of URIs of posts the
        /// account owner has hidden."
        public let items: [String]

        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case items
        }
    }

    /// A definition model for  a "Labelers" preference.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct LabelersPreferencesDefinition: Sendable, Codable {

        /// An array of labeler items.
        public let labelers: [String]
    }

    /// A definition model for a labeler item.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct LabelersPreferenceItem: Sendable, Codable {

        /// The decentralized identifier (DID) of the labeler.
        public let labelerDID: String

        enum CodingKeys: String, CodingKey {
            case labelerDID = "did"
        }
    }

    /// A definition model for Bluesky app-specific states.
    ///
    /// - Important: Do not use this at all, as this is specific to the Bluesky app.
    ///
    /// - Note: According to the AT Protocol specifications: "A grab bag of state that's specific
    /// to the bsky.app program. Third-party apps shouldn't use this."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct BskyAppStatePreferencesDefinition: Sendable, Codable {

        /// An active progress guide. Optional.
        public let activeProgressGuide: String?

        /// An array of elements that the user will see. Optional.
        public let queuedNudges: [String]?

        /// An array of NUXs (New User Experiences). Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Storage for NUXs the user
        /// has encountered."
        public let nexs: [NUXDefinition]?

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encodeIfPresent(self.activeProgressGuide, forKey: .activeProgressGuide)
            try truncatedEncodeIfPresent(self.queuedNudges, withContainer: &container, forKey: .queuedNudges, upToCharacterLength: 100, upToArrayLength: 1_000)
            try truncatedEncodeIfPresent(self.nexs, withContainer: &container, forKey: .nexs, upToArrayLength: 100)
        }
    }

    /// A definition model for a progress guide.
    ///
    /// - Note: According to the AT Protocol specifications: "If set, an active progress guide.
    /// Once completed, can be set to undefined. Should have unspecced fields tracking progress."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct BskyAppProgressGuideDefinition: Sendable, Codable {

        /// The progress guide itself.
        public let guide: [BskyAppStatePreferencesDefinition]

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try truncatedEncode(self.guide, withContainer: &container, forKey: .guide, upToArrayLength: 100)
        }
    }

    /// A definition model for a NUX.
    ///
    /// - Note: According to the AT Protocol specifications: "A new user experiences (NUX)
    /// storage object"
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct NUXDefinition: Sendable, Codable {

        /// The ID of the NUX.
        public let id: String

        /// Indicated whether the experience was completed.
        public var isCompleted: Bool = false

        /// Data created for the NUX. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Arbitrary data for the NUX.
        /// The structure is defined by the NUX itself. Limited to 300 characters."
        public let data: String?

        /// The date and time the NUX expires. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "The date and time at which the
        /// NUX will expire and should be considered completed."
        public let expiresAt: Date?

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.id = try container.decode(String.self, forKey: .id)
            self.isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
            self.data = try container.decodeIfPresent(String.self, forKey: .data)
            self.expiresAt = try decodeDateIfPresent(from: container, forKey: .expiresAt)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try truncatedEncode(self.id, withContainer: &container, forKey: .id, upToCharacterLength: 100)
            try container.encode(self.isCompleted, forKey: .isCompleted)
            try truncatedEncodeIfPresent(self.data, withContainer: &container, forKey: .data, upToCharacterLength: 300)
            try encodeDateIfPresent(self.expiresAt, with: &container, forKey: .expiresAt)
        }

        enum CodingKeys: String, CodingKey {
            case id
            case isCompleted = "completed"
            case data
            case expiresAt
        }
    }
}
