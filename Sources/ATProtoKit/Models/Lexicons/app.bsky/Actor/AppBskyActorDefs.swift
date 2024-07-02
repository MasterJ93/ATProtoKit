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
    public struct ProfileViewBasicDefinition: Codable {

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
        @DateFormattingOptional public var createdAt: Date?

        @_documentation(visibility: private)
        public init(actorDID: String, actorHandle: String, displayName: String?, avatarImageURL: URL?, associated: ProfileAssociatedDefinition?,
                    viewer: ViewerStateDefinition?, labels: [ComAtprotoLexicon.Label.LabelDefinition]?, createdAt: Date?) {
            self.actorDID = actorDID
            self.actorHandle = actorHandle
            self.displayName = displayName
            self.avatarImageURL = avatarImageURL
            self.associated = associated
            self.viewer = viewer
            self.labels = labels
            self._createdAt = DateFormattingOptional(wrappedValue: createdAt)
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            self.actorDID = try container.decode(String.self, forKey: .actorDID)
            self.actorHandle = try container.decode(String.self, forKey: .actorHandle)
            self.displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
            self.avatarImageURL = try container.decodeIfPresent(URL.self, forKey: .avatarImageURL)
            self.associated = try container.decodeIfPresent(ProfileAssociatedDefinition.self, forKey: .associated)
            self.viewer = try container.decodeIfPresent(ViewerStateDefinition.self, forKey: .viewer)
            self.labels = try container.decodeIfPresent([ComAtprotoLexicon.Label.LabelDefinition].self, forKey: .labels)
            self.createdAt = try container.decodeIfPresent(DateFormattingOptional.self, forKey: .createdAt)?.wrappedValue
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
            try container.encodeIfPresent(self.createdAt, forKey: .createdAt)
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
    public struct ProfileViewDefinition: Codable {

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
        @DateFormattingOptional public var indexedAt: Date?

        /// The date and time the profile was created. Optional.
        @DateFormattingOptional public var createdAt: Date?

        /// The list of metadata relating to the requesting account's relationship with the subject
        /// account. Optional.
        public var viewer: ViewerStateDefinition?

        /// An array of labels created by the user. Optional.
        public var labels: [ComAtprotoLexicon.Label.LabelDefinition]?

        @_documentation(visibility: private)
        public init(actorDID: String, actorHandle: String, displayName: String?, description: String?, avatarImageURL: URL?,
                    associated: ProfileAssociatedDefinition?, indexedAt: Date?, createdAt: Date?, viewer: ViewerStateDefinition?,
                    labels: [ComAtprotoLexicon.Label.LabelDefinition]?) {
            self.actorDID = actorDID
            self.actorHandle = actorHandle
            self.displayName = displayName
            self.description = description
            self.avatarImageURL = avatarImageURL
            self.associated = associated
            self._indexedAt = DateFormattingOptional(wrappedValue: indexedAt)
            self._createdAt = DateFormattingOptional(wrappedValue: createdAt)
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
            self.associated = try container.decodeIfPresent(ProfileAssociatedDefinition.self, forKey: .associated)
            self.indexedAt = try container.decodeIfPresent(DateFormattingOptional.self, forKey: .indexedAt)?.wrappedValue
            self.createdAt = try container.decodeIfPresent(DateFormattingOptional.self, forKey: .createdAt)?.wrappedValue
            self.viewer = try container.decodeIfPresent(ViewerStateDefinition.self, forKey: .viewer)
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
            try container.encodeIfPresent(self._indexedAt, forKey: .indexedAt)
            try container.encodeIfPresent(self._createdAt, forKey: .createdAt)
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
    public struct ProfileViewDetailedDefinition: Codable {

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

        /// The date the profile was last indexed. Optional.
        @DateFormattingOptional public var indexedAt: Date?

        /// The list of metadata relating to the requesting account's relationship with the subject
        /// account. Optional.
        public var viewer: ViewerStateDefinition?

        /// An array of labels created by the user. Optional.
        public var labels: [ComAtprotoLexicon.Label.LabelDefinition]?

        @_documentation(visibility: private)
        public init(actorDID: String, actorHandle: String, displayName: String?, description: String?, avatarImageURL: URL?, bannerImageURL: URL?,
                    followerCount: Int?, followCount: Int?, postCount: Int?, associated: ProfileAssociatedDefinition?, indexedAt: Date?,
                    viewer: ViewerStateDefinition?, labels: [ComAtprotoLexicon.Label.LabelDefinition]?) {
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
            self.associated = try container.decodeIfPresent(ProfileAssociatedDefinition.self, forKey: .associated)
            self.indexedAt = try container.decodeIfPresent(DateFormattingOptional.self, forKey: .indexedAt)?.wrappedValue
            self.viewer = try container.decodeIfPresent(ViewerStateDefinition.self, forKey: .viewer)
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

            // Truncate `description` to 2560 characters before decoding
            // `maxGraphemes`'s limit is 256, but `String.count` should respect that limit
            try truncatedEncodeIfPresent(self.description, withContainer: &container, forKey: .description, upToCharacterLength: 256)
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

    /// A definition model for an actor's associated profile.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct ProfileAssociatedDefinition: Codable {

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
    public struct ViewerStateDefinition: Codable {

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
    public struct KnownFollowers: Codable {

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
    public struct PreferencesDefinition: Codable {

        /// An array of different preferences the user can set.
        public let preferences: [ATUnion.ActorPreferenceUnion]

        @_documentation(visibility: private)
        public init(preferences: [ATUnion.ActorPreferenceUnion]) {
            self.preferences = preferences
        }
    }

    /// A definition model for an "Adult Content" preference.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct AdultContentPreferencesDefinition: Codable {

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
    public struct ContentLabelPreferencesDefinition: Codable {

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

    /// A definition model for a saved feed.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct SavedFeed: Codable {
        
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
        public enum FeedType: String, Codable {

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
    public struct SavedFeedPreferencesVersion2Definition: Codable {

        /// An array of saved feed generators.
        public let items: SavedFeed
    }

    /// A definition model for a "Saved Feeds" preference.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct SavedFeedsPreferencesDefinition: Codable {

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
    public struct PersonalDetailsPreferencesDefinition: Codable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public let type: String = "app.bsky.actor.defs#personalDetailsPref"

        /// The birth date of the user. Optional.
        ///
        /// - Note: From the AT Protocol specification: "The birth date of account owner."
        @DateFormattingOptional public var birthDate: Date?

        @_documentation(visibility: private)
        public init(birthDate: Date) {
            self._birthDate = DateFormattingOptional(wrappedValue: birthDate)
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.birthDate = try container.decodeIfPresent(DateFormattingOptional.self, forKey: .birthDate)?.wrappedValue
        }

        @_documentation(visibility: private)
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encodeIfPresent(self._birthDate, forKey: .birthDate)
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
    public struct FeedViewPreferencesDefinition: Codable {

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
    public struct ThreadViewPreferencesDefinition: Codable {

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
        public enum SortingMode: String, Codable {

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
    public struct InterestViewPreferencesDefinition: Codable {

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
    public enum MutedWordTarget: Codable {

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
    public struct MutedWord: Codable {

        /// The word to mute.
        public let value: String

        /// An array of intended targets for the muted word.
        public let targets: [MutedWordTarget]

        @_documentation(visibility: private)
        public init(value: String, targets: [MutedWordTarget]) {
            self.value = value
            self.targets = targets
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.value = try container.decode(String.self, forKey: .value)
            self.targets = try container.decode([MutedWordTarget].self, forKey: .targets)
        }

        @_documentation(visibility: private)
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            // Truncate `value` to 1000 characters before decoding
            // `maxGraphemes`'s limit is 100, but `String.count` should respect that limit
            try truncatedEncode(self.value, withContainer: &container, forKey: .value, upToCharacterLength: 100)
            try container.encode(self.targets, forKey: .targets)
        }

        enum CodingKeys: CodingKey {
            case value
            case targets
        }
    }

    /// A definition model for a "Muted Words" preference.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct MutedWordsPreferencesDefinition: Codable {

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
    public struct HiddenPostsPreferencesDefinition: Codable {

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
    public struct LabelersPreferencesDefinition: Codable {

        /// An array of labeler items.
        public let labelers: [String]
    }

    /// A definition model for a labeler item.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct LabelersPreferenceItem: Codable {

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
    public struct BskyAppStatePreferencesDefinition: Codable {

        /// An active progress guide. Optional.
        public let activeProgressGuide: String?

        /// An array of elements that the user will see. Optional.
        public let queuedNudges: [String]?

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encodeIfPresent(self.activeProgressGuide, forKey: .activeProgressGuide)
            try truncatedEncodeIfPresent(self.queuedNudges, withContainer: &container, forKey: .queuedNudges, upToCharacterLength: 100, upToArrayLength: 1_000)
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
    public struct BskyAppProgressGuide: Codable {

        /// The progress guide itself.
        public let guide: [String]

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.guide, forKey: .guide)
            try truncatedEncode(self.guide, withContainer: &container, forKey: .guide, upToArrayLength: 100)
        }
    }
}
