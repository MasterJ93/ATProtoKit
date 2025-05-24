//
//  AppBskyActorStatus.swift
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
        public let embed: EmbedUnion?

        /// The amount of time the status has lasted in minutes.
        ///
        /// - Note: According to the AT Protocol specifications: "The duration of the status in minutes.
        /// Applications can choose to impose minimum and maximum limits."
        public let durationMinutes: Int?

        /// The date and time the record was created.
        public let createdAt: Date

        public init(status: Status, embed: EmbedUnion?, durationMinutes: Int?, createdAt: Date) {
            self.status = status
            self.embed = embed
            self.durationMinutes = durationMinutes
            self.createdAt = createdAt
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.status = try container.decode(AppBskyLexicon.Actor.StatusRecord.Status.self, forKey: .status)
            self.embed = try container.decodeIfPresent(EmbedUnion.self, forKey: .embed)
            self.durationMinutes = try container.decodeIfPresent(Int.self, forKey: .durationMinutes)
            self.createdAt = try container.decodeDate(forKey: .createdAt)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.status, forKey: .status)
            try container.encodeIfPresent(self.embed, forKey: .embed)
            try container.encodeIfPresent(self.durationMinutes, forKey: .durationMinutes)
            try container.encodeDate(self.createdAt, forKey: .createdAt)
        }

        enum CodingKeys: CodingKey {
            case status
            case embed
            case durationMinutes
            case createdAt
        }

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

            public init(from decoder: any Decoder) throws {
                let container = try decoder.singleValueContainer()

                if let value = try? container.decode(AppBskyLexicon.Embed.ExternalDefinition.View.self) {
                    self = .externalView(value)
                } else {
                    throw DecodingError.typeMismatch(
                        EmbedUnion.self, DecodingError.Context(
                            codingPath: decoder.codingPath, debugDescription: "Unknown EmbedUnion type"))
                }
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.singleValueContainer()

                switch self {
                    case .externalView(let value):
                        try container.encode(value)
                }
            }
        }
    }
}
