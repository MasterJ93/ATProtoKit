//
//  AppBskyGraphUnmuteThread.swift
//
//
//  Created by Christopher Jr Riley on 2024-06-16.
//

import Foundation

extension AppBskyLexicon.Graph {

    /// A request body model for unmuting a thread.
    ///
    /// - Note: According to the AT Protocol specifications: ""Unmutes the specified thread.
    /// Requires auth"
    ///
    /// - SeeAlso: This is based on the [`app.bsky.graph.unmuteThread`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/unmuteThread.json
    public struct UnmuteThreadRequestBody: Codable {

        /// The URI of the root of the post.
        public let root: String
    }
}
