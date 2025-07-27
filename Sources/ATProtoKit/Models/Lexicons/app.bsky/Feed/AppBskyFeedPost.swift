//
//  AppBskyFeedPost.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Feed {

    /// The record model definition for a post record.
    ///
    /// - Note: According to the AT Protocol specifications: "Record containing a Bluesky post."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.post`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/post.json
    public struct PostRecord: ATRecordProtocol, Sendable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public static let type: String = "app.bsky.feed.post"

        /// The text contained in the post.
        ///
        /// - Note: According to the AT Protocol specifications: "The primary post content. May be
        /// an empty string, if there are embeds."
        ///
        /// - Important: Current maximum length is 300 characters. This library will automatically
        /// truncate the `String` to the maximum length if it does go over the limit.
        public let text: String

        /// An array of facets contained in the post's text. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Annotations of text (mentions, URLs,
        /// hashtags, etc)"
        public var facets: [AppBskyLexicon.RichText.Facet]?

        /// The references to posts when replying. Optional.
        public var reply: ReplyReference?

        /// The embed of the post. Optional.
        public var embed: EmbedUnion?

        /// An array of languages the post text contains. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Indicates human language of post
        /// primary text content."
        ///
        /// - Important: Current maximum length is 3 languages. This library will automatically
        /// truncate the `Array` to the maximum number of items if it does go over the limit.
        public var languages: [String]?

        /// An array of user-defined labels. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Self-label values for this post.
        /// Effectively content warnings."
        public var labels: LabelsUnion?

        /// An array of user-defined tags. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Additional hashtags, in addition to
        /// any included in post text and facets."
        ///
        /// - Important: Current maximum length is 8 tags. Current maximum length of the tag name
        /// is 64 characters. This library will automatically truncate the `Array`and `String`
        /// respectively to the maximum length if it does go over the limit.
        public var tags: [String]?

        /// The date the post was created.
        ///
        /// - Note: According to the AT Protocol specifications: "Client-declared timestamp when this
        /// post was originally created."
        public let createdAt: Date

        public init(text: String, facets: [AppBskyLexicon.RichText.Facet]?, reply: ReplyReference?, embed: EmbedUnion?, languages: [String]?,
                    labels: LabelsUnion?, tags: [String]?, createdAt: Date) {
            self.text = text
            self.facets = facets
            self.reply = reply
            self.embed = embed
            self.languages = languages
            self.labels = labels
            self.tags = tags
            self.createdAt = createdAt
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.text = try container.decode(String.self, forKey: .text)
            self.facets = try container.decodeIfPresent([AppBskyLexicon.RichText.Facet].self, forKey: .facets)
            self.reply = try container.decodeIfPresent(ReplyReference.self, forKey: .reply)
            self.embed = try container.decodeIfPresent(EmbedUnion.self, forKey: .embed)
            self.languages = try container.decodeIfPresent([String].self, forKey: .languages)
            self.labels = try container.decodeIfPresent(LabelsUnion.self, forKey: .labels)
            self.tags = try container.decodeIfPresent([String].self, forKey: .tags)
            self.createdAt = try container.decodeDate(forKey: .createdAt)
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(AppBskyLexicon.Feed.PostRecord.type, forKey: .type)
            try container.encode(self.text, forKey: .text)
            try container.truncatedEncode(self.text, forKey: .text, upToCharacterLength: 300)
            try container.encodeIfPresent(self.facets, forKey: .facets)
            try container.encodeIfPresent(self.reply, forKey: .reply)
            try container.encodeIfPresent(self.embed, forKey: .embed)
            try container.truncatedEncodeIfPresent(self.languages, forKey: .languages, upToArrayLength: 3)
            try container.encodeIfPresent(self.labels, forKey: .labels)
            try container.truncatedEncodeIfPresent(self.tags, forKey: .tags, upToCharacterLength: 64, upToArrayLength: 8)
            try container.encodeDate(self.createdAt, forKey: .createdAt)
        }

        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case text
            case entities
            case facets
            case reply
            case embed
            case languages = "langs"
            case labels
            case tags
            case createdAt
        }

        // Enums
        /// A data model for a reply reference definition.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.feed.post`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/post.json
        public struct ReplyReference: Sendable, Codable, Equatable, Hashable {

            /// The original post of the thread.
            public let root: ComAtprotoLexicon.Repository.StrongReference

            /// The direct post that the user's post is replying to.
            ///
            /// - Note: If `parent` and `root` are identical, the post is a direct reply to the original
            /// post of the thread.
            public let parent: ComAtprotoLexicon.Repository.StrongReference
            
            public init(root: ComAtprotoLexicon.Repository.StrongReference, parent: ComAtprotoLexicon.Repository.StrongReference) {
                self.root = root
                self.parent = parent
            }
            
            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.root = try container.decode(ComAtprotoLexicon.Repository.StrongReference.self, forKey: .root)
                self.parent = try container.decode(ComAtprotoLexicon.Repository.StrongReference.self, forKey: .parent)
            }
            
            public func encode(to encoder: any Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(self.root, forKey: .root)
                try container.encode(self.parent, forKey: .parent)
            }
            
            enum CodingKeys: String, CodingKey {
                case root
                case parent
            }
        }

        // Unions
        /// The embed of the post.
        public enum EmbedUnion: ATUnionProtocol, Equatable, Hashable {

            /// An image embed.
            case images(AppBskyLexicon.Embed.ImagesDefinition)

            /// A video embed.
            case video(AppBskyLexicon.Embed.VideoDefinition)

            /// An external embed.
            case external(AppBskyLexicon.Embed.ExternalDefinition)

            /// A record embed.
            case record(AppBskyLexicon.Embed.RecordDefinition)

            /// A embed with both a record and some compatible media.
            case recordWithMedia(AppBskyLexicon.Embed.RecordWithMediaDefinition)

            /// An unknown case.
            case unknown(String, [String: CodableValue])

            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let type = try container.decode(String.self, forKey: .type)

                switch type {
                    case "app.bsky.embed.images":
                        self = .images(try AppBskyLexicon.Embed.ImagesDefinition(from: decoder))
                    case "app.bsky.embed.video":
                        self = .video(try AppBskyLexicon.Embed.VideoDefinition(from: decoder))
                    case "app.bsky.embed.external":
                        self = .external(try AppBskyLexicon.Embed.ExternalDefinition(from: decoder))
                    case "app.bsky.embed.record":
                        self = .record(try AppBskyLexicon.Embed.RecordDefinition(from: decoder))
                    case "app.bsky.embed.recordWithMedia":
                        self = .recordWithMedia(try AppBskyLexicon.Embed.RecordWithMediaDefinition(from: decoder))
                    default:
                        let singleValueDecodingContainer = try decoder.singleValueContainer()
                        let dictionary = try Self.decodeDictionary(from: singleValueDecodingContainer, decoder: decoder)

                        self = .unknown(type, dictionary)
                }
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)

                switch self {
                    case .images(let imagesValue):
                        try container.encode("app.bsky.embed.images", forKey: .type)
                        try imagesValue.encode(to: encoder)
                    case .video(let value):
                        try container.encode("app.bsky.embed.video", forKey: .type)
                        try value.encode(to: encoder)
                    case .external(let externalValue):
                        try container.encode("app.bsky.embed.external", forKey: .type)
                        try externalValue.encode(to: encoder)
                    case .record(let recordValue):
                        try container.encode("app.bsky.embed.record", forKey: .type)
                        try recordValue.encode(to: encoder)
                    case .recordWithMedia(let recordWithMediaValue):
                        try container.encode("app.bsky.embed.recordWithMedia", forKey: .type)
                        try recordWithMediaValue.encode(to: encoder)
                    default:
                        break
                }
            }

            enum CodingKeys: String, CodingKey {
                case type = "$type"
            }
        }

        /// An array of user-defined labels.
        public enum LabelsUnion: ATUnionProtocol, Equatable, Hashable {

            /// An array of user-defined labels.
            case selfLabels(ComAtprotoLexicon.Label.SelfLabelsDefinition)

            /// An unknown case.
            case unknown(String, [String: CodableValue])

            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let type = try container.decode(String.self, forKey: .type)

                switch type {
                    case "com.atproto.label.defs#selfLabels":
                        self = .selfLabels(try ComAtprotoLexicon.Label.SelfLabelsDefinition(from: decoder))
                    default:
                        let singleValueDecodingContainer = try decoder.singleValueContainer()
                        let dictionary = try Self.decodeDictionary(from: singleValueDecodingContainer, decoder: decoder)

                        self = .unknown(type, dictionary)
                }
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)

                switch self {
                    case .selfLabels(let value):
                        try container.encode("com.atproto.label.defs#selfLabels", forKey: .type)
                        try value.encode(to: encoder)
                    default:
                        break
                }
            }

            enum CodingKeys: String, CodingKey {
                case type = "$type"
            }
        }
    }
}
