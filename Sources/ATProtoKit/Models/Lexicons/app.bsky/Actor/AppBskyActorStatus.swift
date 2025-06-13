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
    public struct StatusRecord: ATRecordProtocol, Sendable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public static let type: String = "app.bsky.actor.status"

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

        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case status
            case embed
            case durationMinutes
            case createdAt
        }

        // Enums
        /// The status of the user account.
        public enum Status: Sendable, Codable, Equatable, Hashable, ExpressibleByStringLiteral {

            /// The status of the user account is "live."
            ///
            /// - Note: According to the AT Protocol specifications: "Advertises an account as currently
            /// offering live content."
            case live

            /// An unknown value that the object may contain.
            case unknown(String)

            /// Provides the raw string value for encoding, decoding, and comparison.
            public var rawValue: String {
                switch self {
                    case .live: return "app.bsky.actor.status#live"
                    case .unknown(let value): return value
                }
            }

            public init(stringLiteral value: String) {
                self = .unknown(value)
            }

            public init(from decoder: Decoder) throws {
                let container = try decoder.singleValueContainer()
                let value = try container.decode(String.self)
                switch value {
                    case "app.bsky.actor.status#live":
                        self = .live
                    default:
                        self = .unknown(value)
                }
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()
                try container.encode(self.rawValue)
            }
        }

        // Unions
        /// A reference containing the list of embeds..
        public enum EmbedUnion: ATUnionProtocol, Equatable, Hashable {

            /// An external embed view.
            case externalView(AppBskyLexicon.Embed.ExternalDefinition)

            /// An unknown case.
            case unknown(String, [String: CodableValue])

            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let type = try container.decode(String.self, forKey: .type)

                switch type {
                    case "app.bsky.embed.external#view":
                        self = .externalView(try AppBskyLexicon.Embed.ExternalDefinition(from: decoder))
                    default:
                        let singleValueDecodingContainer = try decoder.singleValueContainer()
                        let dictionary = try Self.decodeDictionary(from: singleValueDecodingContainer, decoder: decoder)

                        self = .unknown(type, dictionary)
                }
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.singleValueContainer()

                switch self {
                    case .externalView(let value):
                        try container.encode(value)
                    default:
                        break
                }
            }

            enum CodingKeys: String, CodingKey {
                case type = "$type"
            }
        }
    }
}
