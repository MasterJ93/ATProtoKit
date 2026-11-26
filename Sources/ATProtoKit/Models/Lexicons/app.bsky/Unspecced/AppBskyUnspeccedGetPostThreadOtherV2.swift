//
//  AppBskyUnspeccedGetPostThreadOtherV2.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Unspecced {

    /// The main data model definition for retrieving additional posts under a post thread (v2).
    ///
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    public struct GetPostThreadOtherV2: Sendable, Codable {

        /// An item in a post thread.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.unspecced.getPostThreadOtherV2`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getPostThreadOtherV2.json
        public struct ThreadItem: Sendable, Codable {

            /// The URI of the thread item.
            public let uri: String

            /// The nesting level of the item in the thread.
            ///
            /// - Note: According to the AT Protocol specifications: "The nesting level of this item
            /// in the thread. Depth 0 means the anchor item. Items above have negative depths, items
            /// below have positive depths."
            public let depth: Int

            /// The value of the thread item.
            public let value: ValueUnion

            // Unions
            /// The value of the thread item.
            public enum ValueUnion: ATUnionProtocol {

                /// A post item in a thread.
                case threadItemPost(AppBskyLexicon.Unspecced.ThreadItemPostDefinition)

                /// An unknown case.
                case unknown(String, [String: CodableValue])

                public init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeys.self)
                    let type = try container.decodeIfPresent(String.self, forKey: .type)

                    switch type {
                        case "app.bsky.unspecced.defs#threadItemPost":
                            self = .threadItemPost(try AppBskyLexicon.Unspecced.ThreadItemPostDefinition(from: decoder))
                        default:
                            let singleValueDecodingContainer = try decoder.singleValueContainer()
                            let dictionary = try Self.decodeDictionary(from: singleValueDecodingContainer, decoder: decoder)

                            self = .unknown(type ?? "unknown", dictionary)
                    }
                }

                public func encode(to encoder: any Encoder) throws {
                    var container = encoder.singleValueContainer()

                    switch self {
                        case .threadItemPost(let value):
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

    /// An output model for retrieving additional posts under a post thread (v2).
    ///
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    ///
    /// - Note: According to the AT Protocol specifications: "(NOTE: this endpoint is under development
    /// and WILL change without notice. Don't use it until it is moved out of `unspecced` or your
    /// application WILL break) Get additional posts under a thread e.g. replies hidden by threadgate.
    /// Based on an anchor post at any depth of the tree, returns top-level replies below that anchor.
    /// It does not include ancestors nor the anchor itself. This should be called after exhausting
    /// `app.bsky.unspecced.getPostThreadV2`. Does not require auth, but additional metadata and
    /// filtering will be applied for authed requests."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.getPostThreadOtherV2`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getPostThreadOtherV2.json
    public struct GetPostThreadOtherV2Output: Sendable, Codable {

        /// A flat array of other thread items.
        ///
        /// - Note: According to the AT Protocol specifications: "A flat list of other thread items.
        /// The depth of each item is indicated by the depth property inside the item."
        public let thread: [AppBskyLexicon.Unspecced.GetPostThreadOtherV2.ThreadItem]
    }
}
