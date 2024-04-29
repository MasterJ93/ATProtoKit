//
//  BskyGraphDefs.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-25.
//

import Foundation

/// A data model for a basic list view definition.
///
/// - SeeAlso: This is based on the [`app.bsky.graph.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/defs.json
public struct GraphListViewBasic: Codable {
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
    public let purpose: GraphListPurpose
    /// The avatar image URL of the user list. Optional.
    public let avatarImageURL: URL?
    /// The viewer's state of the user list. Optional.
    public var viewer: GraphListViewerState? = nil
    /// The late time the user list was indexed.
    @DateFormattingOptional public var indexedAt: Date? = nil

    public init(actorURI: String, cidHash: String, name: String, purpose: GraphListPurpose, avatarImageURL: URL?, viewer: GraphListViewerState?,
                indexedAt: Date?) {
        self.actorURI = actorURI
        self.cidHash = cidHash
        self.name = name
        self.purpose = purpose
        self.avatarImageURL = avatarImageURL
        self.viewer = viewer
        self._indexedAt = DateFormattingOptional(wrappedValue: indexedAt)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.actorURI = try container.decode(String.self, forKey: .actorURI)
        self.cidHash = try container.decode(String.self, forKey: .cidHash)
        self.name = try container.decode(String.self, forKey: .name)
        self.purpose = try container.decode(GraphListPurpose.self, forKey: .purpose)
        self.avatarImageURL = try container.decodeIfPresent(URL.self, forKey: .avatarImageURL)
        self.viewer = try container.decodeIfPresent(GraphListViewerState.self, forKey: .viewer)
        self.indexedAt = try container.decodeIfPresent(DateFormattingOptional.self, forKey: .indexedAt)?.wrappedValue
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.actorURI, forKey: .actorURI)
        try container.encode(self.cidHash, forKey: .cidHash)
        try container.encode(self.name, forKey: .name)
        //
        try truncatedEncode(self.name, withContainer: &container, forKey: .name, upToLength: 64)
        try container.encode(self.purpose, forKey: .purpose)
        try container.encodeIfPresent(self.avatarImageURL, forKey: .avatarImageURL)
        try container.encodeIfPresent(self.viewer, forKey: .viewer)
        try container.encode(self._indexedAt, forKey: .indexedAt)
    }

    enum CodingKeys: String, CodingKey {
        case actorURI = "uri"
        case cidHash = "cid"
        case name = "name"
        case purpose = "purpose"
        case avatarImageURL = "avatar"
        case viewer = "viewer"
        case indexedAt
    }
}

/// A data model for a definition of the view of a user list.
///
/// - SeeAlso: This is based on the [`app.bsky.graph.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/defs.json
public struct GraphListView: Codable {
    /// The URI of the user list.
    public let listURI: String
    /// The CID of the user list.
    public let cidHash: String
    /// The creator of the user list.
    public let creator: ActorProfileView
    /// The name of the user list.
    ///
    /// - Important: Current maximum length is 64 characters. This library will truncate the
    /// `String` to the maximum number of characters if it does go over.
    public let name: String
    /// The purpose of the user list.
    public let purpose: GraphListPurpose
    /// The description of the user list. Optional.
    ///
    /// - Important: Current maximum length is 300 characters. This library will truncate the
    /// `String` to the maximum number of characters if it does go over.
    public var description: String? = nil
    /// An array of facets contained in the post's text. Optional.
    public var descriptionFacets: [Facet]? = nil
    /// The avatar image URL of the user list. Optional.
    public var avatarImageURL: URL? = nil
    /// The viewer's state of the user list. Optional.
    public var viewer: GraphListViewerState? = nil
    /// The late time the user list was indexed.
    @DateFormatting public var indexedAt: Date

