//
//  AppBskyGraphMuteThread.swift
//
//
//  Created by Christopher Jr Riley on 2024-06-16.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Graph {

    /// A request body model for muting a thread.
    ///
    /// - Note: According to the AT Protocol specifications: "Mutes a thread preventing
    /// notifications from the thread and any of its children. Mutes are private in Bluesky.
    /// Requires auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.graph.muteThread`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/muteThread.json
    public struct MuteThreadRequestBody: Sendable, Codable {

        /// The URI of the root of the post.
        public let root: String
    }
}
