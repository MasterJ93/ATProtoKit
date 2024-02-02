//
//  File.swift
//  
//
//  Created by Christopher Jr Riley on 2024-01-25.
//

import Foundation

public struct PostView: Codable {
    public let atURI: String
    public let cidHash: String
    public let author: ProfileViewBasic
    public let record: UnknownType
    public var embed: EmbedViewUnion? = nil
    public var replyCount: Int? = nil
    public var repostCount: Int? = nil
    public var likeCount: Int? = nil
    @DateFormatting public var indexedAt: Date
    public var viewer: FeedViewerState? = nil
    public var labels: [Label]? = nil
    public var threadgate: ThreadgateView? = nil

    public init(atURI: String, cidHash: String, author: ProfileViewBasic, record: UnknownType, embed: EmbedViewUnion?, replyCount: Int?, repostCount: Int?, likeCount: Int?, indexedAt: Date, viewer: FeedViewerState?, labels: [Label]?, threadgate: ThreadgateView?) {
        self.atURI = atURI
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

        self.atURI = try container.decode(String.self, forKey: .atURI)
        self.cidHash = try container.decode(String.self, forKey: .cidHash)
        self.author = try container.decode(ProfileViewBasic.self, forKey: .author)
        self.record = try container.decode(UnknownType.self, forKey: .record)
        self.embed = try container.decodeIfPresent(EmbedViewUnion.self, forKey: .embed)
        self.replyCount = try container.decodeIfPresent(Int.self, forKey: .replyCount)
        self.repostCount = try container.decodeIfPresent(Int.self, forKey: .repostCount)
        self.likeCount = try container.decodeIfPresent(Int.self, forKey: .likeCount)
        self.indexedAt = try container.decode(DateFormatting.self, forKey: .indexedAt).wrappedValue
        self.viewer = try container.decodeIfPresent(FeedViewerState.self, forKey: .viewer)
        self.labels = try container.decodeIfPresent([Label].self, forKey: .labels)
        self.threadgate = try container.decodeIfPresent(ThreadgateView.self, forKey: .threadgate)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.atURI, forKey: .atURI)
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
        case atURI = "uri"
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

public struct FeedViewerState: Codable {
    public let repost: String? = nil
    public let like: String? = nil
    public let areReplyDisabled: Bool? = nil

    enum CodingKeys: String, CodingKey {
        case repost
        case like
        case areReplyDisabled = "replyDisabled"
    }
}

public struct FeedViewPost: Codable {
    public let post: PostView
    public var reply: FeedReplyReference? = nil
    public var reason: ReasonRepost? = nil
}

public struct FeedReplyReference: Codable {
    public let root: PostUnion
    public let parent: PostUnion
}

public struct ReasonRepost: Codable {
    public let by: ProfileViewBasic
    @DateFormatting public var indexedAt: Date

