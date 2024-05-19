//
//  AppBskyFeedPost.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension AppBskyLexicon.Feed {

    /// The record model definition for a post record.
    ///
    /// - Note: According to the AT Protocol specifications: "Record containing a Bluesky post."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.post`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/post.json
    public struct PostRecord: ATRecordProtocol {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public static private(set) var type: String = "app.bsky.feed.post"

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
        public var reply: PostReplyReference?
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
        public var labels: FeedLabelUnion?
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
        @DateFormatting public var createdAt: Date
        
        public init(text: String, facets: [AppBskyLexicon.RichText.Facet]?, reply: PostReplyReference?, embed: EmbedUnion?, languages: [String]?,
                    labels: FeedLabelUnion?, tags: [String]?, createdAt: Date) {
            self.text = text
            self.facets = facets
            self.reply = reply
            self.embed = embed
            self.languages = languages
            self.labels = labels
            self.tags = tags
            self._createdAt = DateFormatting(wrappedValue: createdAt)
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            self.text = try container.decode(String.self, forKey: .text)
            self.facets = try container.decodeIfPresent([AppBskyLexicon.RichText.Facet].self, forKey: .facets)
            self.reply = try container.decodeIfPresent(PostReplyReference.self, forKey: .reply)
            self.embed = try container.decodeIfPresent(EmbedUnion.self, forKey: .embed)
            self.languages = try container.decodeIfPresent([String].self, forKey: .languages)
            self.labels = try container.decodeIfPresent(FeedLabelUnion.self, forKey: .labels)
            self.tags = try container.decodeIfPresent([String].self, forKey: .tags)
            self.createdAt = try container.decode(DateFormatting.self, forKey: .createdAt).wrappedValue
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            //        try container.encode(self.type, forKey: .type)
            try container.encode(self.text, forKey: .text)
            // Truncate `tags` to 3000 characters before encoding
            // `maxGraphemes`'s limit is 300, but `String.count` should respect that limit implictly
            try truncatedEncode(self.text, withContainer: &container, forKey: .text, upToLength: 300)
            try container.encodeIfPresent(self.facets, forKey: .facets)
            try container.encodeIfPresent(self.reply, forKey: .reply)
            try container.encodeIfPresent(self.embed, forKey: .embed)
            // Truncate `langs` to 3 items before encoding.
            try truncatedEncodeIfPresent(self.languages, withContainer: &container, forKey: .languages, upToLength: 3)
            try container.encodeIfPresent(self.labels, forKey: .labels)
            
            // Truncate `tags` to 640 characters before encoding
            // `maxGraphemes`'s limit is 64, but `String.count` should respect that limit implictly
            // Then, truncate `tags` to 8 items before encoding
            try truncatedEncodeIfPresent(
                self.tags.map { $0.truncated(toLength: 640) },
                withContainer: &container, forKey: .tags, upToLength: 8)
            
            try container.encode(self._createdAt, forKey: .createdAt)
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
    }
    
    // MARK: -
    /// A data model for a reply reference definition.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.post`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/post.json
    public struct PostReplyReference: Codable {
        /// The original post of the thread.
        public let root: StrongReference
        /// The direct post that the user's post is replying to.
        ///
        /// - Note: If `parent` and `root` are identical, the post is a direct reply to the original
        /// post of the thread.
        public let parent: StrongReference
        
        public init(root: StrongReference, parent: StrongReference) {
            self.root = root
            self.parent = parent
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            self.root = try container.decode(StrongReference.self, forKey: .root)
            self.parent = try container.decode(StrongReference.self, forKey: .parent)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(self.root, forKey: .root)
            try container.encode(self.parent, forKey: .parent)
        }
        
        enum CodingKeys: CodingKey {
            case root
            case parent
        }
    }
}