    public init(listURI: String, cidHash: String, creator: ActorProfileView, name: String, purpose: GraphListPurpose, description: String?,
                descriptionFacets: [Facet]?, avatarImageURL: URL?, viewer: GraphListViewerState?, indexedAt: Date) {
        self.listURI = listURI
        self.cidHash = cidHash
        self.creator = creator
        self.name = name
        self.purpose = purpose
        self.description = description
        self.descriptionFacets = descriptionFacets
        self.avatarImageURL = avatarImageURL
        self.viewer = viewer
        self._indexedAt = DateFormatting(wrappedValue: indexedAt)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.listURI = try container.decode(String.self, forKey: .listURI)
        self.cidHash = try container.decode(String.self, forKey: .cidHash)
        self.creator = try container.decode(ActorProfileView.self, forKey: .creator)
        self.name = try container.decode(String.self, forKey: .name)
        self.purpose = try container.decode(GraphListPurpose.self, forKey: .purpose)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.descriptionFacets = try container.decodeIfPresent([Facet].self, forKey: .descriptionFacets)
        self.avatarImageURL = try container.decodeIfPresent(URL.self, forKey: .avatarImageURL)
        self.viewer = try container.decodeIfPresent(GraphListViewerState.self, forKey: .viewer)
        self.indexedAt = try container.decode(DateFormatting.self, forKey: .indexedAt).wrappedValue
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.listURI, forKey: .listURI)
        try container.encode(self.cidHash, forKey: .cidHash)
        try container.encode(self.creator, forKey: .creator)
        // Truncate `name` to 64 characters before encoding.
        try truncatedEncode(self.name, withContainer: &container, forKey: .name, upToLength: 64)
        try container.encode(self.purpose, forKey: .purpose)

        // Truncate `description` to 3000 characters before encoding
        // `maxGraphemes`'s limit is 300, but `String.count` should respect that limit
        try truncatedEncodeIfPresent(self.description, withContainer: &container, forKey: .description, upToLength: 3000)
        try container.encodeIfPresent(self.descriptionFacets, forKey: .descriptionFacets)
        try container.encodeIfPresent(self.avatarImageURL, forKey: .avatarImageURL)
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
        case viewer = "viewer"
        case indexedAt = "indexedAt"
    }
}

/// A data model for the definition of an item with in a user list.
///
/// - SeeAlso: This is based on the [`app.bsky.graph.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/defs.json
public struct GraphListItemView: Codable {
    /// The URI of the user list item.
    public let listItemURI: String
    /// A user in the user list item.
    public let subject: ActorProfileView

    enum CodingKeys: String, CodingKey {
        case listItemURI = "uri"
        case subject
    }
}

/// A data model of the definition of the user list's purpose.
///
/// - SeeAlso: This is based on the [`app.bsky.graph.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/defs.json
public enum GraphListPurpose: String, Codable {
    /// An array of actors to apply an aggregate moderation action (mute/block) on.
    case modlist = "app.bsky.graph.defs#modlist"

    /// An array of actors used for curation purposes such as list feeds or interaction gating.
    case curatelist = "app.bsky.graph.defs#curatelist"
}


/// A data model of a definition for a viewer's state of a user list.
///
/// - SeeAlso: This is based on the [`app.bsky.graph.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/defs.json
public struct GraphListViewerState: Codable {
    /// Indicates whether the user is muted. Optional.
    public var isMuted: Bool? = nil
    /// The URI of the block record if the user has blocked the user list. Optional
    public var blockedURI: String? = nil

    enum CodingKeys: String, CodingKey {
        case isMuted = "muted"
        case blockedURI = "blocked"
    }
}

/// A data model for a definition of a user that may not have been found in the user list.
///
/// - SeeAlso: This is based on the [`app.bsky.graph.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/defs.json
public struct GraphNotFoundActor: Codable {
    /// The URI of the user.
    ///
    /// - Note: According to the AT Protocol specifications: "indicates that a handle or DID could
    /// not be resolved",
    public let actorURI: String
    /// Indicates whether the user is not found.
    public let isNotFound: Bool

    enum CodingKeys: String, CodingKey {
        case actorURI = "actor"
        case isNotFound = "notFound"
    }
}

/// A data model for the graph relationship definition.
///
/// - Note: According to the AT Protocol specifications: "lists the bi-directional graph
/// relationships between one actor (not indicated in the object), and the target actors (the DID
/// included in the object)"
///
/// - SeeAlso: This is based on the [`app.bsky.graph.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/defs.json
public struct GraphRelationship: Codable {
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
