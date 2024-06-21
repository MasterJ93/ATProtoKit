//
//  AppBskyRichTextFacet.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension AppBskyLexicon.RichText {
    
    /// The main data model definition for a facet.
    ///
    /// - Note: According to the AT Protocol specifications: "Annotation of a sub-string within
    /// rich text."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.richtext.facet`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/richtext/facet.json
    public struct Facet: Codable {
        
        /// The range of characters related to the facet.
        public let index: ByteSlice
        
        /// The facet's feature type.
        public let features: [ATUnion.FacetFeatureUnion]
        
        public init(index: ByteSlice, features: [ATUnion.FacetFeatureUnion]) {
            self.index = index
            self.features = features
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            self.index = try container.decode(ByteSlice.self, forKey: .index)
            self.features = try container.decode([ATUnion.FacetFeatureUnion].self, forKey: .features)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(self.index, forKey: .index)
            try container.encode(self.features, forKey: .features)
        }
        
        enum CodingKeys: String, CodingKey {
            case index
            case features
        }
        
        // Enums
        // Represents the ByteSlice
        /// The data model definition for the byte slice.
        ///
        /// - Note: According to the AT Protocol specifications: "Specifies the sub-string range a
        /// facet feature applies to. Start index is inclusive, end index is exclusive. Indices are
        /// zero-indexed, counting bytes of the UTF-8 encoded text. NOTE: some languages, like
        /// Javascript, use UTF-16 or Unicode codepoints for string slice indexing; in these
        /// languages, convert to byte arrays before working with facets."
        ///
        /// - SeeAlso: This is based on the [`app.bsky.richtext.facet`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/richtext/facet.json
        public struct ByteSlice: Codable {
            
            /// The start index of the byte slice.
            public let byteStart: Int
            
            /// The end index of the byte slice.
            public let byteEnd: Int
            
            public init(byteStart: Int, byteEnd: Int) {
                self.byteStart = byteStart
                self.byteEnd = byteEnd
            }
            
            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                
                self.byteStart = try container.decode(Int.self, forKey: .byteStart)
                self.byteEnd = try container.decode(Int.self, forKey: .byteEnd)
            }
            
            public func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                
                try container.encode(self.byteStart, forKey: .byteStart)
                try container.encode(self.byteEnd, forKey: .byteEnd)
            }
            
            enum CodingKeys: String, CodingKey {
                case byteStart
                case byteEnd
            }
        }
        
        /// A data model for the Mention feature definition.
        ///
        /// - Note: According to the AT Protocol specifications: "Facet feature for mention of
        /// another account. The text is usually a handle, including a '@' prefix, but the facet
        /// reference is a DID."
        ///
        /// - SeeAlso: This is based on the [`app.bsky.richtext.facet`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/richtext/facet.json
        public struct Mention: FeatureCodable {
            
            /// The identifier of the lexicon.
            ///
            /// - Warning: The value must not change.
            public static let type: String = "app.bsky.richtext.facet#mention"

            /// The decentralized identifier (DID) of the feature.
            public let did: String
            
            public init(did: String) {
                self.did = did
            }
            
            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                
                self.did = try container.decode(String.self, forKey: .did)
            }
            
            public func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                
                try container.encode(self.did, forKey: .did)
                try container.encode(Mention.type, forKey: .type)
            }
            
            enum CodingKeys: String, CodingKey {
                case type = "$type"
                case did
            }
        }
        
        /// A data model for the Link feature definition.
        ///
        /// - Note: According to the AT Protocol specifications: "Facet feature for a URL. The text URL
        /// may have been simplified or truncated, but the facet reference should be a complete URL."
        ///
        /// - SeeAlso: This is based on the [`app.bsky.richtext.facet`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/richtext/facet.json
        public struct Link: FeatureCodable {
            
            /// The identifier of the lexicon.
            ///
            /// - Warning: The value must not change.
            public static let type: String = "app.bsky.richtext.facet#link"
            
            /// The URI of the feature.
            public let uri: String
            
            public init(uri: String) {
                self.uri = uri
            }
            
            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                
                self.uri = try container.decode(String.self, forKey: .uri)
            }
            
            public func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                
                try container.encode(self.uri, forKey: .uri)
                try container.encode(Link.type, forKey: .type)
            }
            
            enum CodingKeys: String, CodingKey {
                case type = "$type"
                case uri
            }
        }
        
        /// A data model for the Tag feature definition.
        ///
        /// - Note: According to the AT Protocol specifications: "Facet feature for a hashtag. The text
        /// usually includes a '#' prefix, but the facet reference should not (except in the case of
        /// 'double hash tags')."
        ///
        /// - SeeAlso: This is based on the [`app.bsky.richtext.facet`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/richtext/facet.json
        public struct Tag: FeatureCodable {
            
            /// The identifier of the lexicon.
            ///
            /// - Warning: The value must not change.
            public static let type: String = "app.bsky.richtext.facet#tag"

            /// The name of the tag.
            public let tag: String
            
            public init(tag: String) {
                self.tag = tag
            }
            
            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                
                self.tag = try container.decode(String.self, forKey: .tag)
            }
            
            public func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                
                try container.encode(self.tag, forKey: .tag)
                try container.encode(Tag.type, forKey: .type)
            }
            
            enum CodingKeys: String, CodingKey {
                case type = "$type"
                case tag
            }
        }
    }
}
