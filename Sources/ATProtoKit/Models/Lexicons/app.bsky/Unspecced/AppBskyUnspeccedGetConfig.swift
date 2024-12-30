//
//  AppBskyUnspeccedGetConfig.swift
//
//
//  Created by Christopher Jr Riley on 2024-12-30.
//

import Foundation

extension AppBskyLexicon.Unspecced {

    /// An output model for retrieving some runtime configuration.
    ///
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    ///
    /// - Note: According to the AT Protocol specifications: "Get miscellaneous
    /// runtime configuration."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.getConfig`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/unspecced/getConfig.json
    public struct GetConfigOutput: Sendable, Codable {

        /// Indicates whether the email has been confirmed. Optional.
        public let hasEmailBeenConfirmed: Bool?

        enum CodingKeys: String, CodingKey {
            case hasEmailBeenConfirmed = "checkEmailConfirmed"
        }
    }
}
