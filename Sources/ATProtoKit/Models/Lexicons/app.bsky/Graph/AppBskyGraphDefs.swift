//
//  AppBskyGraphDefs.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension AppBskyLexicon.Graph {

    /// A definition model for a basic list view.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.graph.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/defs.json
    public struct ListViewBasicDefinition: Sendable, Codable {

        /// The URI of a user list.
        public let actorURI: String

        /// The CID of a user list.
        public let cidHash: String

        /// The name of the list.
        public let name: String

        /// The purpose of the user list.
        ///
        /// - Important: Current maximum length is 64 characters. This library will truncate the
        /// `String` to the maximum number of characters if it does go over.
        public let purpose: ListPurpose

        /// The avatar image URL of the user list. Optional.
        public let avatarImageURL: URL?

        /// The number of items on the list.
        public let listItemCount: Int?

        /// The viewer's state of the user list. Optional.
        public var viewer: ListViewerStateDefinition?

        /// The late time the user list was indexed. Optional.
        @DateFormattingOptional public var indexedAt: Date?

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.actorURI, forKey: .actorURI)
            try container.encode(self.cidHash, forKey: .cidHash)
            try container.encode(self.name, forKey: .name)
            try truncatedEncode(self.name, withContainer: &container, forKey: .name, upToCharacterLength: 64)
            try container.encode(self.purpose, forKey: .purpose)
            try container.encodeIfPresent(self.avatarImageURL, forKey: .avatarImageURL)
            try container.encodeIfPresent(self.listItemCount, forKey: .listItemCount)
            try container.encodeIfPresent(self.viewer, forKey: .viewer)
            try container.encode(self._indexedAt, forKey: .indexedAt)
        }

        enum CodingKeys: String, CodingKey {
            case actorURI = "uri"
            case cidHash = "cid"
            case name = "name"
            case purpose = "purpose"
            case avatarImageURL = "avatar"
            case listItemCount
            case viewer = "viewer"
            case indexedAt
        }
    }

    /// A definition model for the view of a user list.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.graph.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/defs.json
    public struct ListViewDefinition: Sendable, Codable {

        /// The URI of the user list.
        public let listURI: String

        /// The CID of the user list.
        public let cidHash: String

        /// The creator of the user list.
        public let creator: AppBskyLexicon.Actor.ProfileViewDefinition

        /// The name of the user list.
        ///
        /// - Important: Current maximum length is 64 characters. This library will truncate the
        /// `String` to the maximum number of characters if it does go over.
        public let name: String

        /// The purpose of the user list.
        public let purpose: ListPurpose

        /// The description of the user list. Optional.
        ///
        /// - Important: Current maximum length is 300 characters. This library will truncate the
        /// `String` to the maximum number of characters if it does go over.
        public var description: String?

        /// An array of facets contained in the post's text. Optional.
        public var descriptionFacets: [AppBskyLexicon.RichText.Facet]?

        /// The avatar image URL of the user list. Optional.
        public var avatarImageURL: URL?

        /// The number of items on the list.
        public let listItemCount: Int?

        /// The viewer's state of the user list. Optional.
        public var viewer: ListViewerStateDefinition?

        /// The late time the user list was indexed.
        @DateFormatting public var indexedAt: Date

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.listURI, forKey: .listURI)
            try container.encode(self.cidHash, forKey: .cidHash)
            try container.encode(self.creator, forKey: .creator)
            // Truncate `name` to 64 characters before encoding.
            try truncatedEncode(self.name, withContainer: &container, forKey: .name, upToCharacterLength: 64)
            try container.encode(self.purpose, forKey: .purpose)

            // Truncate `description` to 3000 characters before encoding
            // `maxGraphemes`'s limit is 300, but `String.count` should respect that limit
            try truncatedEncodeIfPresent(self.description, withContainer: &container, forKey: .description, upToCharacterLength: 300)
            try container.encodeIfPresent(self.descriptionFacets, forKey: .descriptionFacets)
            try container.encodeIfPresent(self.avatarImageURL, forKey: .avatarImageURL)
            try container.encodeIfPresent(self.listItemCount, forKey: .listItemCount)
            try container.encodeIfPresent(self.viewer, forKey: .viewer)
            try container.encode(self._indexedAt, forKey: .indexedAt)
        }

        enum CodingKeys: String, CodingKey {
            case listURI = "uri"
            case cidHash = "cid"
            case creator = "creator"
            case name = "name"
            case purpose = "purpose"
            case description = "description"
            case descriptionFacets = "descriptionFacets"
            case avatarImageURL = "avatar"
            case listItemCount
            case viewer = "viewer"
            case indexedAt = "indexedAt"
        }
    }

    /// A definition model for an item with in a user list.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.graph.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/defs.json
    public struct ListItemViewDefinition: Sendable, Codable {

        /// The URI of the user list item.
        public let listItemURI: String

        /// A user in the user list item.
        public let subject: AppBskyLexicon.Actor.ProfileViewDefinition

        enum CodingKeys: String, CodingKey {
            case listItemURI = "uri"
            case subject
        }
    }

    /// A definition model for a starter pack view.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.graph.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/defs.json
    public struct StarterPackViewDefinition: Sendable, Codable {

        /// The URI of the starter pack.
        public let starterPackURI: String

        /// The content identifier (CID) of the starter pack.
        public let starterPackCID: String

        /// The starter pack record itself.
        public let starterPackRecord: UnknownType

        /// The creator of the starter pack.
        public let creator: AppBskyLexicon.Actor.ProfileViewBasicDefinition

        /// A basic list view. Optional.
        public let list: AppBskyLexicon.Graph.ListViewBasicDefinition?

        /// An array of list items. Optional.
        public let listItemsSample: [AppBskyLexicon.Graph.ListItemViewDefinition]?

        /// An array of feeds. Optional.
        public let feeds: [AppBskyLexicon.Feed.GeneratorViewDefinition]?

        /// The number of users that have joined the service through the starter pack within the
        /// last seven days. Optional.
        public let joinedWeekCount: Int?

        /// The total number of users that have joined the service though the
        /// starter pack. Optional.
        public let joinedAllTimeCount: Int?

        /// An array of labels created by the user. Optional.
        public let labels: [ComAtprotoLexicon.Label.LabelDefinition]?

        /// The late time the user list was indexed. Optional.
        @DateFormatting public var indexedAt: Date

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.starterPackURI, forKey: .starterPackURI)
            try container.encode(self.starterPackCID, forKey: .starterPackCID)
            try container.encode(self.starterPackRecord, forKey: .starterPackRecord)
            try container.encode(self.creator, forKey: .creator)
            try container.encodeIfPresent(self.list, forKey: .list)
            try truncatedEncodeIfPresent(self.listItemsSample, withContainer: &container, forKey: .listItemsSample, upToCharacterLength: 12)
            try truncatedEncodeIfPresent(self.feeds, withContainer: &container, forKey: .feeds, upToArrayLength: 3)
            try container.encodeIfPresent(self.joinedWeekCount, forKey: .joinedWeekCount)
            try container.encodeIfPresent(self.joinedAllTimeCount, forKey: .joinedAllTimeCount)
            try container.encodeIfPresent(self.labels, forKey: .labels)
            try container.encode(self._indexedAt, forKey: .indexedAt)
        }

        enum CodingKeys: String, CodingKey {
            case starterPackURI = "uri"
            case starterPackCID = "cid"
            case starterPackRecord = "record"
            case creator
            case list
            case listItemsSample
            case feeds
            case joinedWeekCount
            case joinedAllTimeCount
            case labels
            case indexedAt
        }
    }

    /// A definition model for a basic starter pack view.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.graph.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/defs.json
    public struct StarterPackViewBasicDefinition: Sendable, Codable {

        /// The URI of the starter pack.
        public let starterPackURI: String

        /// The content identifier (CID) of the starter pack.
        public let starterPackCID: String

        /// The starter pack record itself.
        public let starterPackRecord: UnknownType

        /// The creator of the starter pack.
        public let creator: AppBskyLexicon.Actor.ProfileViewBasicDefinition

        /// The number of items in the list.
        public let listItemCount: Int?

        /// The number of users that have joined the service through the starter pack within the
        /// last seven days. Optional.
        public let joinedWeekCount: Int?

        /// The total number of users that have joined the service though the
        /// starter pack. Optional.
        public let joinedAllTimeCount: Int?

        /// An array of labels created by the user. Optional.
        public let labels: [ComAtprotoLexicon.Label.LabelDefinition]?

        /// The late time the user list was indexed. Optional.
        public let indexedAt: Date

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.starterPackURI = try container.decode(String.self, forKey: CodingKeys.starterPackURI)
            self.starterPackCID = try container.decode(String.self, forKey: .starterPackCID)
            self.starterPackRecord = try container.decode(UnknownType.self, forKey: .starterPackRecord)
            self.creator = try container.decode(AppBskyLexicon.Actor.ProfileViewBasicDefinition.self, forKey: .creator)
            self.listItemCount = try container.decodeIfPresent(Int.self, forKey: .listItemCount)
            self.joinedWeekCount = try container.decodeIfPresent(Int.self, forKey: .joinedWeekCount)
            self.joinedAllTimeCount = try container.decodeIfPresent(Int.self, forKey: .joinedAllTimeCount)
            self.labels = try container.decodeIfPresent([ComAtprotoLexicon.Label.LabelDefinition].self, forKey: .labels)
            self.indexedAt = try decodeDate(from: container, forKey: .indexedAt)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.starterPackURI, forKey: .starterPackURI)
            try container.encode(self.starterPackCID, forKey: .starterPackCID)
            try container.encode(self.starterPackRecord, forKey: .starterPackRecord)
            try container.encode(self.creator, forKey: .creator)
            try container.encodeIfPresent(self.listItemCount, forKey: .listItemCount)
            try container.encodeIfPresent(self.joinedWeekCount, forKey: .joinedWeekCount)
            try container.encodeIfPresent(self.joinedAllTimeCount, forKey: .joinedAllTimeCount)
            try container.encodeIfPresent(self.labels, forKey: .labels)
            try encodeDate(self.indexedAt, with: &container, forKey: .indexedAt)
        }

        enum CodingKeys: String, CodingKey {
            case starterPackURI = "uri"
            case starterPackCID = "cid"
            case starterPackRecord = "record"
            case creator
            case listItemCount
            case joinedWeekCount
            case joinedAllTimeCount
            case labels
            case indexedAt
        }
    }

    /// A definition model for the user list's purpose.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.graph.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/defs.json
    public enum ListPurpose: String, Sendable, Codable {

        /// An array of actors to apply an aggregate moderation action (mute/block) on.
        ///
        /// - Note: The documentation is taken directly from the lexicon itself.
        case modlist = "app.bsky.graph.defs#modlist"

        /// An array of actors used for curation purposes such as list feeds or interaction gating.
        ///
        /// - Note: The documentation is taken directly from the lexicon itself.
        case curatelist = "app.bsky.graph.defs#curatelist"

        /// A list of actors used for only for reference purposes such as within a starter pack.
        ///
        /// - Note: The documentation is taken directly from the lexicon itself.
        case referencelist = "app.bsky.graph.defs#referencelist"
    }

    /// A definition model for a viewer's state of a user list.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.graph.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/defs.json
    public struct ListViewerStateDefinition: Sendable, Codable {

        /// Indicates whether the user is muted. Optional.
        public var isMuted: Bool?

        /// The URI of the block record if the user has blocked the user list. Optional
        public var blockedURI: String?

        enum CodingKeys: String, CodingKey {
            case isMuted = "muted"
            case blockedURI = "blocked"
        }
    }

    /// A definition model for a user that may not have been found in the user list.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.graph.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/defs.json
    public struct NotFoundActorDefinition: Sendable, Codable {

        /// The URI of the user.
        ///
        /// - Note: According to the AT Protocol specifications: "indicates that a handle or DID
        /// could not be resolved".
        public let actorURI: String

        /// Indicates whether the user is not found.
        public let isNotFound: Bool

        enum CodingKeys: String, CodingKey {
            case actorURI = "actor"
            case isNotFound = "notFound"
        }
    }

    /// A definition model for a graph relationship between two user accounts.
    ///
    /// - Note: According to the AT Protocol specifications: "lists the bi-directional graph
    /// relationships between one actor (not indicated in the object), and the target actors (the DID
    /// included in the object)"
    ///
    /// - SeeAlso: This is based on the [`app.bsky.graph.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/defs.json
    public struct RelationshipDefinition: Sendable, Codable {

        /// The decentralized identifier (DID) of the target user.
        public let actorDID: String

        /// The URI of the follow record, if the first user is following the target user. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "if the actor follows this DID, this
        /// is the AT-URI of the follow record"
        public let followingURI: String?

        /// The URI of the follow record, if the target user is following the first user. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "if the actor is followed by this
        /// DID, contains the AT-URI of the follow record"
        public let followedByURI: String?

        enum CodingKeys: String, CodingKey {
            case actorDID = "did"
            case followingURI = "following"
            case followedByURI = "followedBy"
        }
    }
}
