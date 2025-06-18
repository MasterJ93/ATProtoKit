//
//  AppBskyEmbedDefs.swift
//
//
//  Created by Christopher Jr Riley on 2024-09-15.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Embed {

    /// A definition model for an aspect ratio.
    ///
    /// - Note: From the AT Protocol specification: "width:height represents an aspect ratio.
    /// It may be approximate, and may not correspond to absolute dimensions in any given unit."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.embed.images`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/defs.json
    public struct AspectRatioDefinition: Sendable, Codable, Equatable, Hashable {

        /// The width of the image.
        public let width: Int

        /// The height of the image.
        public let height: Int

        public init(width: Int, height: Int) {
            self.width = width
            self.height = height
        }
    }
}
