//
//  ComAtprotoTempCheckHandleAvailability.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-07-23.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ComAtprotoLexicon.Temp {

    /// A definition model for checking if the provided handle is available.
    ///
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    ///
    /// - Note: According to the AT Protocol specifications: "Checks whether the provided handle
    /// is available. If the handle is not available, available suggestions will be returned.
    /// Optional inputs will be used to generate suggestions."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.checkHandleAvailability`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/temp/checkHandleAvailability.json
    public struct CheckHandleAvailability: Sendable, Codable {

        /// Indicates the specified handle is available for use.
        ///
        /// - Note: According to the AT Protocol specifications: "Indicates the provided handle
        /// is available."
        ///
        /// - SeeAlso: This is based on the [`app.bsky.unspecced.checkHandleAvailability`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/temp/checkHandleAvailability.json
        public struct ResultAvailable: Sendable, Codable {}

        /// Indicates the specified handle is not available for use.
        ///
        /// - Note: According to the AT Protocol specifications: "List of suggested handles based on
        /// the provided inputs."
        ///
        /// - SeeAlso: This is based on the [`app.bsky.unspecced.checkHandleAvailability`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/temp/checkHandleAvailability.json
        public struct ResultUnavailable: Sendable, Codable {

            /// An array of suggested user handles.
            ///
            /// - Note: According to the AT Protocol specifications: "List of suggested handles based on
            /// the provided inputs."
            public let suggestions: [Suggestion]

        }

        /// A alternative handle for the user account.
        ///
        /// - Note: According to the AT Protocol specifications: "Method used to build this suggestion.
        /// Should be considered opaque to clients. Can be used for metrics."
        ///
        /// - SeeAlso: This is based on the [`app.bsky.unspecced.checkHandleAvailability`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/temp/checkHandleAvailability.json
        public struct Suggestion: Sendable, Codable {

            /// The specified alternative handle for the user account.
            public let handle: String

            /// How this suggestion was created.
            ///
            /// - Note: According to the AT Protocol specifications: "Method used to build this suggestion.
            /// Should be considered opaque to clients. Can be used for metrics."
            public let method: String
        }
    }

    /// An output model for checking if the provided handle is available.
    ///
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    ///
    /// - Note: According to the AT Protocol specifications: "Checks whether the provided handle
    /// is available. If the handle is not available, available suggestions will be returned.
    /// Optional inputs will be used to generate suggestions."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.checkHandleAvailability`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/temp/checkHandleAvailability.json
    public struct CheckHandleAvailabilityOutput: Sendable, Codable {

        /// The handle the user wants to use for their user account.
        ///
        /// - Note: According to the AT Protocol specifications: "Echo of the input handle."
        public let handle: String

        /// The result of whether the handle is available or not.
        ///
        /// If it's unavailable, then it will display suggestions, as well as methods for how it came up
        /// with the suggestions.
        public let result: ResultUnion

        // Unions
        /// A union containing possible results.
        public enum ResultUnion: ATUnionProtocol {

            /// Indicates the specified handle is available for use.
            case resultAvailable(ComAtprotoLexicon.Temp.CheckHandleAvailability.ResultAvailable)

            /// Indicates the specified handle is not available for use.
            case resultUnavailable(ComAtprotoLexicon.Temp.CheckHandleAvailability.ResultUnavailable)

            /// An unknown case.
            case unknown(String, [String: CodableValue])

            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let type = try container.decodeIfPresent(String.self, forKey: .type)

                switch type {
                    case "app.bsky.unspecced.checkHandleAvailability#resultAvailable":
                        self = .resultAvailable(try ComAtprotoLexicon.Temp.CheckHandleAvailability.ResultAvailable(from: decoder))
                    case "app.bsky.unspecced.checkHandleAvailability#resultUnavailable":
                        self = .resultUnavailable(try ComAtprotoLexicon.Temp.CheckHandleAvailability.ResultUnavailable(from: decoder))
                    default:
                        let singleValueDecodingContainer = try decoder.singleValueContainer()
                        let dictionary = try Self.decodeDictionary(from: singleValueDecodingContainer, decoder: decoder)

                        self = .unknown(type ?? "unknown", dictionary)
                }
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.singleValueContainer()

                switch self {
                    case .resultAvailable(let value):
                        try container.encode(value)
                    case .resultUnavailable(let value):
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
