//
//  AppBskyDraftDefs.swift
//  ATProtoKit
//
//  Created by Casey Handley on 2026-09-06.
//

import Foundation

extension AppBskyLexicon.Draft {
    
    /// A draft with an identifier, used to store drafts in private storage (stash).
    ///
    /// - SeeAlso: This is based on the [`app.bsky.draft.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/draft/defs.json
    public struct DraftWithIdDefinition: Sendable, Codable, Equatable, Hashable {
        
        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public static let type: String = "app.bsky.drafts.defs#draftWithId"
        
        /// A TID to be used as a draft identifier.
        public let tid: String
        
        /// The draft containing an array of draft posts.
        public let draft: DraftDefinition
        
        public init(tid: String, draft: DraftDefinition) {
            self.tid = tid
            self.draft = draft
        }
        
        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.tid = try container.decode(String.self, forKey: .tid)
            self.draft = try container.decode(DraftDefinition.self, forKey: .draft)
        }
        
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(Self.type, forKey: .type)
            try container.encode(self.tid, forKey: .tid)
            try container.encode(self.draft, forKey: .draft)
        }
        
        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case tid = "id"
            case draft
        }
        
    }
    
    /// A draft containing an array of draft posts.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.draft.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/draft/defs.json
    public struct DraftDefinition: Sendable, Codable, Equatable, Hashable {
        
        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public static let type: String = "app.bsky.drafts.defs#draft"
        
        /// UUIDv4 identifier of the device that created this draft. Optional.
        ///
        /// - Important: Current maximum length is 100 characters.
        public let deviceID: String?
        
        /// The device and/or platform on which the draft was created. Optional.
        ///
        /// - Important: Current maximum length is 100 characters.
        public let deviceName: String?
        
        /// Array of draft posts that compose this draft.
        ///
        /// - Important: Must be between 1 and 100 posts.
        public let posts: [DraftPostDefinition]
        
        /// Indicates human language of posts primary text content. Optional.
        ///
        /// - Important: Current maximum is 3 languages.
        public let languages: [String]?
        
        /// Embedding rules for the postgates to be created when this draft is published. Optional.
        ///
        /// - Important: Current maximum is 5 embedding rules.
        public let postgateEmbeddingRules: [PostgateEmbeddingUnion]?
        
        /// Allow-rules for the threadgate to be created when this draft is published. Optional.
        ///
        /// - Important: Current maximum is 5 allow-rules.
        public let threadgateAllow: [ThreadgateAllowUnion]?
        
        public init(deviceID: String? = nil, deviceName: String? = nil, posts: [DraftPostDefinition], languages: [String]? = nil, postgateEmbeddingRules: [PostgateEmbeddingUnion]? = nil, threadgateAllow: [ThreadgateAllowUnion]? = nil) {
            self.deviceID = deviceID
            self.deviceName = deviceName
            self.posts = posts
            self.languages = languages
            self.postgateEmbeddingRules = postgateEmbeddingRules
            self.threadgateAllow = threadgateAllow
        }
        
        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.deviceID = try container.decodeIfPresent(String.self, forKey: .deviceID)
            self.deviceName = try container.decodeIfPresent(String.self, forKey: .deviceName)
            self.posts = try container.decode([DraftPostDefinition].self, forKey: .posts)
            self.languages = try container.decodeIfPresent([String].self, forKey: .languages)
            self.postgateEmbeddingRules = try container.decodeIfPresent([PostgateEmbeddingUnion].self, forKey: .postgateEmbeddingRules)
            self.threadgateAllow = try container.decodeIfPresent([ThreadgateAllowUnion].self, forKey: .threadgateAllow)
        }
        
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(Self.type, forKey: .type)
            try container.encodeIfPresent(self.deviceID, forKey: .deviceID)
            try container.encodeIfPresent(self.deviceName, forKey: .deviceName)
            try container.encode(self.posts, forKey: .posts)
        }
        
        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case deviceID = "deviceId"
            case deviceName
            case posts
            case languages = "langs"
            case postgateEmbeddingRules
            case threadgateAllow
        }
        
        // Unions
        /// The embedding rules for the postgates that are created when this draft is published.
        public enum PostgateEmbeddingUnion: ATUnionProtocol, Equatable, Hashable {
            
            /// The disable rule of a postgate
            case postgateDisableRule(AppBskyLexicon.Feed.PostgateRecord.DisableRule)
            
            // An unknown case.
            case unknown(String, [String: CodableValue])
            
            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let type = try container.decodeIfPresent(String.self, forKey: .type)
                
                switch type {
                    case "app.bsky.feed.postgate#disableRule":
                        self = .postgateDisableRule(try AppBskyLexicon.Feed.PostgateRecord.DisableRule(from: decoder))
                    default:
                    let singleVaalueDecodedContainer = try decoder.singleValueContainer()
                    let dictionary = try Self.decodeDictionary(from: singleVaalueDecodedContainer, decoder: decoder)
                    
                    self = .unknown(type ?? "unknown", dictionary)
                }
            }
            
            public func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()
                
                switch self {
                    case .postgateDisableRule(let value):
                        try container.encode(value)
                    default:
                        break
                }
            }
            
            enum CodingKeys: String, CodingKey {
                case type = "$type"
            }
            
        }
        
        /// The allow rules for the threadgate that is created when this draft is published.
        public enum ThreadgateAllowUnion: ATUnionProtocol, Equatable, Hashable {
            
            /// The mention rule of a threadgate.
            case threadgateMentionRule(AppBskyLexicon.Feed.ThreadgateRecord.MentionRule)
            
            /// The follower rule of a threadgate.
            case threadgateFollowerRule(AppBskyLexicon.Feed.ThreadgateRecord.FollowerRule)
            
            /// The following rule of a threadgate.
            case threadgateFollowingRule(AppBskyLexicon.Feed.ThreadgateRecord.FollowingRule)
            
            /// The list rule of a threadgate.
            case threadgateListRule(AppBskyLexicon.Feed.ThreadgateRecord.ListRule)
            
            /// An unknown case.
            case unknown(String, [String: CodableValue])
            
            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let type = try container.decodeIfPresent(String.self, forKey: .type)
                
                switch type {
                    case "app.bsky.feed.threadgate#mentionRule":
                        self = .threadgateMentionRule(try AppBskyLexicon.Feed.ThreadgateRecord.MentionRule(from: decoder))
                    case "app.bsky.feed.threadgate#followerRule":
                        self = .threadgateFollowerRule(try AppBskyLexicon.Feed.ThreadgateRecord.FollowerRule(from: decoder))
                    case "app.bsky.feed.threadgate#followingRule":
                        self = .threadgateFollowingRule(try AppBskyLexicon.Feed.ThreadgateRecord.FollowingRule(from: decoder))
                    case "app.bsky.feed.threadgate#listRule":
                        self = .threadgateListRule(try AppBskyLexicon.Feed.ThreadgateRecord.ListRule(from: decoder))
                    default:
                        let singleValueDecodingContainer = try decoder.singleValueContainer()
                        let dictionary = try Self.decodeDictionary(from: singleValueDecodingContainer, decoder: decoder)

                        self = .unknown(type ?? "unknown", dictionary)
                }
            }
            
            public func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()
                
                switch self {
                    case .threadgateMentionRule(let value):
                        try container.encode(value)
                    case .threadgateFollowerRule(let value):
                        try container.encode(value)
                    case .threadgateFollowingRule(let value):
                        try container.encode(value)
                    case .threadgateListRule(let value):
                        try container.encode(value)
                    default:
                        break
                }
            }
            
            enum CodingKeys: String, CodingKey {
                case type = "$type"
            }
            
        }
    }
  
    /// One of the posts that compose a draft.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.draft.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/draft/defs.json
    public struct DraftPostDefinition: Sendable, Codable, Equatable, Hashable {
        
        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public static let type: String = "app.bsky.drafts.defs#draftPost"
        
        /// The primary post content.
        ///
        /// - Important: Current maximum is 10,000 characters or 1,000 graphemes.
        public let text: String
        
        /// Self-label values for this post. Effectively content warnings. Optional.
        public let labels: LabelUnion?
        
        /// The images embedded in this draft. Optional.
        ///
        /// - Important: Current maximum is 4 embedded images.
        public let embedImages: [DraftEmbedImageDefinition]?
        
        /// The gallery embedded in this draft. Optional.
        public let embedGallery: DraftEmbedGalleryDefinition?
        
        /// The videos embedded in this draft. Optional.
        ///
        /// - Important: Current maximum is 1 embedded video.
        public let embedVideos: [DraftEmbedVideoDefinition]?
        
        /// The external uris embedded in this draft. Optional.
        ///
        /// - Important: Current maximum is 1 embedded external uri.
        public let embedExternals: [DraftEmbedExternalDefinition]?
        
        /// The records embedded in this draft. Optional.
        ///
        /// - Important: Current maximum is 1 embedded record.
        public let embedRecords: [DraftEmbedRecordDefinition]?
        
        public init(text: String, labels: LabelUnion? = nil, embedImages: [DraftEmbedImageDefinition]? = nil, embedGallery: DraftEmbedGalleryDefinition? = nil, embedVideos: [DraftEmbedVideoDefinition]? = nil, embedExternals: [DraftEmbedExternalDefinition]? = nil, embedRecords: [DraftEmbedRecordDefinition]? = nil) {
            self.text = text
            self.labels = labels
            self.embedImages = embedImages
            self.embedGallery = embedGallery
            self.embedVideos = embedVideos
            self.embedExternals = embedExternals
            self.embedRecords = embedRecords
        }
        
        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            self.text = try container.decode(String.self, forKey: .text)
            self.labels = try container.decodeIfPresent(LabelUnion.self, forKey: .labels)
            self.embedImages = try container.decodeIfPresent([DraftEmbedImageDefinition].self, forKey: .embedImages)
            self.embedGallery = try container.decodeIfPresent(DraftEmbedGalleryDefinition.self, forKey: .embedGallery)
            self.embedVideos = try container.decodeIfPresent([DraftEmbedVideoDefinition].self, forKey: .embedVideos)
            self.embedExternals = try container.decodeIfPresent([DraftEmbedExternalDefinition].self, forKey: .embedExternals)
            self.embedRecords = try container.decodeIfPresent([DraftEmbedRecordDefinition].self, forKey: .embedRecords)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(Self.type, forKey: .type)
            try container.encode(self.text, forKey: .text)
            try container.encodeIfPresent(self.labels, forKey: .labels)
            try container.encodeIfPresent(self.embedImages, forKey: .embedImages)
            try container.encodeIfPresent(self.embedGallery, forKey: .embedGallery)
            try container.encodeIfPresent(self.embedVideos, forKey: .embedVideos)
            try container.encodeIfPresent(self.embedExternals, forKey: .embedExternals)
            try container.encodeIfPresent(self.embedRecords, forKey: .embedRecords)
        }
        
        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case text
            case labels
            case embedImages
            case embedGallery
            case embedVideos
            case embedExternals
            case embedRecords
        }
        
        // Unions
        /// The labels on this draft post
        public enum LabelUnion: ATUnionProtocol, Equatable, Hashable {
            
            /// The self labels of a draft post.
            case labelSelfLabels(ComAtprotoLexicon.Label.SelfLabelsDefinition)
            
            // An unknown case.
            case unknown(String, [String: CodableValue])
            
            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let type = try container.decodeIfPresent(String.self, forKey: .type)
                
                switch type {
                    case "com.atproto.label.defs#selfLabels":
                        self = .labelSelfLabels(try ComAtprotoLexicon.Label.SelfLabelsDefinition(from: decoder))
                    default:
                        let singleValueDecodingContainer = try decoder.singleValueContainer()
                        let dictionary = try Self.decodeDictionary(from: singleValueDecodingContainer, decoder: decoder)

                        self = .unknown(type ?? "unknown", dictionary)
                }
            }
            
            public func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()
                
                switch self {
                    case .labelSelfLabels(let value):
                        try container.encode(value)
                    default:
                        break
                }
            }
            
            enum CodingKeys: String, CodingKey {
                case type = "$type"
            }
        }
        
    }
    
    /// View to present drafts data to users.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.draft.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/draft/defs.json
    public struct DraftViewDefinition: Sendable, Codable, Equatable, Hashable {
        
        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public static let type: String = "app.bsky.drafts.defs#draftView"
        
        /// A TID to be used as a draft identifier.
        public let tid: String
        
        /// The draft data
        public let draft: AppBskyLexicon.Draft.DraftDefinition
        
        /// The time the draft was created.
        public let createdAt: Date
        
        /// The time the draft was last updated.
        public let updatedAt: Date
        
        public init(tid: String, draft: AppBskyLexicon.Draft.DraftDefinition, createdAt: Date, updatedAt: Date) {
            self.tid = tid
            self.draft = draft
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
        
        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            self.tid = try container.decode(String.self, forKey: .tid)
            self.draft = try container.decode(DraftDefinition.self, forKey: .draft)
            self.createdAt = try container.decodeDate(forKey: .createdAt)
            self.updatedAt = try container.decodeDate(forKey: .updatedAt)
        }
        
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(Self.type, forKey: .type)
            try container.encode(self.tid, forKey: .tid)
            try container.encode(self.draft, forKey: .draft)
            try container.encodeDate(self.createdAt, forKey: .createdAt)
            try container.encodeDate(self.updatedAt, forKey: .updatedAt)
        }
        
        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case tid = "id"
            case draft
            case createdAt
            case updatedAt
        }
    }
    
    /// A definition model for a local reference to an embed.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.draft.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/draft/defs.json
    public struct DraftEmbedLocalReferenceDefinition: Sendable, Codable, Equatable, Hashable {
        
        /// Local, on-device ref to file to be embedded. Embeds are currently device-bound for drafts.
        ///
        /// - Important: Must be between 1 and 1,024 characters.
        public let path: String
        
        public init(path: String) {
            self.path = path
        }
        
        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.path = try container.decode(String.self, forKey: .path)
        }
        
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(self.path, forKey: .path)
        }
        
        enum CodingKeys: String, CodingKey {
            case path
        }
        
    }
    
    /// A definition model for an embedded caption.
    ///
    ///  - SeeAlso:  This is based on the [`app.bsky.draft.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/draft/defs.json
    public struct DraftEmbedCaptionDefinition: Sendable, Codable, Equatable, Hashable {
        
        /// The language of the caption.
        public let language: String
        
        /// The content of the caption
        ///
        /// - Important: Current maximum is 10,000 characters.
        public let content: String
        
        public init(language: String, content: String) {
            self.language = language
            self.content = content
        }
        
        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.language = try container.decode(String.self, forKey: .language)
            self.content = try container.decode(String.self, forKey: .content)
        }
        
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(self.language, forKey: .language)
            try container.encode(self.content, forKey: .content)
        }
        
        enum CodingKeys: String, CodingKey {
            case language = "lang"
            case content
        }
        
    }
    
    /// A definition model for an embedded gallery.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.draft.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/draft/defs.json
    public struct DraftEmbedGalleryDefinition: Sendable, Codable, Equatable, Hashable {
        
        /// The items in the gallery.
        ///
        /// - Important: Current client-enforced maximum is 10 items.
        ///
        /// - Note: According to the AT Protocol specifications: "The schema-level maxLength of 20 is a future-proof ceiling. Clients should currently enforce a soft limit of 10 items in authoring UIs."
        public let items: [DraftEmbedGalleryItemUnion]
        
        public init(items: [DraftEmbedGalleryItemUnion]) {
            self.items = items
        }
        
        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.items = try container.decode([DraftEmbedGalleryItemUnion].self, forKey: .items)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(self.items, forKey: .items)
        }
        
        enum CodingKeys: String, CodingKey {
            case items
        }
        
        // Unions
        /// An item in a gallery
        public enum DraftEmbedGalleryItemUnion: ATUnionProtocol, Equatable, Hashable {
            
            /// The draft of an image embed.
            case draftEmbedImage(DraftEmbedImageDefinition)
            
            /// An unknown case.
            case unknown(String, [String: CodableValue])
            
            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let type = try container.decodeIfPresent(String.self, forKey: .type)
                
                switch type {
                    case "app.bsky.draft.defs#draftEmbedImage":
                        self = .draftEmbedImage(try DraftEmbedImageDefinition(from: decoder))
                    default:
                        let singleValueDecodingContainer = try decoder.singleValueContainer()
                        let dictionary = try Self.decodeDictionary(from: singleValueDecodingContainer, decoder: decoder)

                        self = .unknown(type ?? "unknown", dictionary)
                }
            }
            
            public func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()
                
                switch self {
                    case .draftEmbedImage(let value):
                        try container.encode(value)
                    default:
                        break
                }
            }
            
            enum CodingKeys: String, CodingKey {
                case type = "$type"
            }
        }
    }
    
    /// A definition model for an embedded image.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.draft.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/draft/defs.json
    public struct DraftEmbedImageDefinition: Sendable, Codable, Equatable, Hashable {
        
        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public static let type: String = "app.bsky.drafts.defs#draftEmbedImage"
        
        /// A reference to the image, local to the drafting device
        public let localRef: DraftEmbedLocalReferenceDefinition
        
        /// Alt-text for the image. Optional.
        ///
        /// - Important: Current maximum is 2,000 graphemes.
        public let altText: String?
        
        public init(localRef: DraftEmbedLocalReferenceDefinition, altText: String?) {
            self.localRef = localRef
            self.altText = altText
        }
        
        public init(from decoder: any Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            
            self.localRef = try values.decode(DraftEmbedLocalReferenceDefinition.self, forKey: .localRef)
            self.altText = try values.decodeIfPresent(String.self, forKey: .altText)
        }
        
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(Self.type, forKey: .type)
            try container.encode(self.localRef, forKey: .localRef)
            try container.encodeIfPresent(self.altText, forKey: .altText)
        }
        
        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case localRef
            case altText = "alt"
        }
    }
    
    /// A definition model for an embedded video.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.draft.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/draft/defs.json
    public struct DraftEmbedVideoDefinition: Sendable, Codable, Equatable, Hashable {
        
        /// A reference to the video, local to the drafting device
        public let localRef: DraftEmbedLocalReferenceDefinition
        
        /// Alt-text for the video. Optional.
        ///
        /// - Important: Current maximum is 2,000 graphemes.
        public let altText: String?
        
        /// Captions for the video. Optional.
        ///
        /// - Important: Current maximum is 20 captions.
        public let captions: [DraftEmbedCaptionDefinition]?
        
        public init(localRef: DraftEmbedLocalReferenceDefinition, altText: String?, captions: [DraftEmbedCaptionDefinition]?) {
            self.localRef = localRef
            self.altText = altText
            self.captions = captions
        }
        
        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.localRef = try container.decode(DraftEmbedLocalReferenceDefinition.self, forKey: .localRef)
            self.altText = try container.decodeIfPresent(String.self, forKey: .altText)
            self.captions = try container.decodeIfPresent([DraftEmbedCaptionDefinition].self, forKey: .captions)
        }
        
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(self.localRef, forKey: .localRef)
            try container.encodeIfPresent(self.altText, forKey: .altText)
            try container.encodeIfPresent(self.captions, forKey: .captions)
        }
        
        enum CodingKeys: String, CodingKey {
            case localRef
            case altText = "alt"
            case captions
        }
    }
    
    /// A definition model for an external embed.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.draft.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/draft/defs.json
    public struct DraftEmbedExternalDefinition: Sendable, Codable, Equatable, Hashable {
        
        /// A uri to the external embed.
        public let uri: String
        
        public init(uri: String) {
            self.uri = uri
        }
        
        public init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()
            self.uri = try container.decode(String.self)
        }
        
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(self.uri, forKey: .uri)
        }
        
        enum CodingKeys: CodingKey {
            case uri
        }
    }
    
    /// A definition model for a drafted record.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.draft.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/draft/defs.json
    public struct DraftEmbedRecordDefinition: Sendable, Codable, Equatable, Hashable {
        
        /// A strong reference to the embedded record.
        public let record: ComAtprotoLexicon.Repository.StrongReference
        
        public init(record: ComAtprotoLexicon.Repository.StrongReference) {
            self.record = record
        }
        
        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.record = try container.decode(ComAtprotoLexicon.Repository.StrongReference.self, forKey: .record)
        }
        
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(self.record, forKey: .record)
        }
        
        public enum CodingKeys: CodingKey {
            case record
        }
    }
  
}
