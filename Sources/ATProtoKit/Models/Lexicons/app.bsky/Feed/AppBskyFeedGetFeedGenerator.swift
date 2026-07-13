//
//  AppBskyFeedGetFeedGenerator.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-18.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Feed {

    /// An output model for getting information about a given feed generator.
    ///
    /// - Note: According to the AT Protocol specifications: "Get information about a feed
    /// generator. Implemented by AppView."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.getFeedGenerator`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/getFeedGenerator.json
    public struct GetFeedGeneratorOutput: Sendable, Codable {

        /// The general information about the feed generator.
        public let view: GeneratorViewDefinition

        /// Indicates whether the feed generator is currently online.
        ///
        /// - Note: According to the AT Protocol specifications: "Indicates whether the
        /// feed generator service has been online recently, or else seems to be inactive."
        public let isOnline: Bool

        /// Indicates whether the feed generator is compatible with the record declaration.
        ///
        /// - Note: According to the AT Protocol specifications: "Indicates whether the
        /// feed generator service is compatible with the record declaration."
        public let isValid: Bool
        
        public init(view: GeneratorViewDefinition, isOnline: Bool, isValid: Bool) {
            self.view = view
            self.isOnline = isOnline
            self.isValid = isValid
        }
        
        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.view = try container.decode(AppBskyLexicon.Feed.GeneratorViewDefinition.self, forKey: .view)
            self.isOnline = try container.decode(Bool.self, forKey: .isOnline)
            self.isValid = try container.decode(Bool.self, forKey: .isValid)
        }
        
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(self.view, forKey: .view)
            try container.encode(self.isOnline, forKey: .isOnline)
            try container.encode(self.isValid, forKey: .isValid)
        }
        
        enum CodingKeys: CodingKey {
            case view
            case isOnline
            case isValid
        }
    }
}