    public init(by: ProfileViewBasic, indexedAt: Date) {
        self.by = by
        self._indexedAt = DateFormatting(wrappedValue: indexedAt)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.by = try container.decode(ProfileViewBasic.self, forKey: .by)
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

public struct ThreadViewPost: Codable {
    public let post: PostView
    public var parent: PostUnion? = nil
    public var replies: [PostUnion]? = nil
}

public struct NotFoundPost: Codable {
    public let atURI: String
    public private(set) var isNotFound: Bool = true

    public init(atURI: String, isNotFound: Bool = true) {
        self.atURI = atURI
        self.isNotFound = isNotFound
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        atURI = try container.decode(String.self, forKey: .atURI)
        isNotFound = (try? container.decodeIfPresent(Bool.self, forKey: .isNotFound)) ?? true
    }

    enum CodingKeys: String, CodingKey {
        case atURI = "uri"
        case isNotFound = "notFound"
    }
}

public struct BlockedPost: Codable {
    public let atURI: String
    public private(set) var isBlocked: Bool = true
    public let author: BlockedAuthor

    public init(atURI: String, isBlocked: Bool = true, author: BlockedAuthor) {
        self.atURI = atURI
        self.isBlocked = isBlocked
        self.author = author
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.atURI = try container.decode(String.self, forKey: .atURI)
        self.isBlocked = (try? container.decode(Bool.self, forKey: .isBlocked)) ?? true
        self.author = try container.decode(BlockedAuthor.self, forKey: .author)
    }

    enum CodingKeys: String, CodingKey {
        case atURI = "uri"
        case isBlocked = "blocked"
        case author
    }
}

public struct BlockedAuthor: Codable {
    public let atDID: String
    public var viewer: ActorViewerState? = nil
}

public struct GeneratorView: Codable {
    public let atURI: String
    public let cidHash: String
    public let atDID: String
    public let creator: ProfileView
    public let displayName: String
    public let description: String? = nil
    public let descriptionFacets: [Facet]
    public let avatar: String? = nil
    public let likeCount: Int? = nil
    public var viewer: GeneratorViewerState? = nil
    @DateFormatting public var indexedAt: Date

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.atURI = try container.decode(String.self, forKey: .atURI)
        self.cidHash = try container.decode(String.self, forKey: .cidHash)
        self.atDID = try container.decode(String.self, forKey: .atDID)
        self.creator = try container.decode(ProfileView.self, forKey: .creator)
        self.displayName = try container.decode(String.self, forKey: .displayName)
        self.descriptionFacets = try container.decode([Facet].self, forKey: .descriptionFacets)
        self.viewer = try container.decodeIfPresent(GeneratorViewerState.self, forKey: .viewer)
        self.indexedAt = try container.decode(DateFormatting.self, forKey: .indexedAt).wrappedValue
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.atURI, forKey: .atURI)
        try container.encode(self.cidHash, forKey: .cidHash)
        try container.encode(self.atDID, forKey: .atDID)
        try container.encode(self.creator, forKey: .creator)
        try container.encode(self.displayName, forKey: .displayName)

        // Truncate `description` to 3000 characters before encoding
        // `maxGraphemes`'s limit is 300, but `String.count` should respect that limit
        try truncatedEncodeIfPresent(self.description, withContainer: &container, forKey: .displayName, upToLength: 3000)

        try container.encode(self.descriptionFacets, forKey: .descriptionFacets)
        try container.encodeIfPresent(self.avatar, forKey: .avatar)

        // Assuming `likeCount` is not nil, only encode it if it's 0 or higher
        if let likeCount = self.likeCount, likeCount >= 0 {
            try container.encode(likeCount, forKey: .likeCount)
        }
        try container.encodeIfPresent(self.viewer, forKey: .viewer)
        try container.encode(self._indexedAt, forKey: .indexedAt)
    }

    enum CodingKeys: String, CodingKey {
        case atURI = "uri"
        case cidHash = "cid"
        case atDID = "did"
        case creator
        case displayName
        case description
        case descriptionFacets = "descriptionFacets"
        case avatar
        case likeCount = "likeCount"
        case viewer
        case indexedAt
    }
}

public struct GeneratorViewerState: Codable {
    public var like: String? = nil
}

public struct SkeletonFeedPost: Codable {
    public let post: String
    public var reason: SkeletonReasonRepost? = nil
}

public struct SkeletonReasonRepost: Codable {
    public let repost: String
}

public struct ThreadgateView: Codable {
    public let atURI: String
    public let cidHash: String
    public let record: UnknownType
    public let lists: [ListViewBasic]

    enum CodingKeys: String, CodingKey {
        case atURI = "uri"
        case cidHash = "cid"
        case record = "record"
        case lists = "lists"
    }
}

public enum EmbedViewUnion: Codable {
    case embedExternalView(EmbedExternalView)
    case embedImagesView(EmbedImagesView)
    case embedRecordView(EmbedRecordView)
    case embedRecordWithMediaView(EmbedRecordWithMediaView)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let value = try? container.decode(EmbedExternalView.self) {
            self = .embedExternalView(value)
        } else if let value = try? container.decode(EmbedImagesView.self) {
            self = .embedImagesView(value)
        } else if let value = try? container.decode(EmbedRecordView.self) {
            self = .embedRecordView(value)
        } else if let value = try? container.decode(EmbedRecordWithMediaView.self) {
            self = .embedRecordWithMediaView(value)
        } else {
            throw DecodingError.typeMismatch(EmbedViewUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unknown EmbedView type"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
            case .embedExternalView(let embedView):
                try container.encode(embedView)
            case .embedImagesView(let embedView):
                try container.encode(embedView)
            case .embedRecordView(let embedView):
                try container.encode(embedView)
            case .embedRecordWithMediaView(let embedView):
                try container.encode(embedView)
        }
    }
}

public enum PostUnion: Codable {
    case postView(PostView)
    case notFoundPost(NotFoundPost)
    case blockedPost(BlockedPost)

    // Custom coding keys and init(from:) / encode(to:) will be needed here for Codable conformance.
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let value = try? container.decode(PostView.self) {
            self = .postView(value)
        } else if let value = try? container.decode(NotFoundPost.self) {
            self = .notFoundPost(value)
        } else if let value = try? container.decode(BlockedPost.self) {
            self = .blockedPost(value)
        } else {
            throw DecodingError.typeMismatch(PostUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unknown PostUnion type"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
            case .postView(let union):
                try container.encode(union)
            case .notFoundPost(let union):
                try container.encode(union)
            case .blockedPost(let union):
                try container.encode(union)
        }
    }
}
