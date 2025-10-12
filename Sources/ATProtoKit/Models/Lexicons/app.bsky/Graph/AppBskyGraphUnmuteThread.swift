//
//  AppBskyGraphUnmuteThread.swift
//
//
//  Created by Christopher Jr Riley on 2024-06-16.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Graph {

    /// A request body model for unmuting a thread.
    ///
    /// - Note: According to the AT Protocol specifications: ""Unmutes the specified thread.
    /// Requires auth"
    ///
    /// - SeeAlso: This is based on the [`app.bsky.graph.unmuteThread`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/unmuteThread.json
    public struct UnmuteThreadRequestBody: Sendable, Codable {

        /// The URI of the root of the post.
        public let rootURI: String
        
        public init(rootURI: String) {
            self.rootURI = rootURI
        }
        
        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.rootURI = try container.decode(String.self, forKey: CodingKeys.rootURI)
        }
        
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(self.rootURI, forKey: CodingKeys.rootURI)
        }
        
        public enum CodingKeys: String, CodingKey {
            case rootURI = "root"
        }
    }
}
