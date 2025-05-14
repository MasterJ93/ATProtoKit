//
//  AppBskyActorStatusRecord.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-05-14.
//

import Foundation

extension AppBskyLexicon.Actor {

    /// A record model for a status.
    ///
    /// - Note: According to the AT Protocol specifications: "A declaration of a Bluesky account status."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct StatusRecord: Sendable, Codable, Equatable, Hashable {

        /// The status of the user account.
        public let status: Status

        /// The embedded content related to the status.
        ///
        /// - Note: According to the AT Protocol specifications: "An optional embed associated with
        /// the status."
        public let embed: String?

        /// The amount of time the status has lasted in minutes.
        ///
        /// - Note: According to the AT Protocol specifications: "The duration of the status in minutes.
        /// Applications can choose to impose minimum and maximum limits."
        public let durationMinutes: Int?

        /// The date and time the record was created.
        public let createdAt: Date

        // Enums
        /// The status of the user account.
        public enum Status: String, Sendable, Codable, Equatable, Hashable {

            /// The status of the user account is "live."
            ///
            /// - Note: According to the AT Protocol specifications: "Advertises an account as currently
            /// offering live content."
            case live = "live"
        }

        // Unions
        /// A reference containing the list of embeds.
        public enum EmbedUnion: Sendable, Codable, Equatable, Hashable {

            /// An external embed view.
            case externalView(AppBskyLexicon.Embed.ExternalDefinition.View)
        }
    }
}
