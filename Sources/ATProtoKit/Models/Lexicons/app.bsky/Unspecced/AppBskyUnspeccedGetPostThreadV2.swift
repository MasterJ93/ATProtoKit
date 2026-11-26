//
//  AppBskyUnspeccedGetPostThreadV2.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Unspecced {

    /// The main data model definition for retrieving a post thread (v2).
    ///
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    public struct GetPostThreadV2: Sendable, Codable {

        /// Determines the sorting order of the thread replies.
        ///
        /// - Note: According to the AT Protocol specifications: "Sorting for the thread replies."
        ///
        /// - SeeAlso: This is based on the [`app.bsky.unspecced.getPostThreadV2`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getPostThreadV2.json
        public enum Sort: String, Sendable, Codable {

            /// Indicates the replies will be sorted from newest to oldest.
            case newest

            /// Indicates the replies will be sorted from oldest to newest.
            case oldest

            /// Indicates the replies will be sorted by top replies.
            case top
        }

        /// An item in a post thread.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.unspecced.getPostThreadV2`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getPostThreadV2.json
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

                /// A thread item that can't be viewed without authentication.
                case threadItemNoUnauthenticated(AppBskyLexicon.Unspecced.ThreadItemNoUnauthenticatedDefinition)

                /// A thread item that wasn't found.
                case threadItemNotFound(AppBskyLexicon.Unspecced.ThreadItemNotFoundDefinition)

                /// A thread item that's been blocked.
                case threadItemBlocked(AppBskyLexicon.Unspecced.ThreadItemBlockedDefinition)

                /// An unknown case.
                case unknown(String, [String: CodableValue])

                public init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeys.self)
                    let type = try container.decodeIfPresent(String.self, forKey: .type)

                    switch type {
                        case "app.bsky.unspecced.defs#threadItemPost":
                            self = .threadItemPost(try AppBskyLexicon.Unspecced.ThreadItemPostDefinition(from: decoder))
                        case "app.bsky.unspecced.defs#threadItemNoUnauthenticated":
                            self = .threadItemNoUnauthenticated(try AppBskyLexicon.Unspecced.ThreadItemNoUnauthenticatedDefinition(from: decoder))
                        case "app.bsky.unspecced.defs#threadItemNotFound":
                            self = .threadItemNotFound(try AppBskyLexicon.Unspecced.ThreadItemNotFoundDefinition(from: decoder))
                        case "app.bsky.unspecced.defs#threadItemBlocked":
                            self = .threadItemBlocked(try AppBskyLexicon.Unspecced.ThreadItemBlockedDefinition(from: decoder))
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
                        case .threadItemNoUnauthenticated(let value):
                            try container.encode(value)
                        case .threadItemNotFound(let value):
                            try container.encode(value)
                        case .threadItemBlocked(let value):
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

    /// An output model for retrieving a post thread (v2).
    ///
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    ///
    /// - Note: According to the AT Protocol specifications: "(NOTE: this endpoint is under development
    /// and WILL change without notice. Don't use it until it is moved out of `unspecced` or your
    /// application WILL break) Get posts in a thread. It is based in an anchor post at any depth of
    /// the tree, and returns posts above it (recursively resolving the parent, without further
    /// branching to their replies) and below it (recursive replies, with branching to their replies).
    /// Does not require auth, but additional metadata and filtering will be applied for authed
    /// requests."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.getPostThreadV2`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getPostThreadV2.json
    public struct GetPostThreadV2Output: Sendable, Codable {

        /// A flat array of thread items.
        ///
        /// - Note: According to the AT Protocol specifications: "A flat list of thread items. The
        /// depth of each item is indicated by the depth property inside the item."
        public let thread: [AppBskyLexicon.Unspecced.GetPostThreadV2.ThreadItem]

        /// A feed's threadgate view. Optional.
        public let threadgate: AppBskyLexicon.Feed.ThreadgateViewDefinition?

        /// Indicates whether the thread has additional replies.
        ///
        /// - Note: According to the AT Protocol specifications: "Whether this thread has additional
        /// replies. If true, a call can be made to the `getPostThreadOtherV2` endpoint to
        /// retrieve them."
        public let hasOtherReplies: Bool
    }
}
