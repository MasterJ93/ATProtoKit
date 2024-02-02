//
//  BskyGraphDefs.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-25.
//

import Foundation

public struct ListViewBasic: Codable {
    public let atURI: String
    public let cidHash: String
    public let name: String
    public let purpose: ListPurpose
    public let avatar: String?
    public var viewer: ListViewerState? = nil
    @DateFormattingOptional public var indexedAt: Date? = nil

    public init(atURI: String, cidHash: String, name: String, purpose: ListPurpose, avatar: String?, viewer: ListViewerState?, indexedAt: Date?) {
        self.atURI = atURI
        self.cidHash = cidHash
        self.name = name
        self.purpose = purpose
        self.avatar = avatar
        self.viewer = viewer
        self._indexedAt = DateFormattingOptional(wrappedValue: indexedAt)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.atURI = try container.decode(String.self, forKey: .atURI)
        self.cidHash = try container.decode(String.self, forKey: .cidHash)
        self.name = try container.decode(String.self, forKey: .name)
        self.purpose = try container.decode(ListPurpose.self, forKey: .purpose)
        self.avatar = try container.decodeIfPresent(String.self, forKey: .avatar)
        self.viewer = try container.decodeIfPresent(ListViewerState.self, forKey: .viewer)
        self.indexedAt = try container.decodeIfPresent(DateFormattingOptional.self, forKey: .indexedAt)?.wrappedValue
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.atURI, forKey: .atURI)
        try container.encode(self.cidHash, forKey: .cidHash)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.purpose, forKey: .purpose)
        try container.encodeIfPresent(self.avatar, forKey: .avatar)
        try container.encodeIfPresent(self.viewer, forKey: .viewer)
        try container.encode(self._indexedAt, forKey: .indexedAt)
    }

    enum CodingKeys: String, CodingKey {
        case atURI = "uri"
        case cidHash = "cid"
        case name = "name"
        case purpose = "purpose"
        case avatar
        case viewer = "viewer"
        case indexedAt
    }
}

public struct ListView: Codable {
    public let atURI: String
    public let cidHash: String
    public let creator: ProfileView
    public let name: String
    public let purpose: ListPurpose
    public var description: String? = nil
    public var descriptionFacets: [Facet]? = nil
    public var avatar: String? = nil
    public var viewer: ListViewerState? = nil
    @DateFormatting public var indexedAt: Date

    public init(atURI: String, cidHash: String, creator: ProfileView, name: String, purpose: ListPurpose, description: String?, descriptionFacets: [Facet]?, avatar: String?, viewer: ListViewerState?, indexedAt: Date) {
        self.atURI = atURI
        self.cidHash = cidHash
        self.creator = creator
        self.name = name
        self.purpose = purpose
        self.description = description
        self.descriptionFacets = descriptionFacets
        self.avatar = avatar
        self.viewer = viewer
        self._indexedAt = DateFormatting(wrappedValue: indexedAt)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.atURI = try container.decode(String.self, forKey: .atURI)
        self.cidHash = try container.decode(String.self, forKey: .cidHash)
        self.creator = try container.decode(ProfileView.self, forKey: .creator)
        self.name = try container.decode(String.self, forKey: .name)
        self.purpose = try container.decode(ListPurpose.self, forKey: .purpose)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.descriptionFacets = try container.decodeIfPresent([Facet].self, forKey: .descriptionFacets)
        self.avatar = try container.decodeIfPresent(String.self, forKey: .avatar)
        self.viewer = try container.decodeIfPresent(ListViewerState.self, forKey: .viewer)
        self.indexedAt = try container.decode(DateFormatting.self, forKey: .indexedAt).wrappedValue
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.atURI, forKey: .atURI)
        try container.encode(self.cidHash, forKey: .cidHash)
        try container.encode(self.creator, forKey: .creator)

        // Truncate `name` to 64 characters and check for non-emptiness
        let truncatedName = String(self.name.prefix(64))
        guard !truncatedName.isEmpty else {
            // Handle the case where name is empty after truncation
            // For now, throw an error
            throw EncodingError.invalidValue(self.name, EncodingError.Context(codingPath: [CodingKeys.name], debugDescription: "Name cannot be empty"))
        }

        try container.encode(truncatedName, forKey: .name)
        try container.encode(self.purpose, forKey: .purpose)

        // Truncate `description` to 3000 characters before encoding
        // `maxGraphemes`'s limit is 300, but `String.count` should respect that limit
        try truncatedEncodeIfPresent(self.description, withContainer: &container, forKey: .description, upToLength: 3000)
        try container.encodeIfPresent(self.descriptionFacets, forKey: .descriptionFacets)
        try container.encodeIfPresent(self.avatar, forKey: .avatar)
        try container.encodeIfPresent(self.viewer, forKey: .viewer)
        try container.encode(self._indexedAt, forKey: .indexedAt)
    }

    enum CodingKeys: String, CodingKey {
        case atURI = "uri"
        case cidHash = "cid"
        case creator = "creator"
        case name = "name"
        case purpose = "purpose"
        case description = "description"
        case descriptionFacets = "descriptionFacets"
        case avatar = "avatar"
        case viewer = "viewer"
        case indexedAt = "indexedAt"
    }
}

public struct ListItemView: Codable {
    public let atURI: String
    public let subject: ProfileView

    enum CodingKeys: String, CodingKey {
        case atURI = "uri"
        case subject
    }
}

public enum ListPurpose: String, Codable {
    /// A list of actors to apply an aggregate moderation action (mute/block) on.
    case modlist = "app.bsky.graph.defs#modlist"

    /// A list of actors used for curation purposes such as list feeds or interaction gating.
    case curatelist = "app.bsky.graph.defs#curatelist"
}


public struct ListViewerState: Codable {
    public var isMuted: Bool? = nil
    public var blocked: String? = nil

    enum CodingKeys: String, CodingKey {
        case isMuted = "muted"
        case blocked = "blocked"
    }
}

public struct NotFoundActor: Codable {
    public let actor: String
    public let isNotFound: Bool

    enum CodingKeys: String, CodingKey {
        case actor
        case isNotFound = "notFound"
    }
}

public struct GraphRelationship: Codable {
    public let atDID: String
    public let following: String?
    public let followedBy: String?

    enum CodingKeys: String, CodingKey {
        case atDID = "did"
        case following
        case followedBy
    }
}
