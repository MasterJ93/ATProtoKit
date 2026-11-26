//
//  AppBskyUnspeccedGetAtmosphereRecordViews.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Unspecced {

    /// The main data model definition for getting hydrated views of multiple Atmosphere records.
    ///
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    public struct GetAtmosphereRecordViews: Sendable, Codable {

        /// A reference to an Atmosphere record.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.unspecced.getAtmosphereRecordViews`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getAtmosphereRecordViews.json
        public struct RecordReference: Sendable, Codable {

            /// The URI of the record.
            ///
            /// - Note: According to the AT Protocol specifications: "Complete DID-based AT-URI of the
            /// record, including collection and record key."
            public let uri: String

            /// The CID hash of the record. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "Optional CID pinning the exact
            /// record version. Omit to fetch the latest version. Unavailable pins never fall back
            /// to latest."
            public let cid: String?

            public init(uri: String, cid: String? = nil) {
                self.uri = uri
                self.cid = cid
            }
        }

        /// A hydrated view of an Atmosphere record.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.unspecced.getAtmosphereRecordViews`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getAtmosphereRecordViews.json
        public struct RecordView: Sendable, Codable {

            /// The hydrated view of the record. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "Hydrated view, present only when
            /// the records supply enough information to populate the required fields."
            public let view: ViewUnion?

            /// An array of strong references to the record and its dependency records. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "The selected root followed by its
            /// visible latest dependencies: a document's publication or a gallery's items and photos.
            /// Index-aligned with associatedRecords."
            public let associatedRefs: [ComAtprotoLexicon.Repository.StrongReference]?

            /// The raw record data of the record and its dependency records. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "Raw record data, index-aligned
            /// with associatedRefs."
            public let associatedRecords: [[String: CodableValue]]?

            // Unions
            /// The hydrated view of the record.
            public enum ViewUnion: ATUnionProtocol {

                /// The view of an article.
                case viewArticle(AppBskyLexicon.Embed.ExternalDefinition.ViewArticle)

                /// The view of an article publication.
                case viewArticlePublication(AppBskyLexicon.Embed.ExternalDefinition.ViewArticlePublication)

                /// The view of a gallery.
                case viewGallery(AppBskyLexicon.Embed.ExternalDefinition.ViewGallery)

                /// The view of a livestream.
                case viewLivestream(AppBskyLexicon.Embed.ExternalDefinition.ViewLivestream)

                /// An unknown case.
                case unknown(String, [String: CodableValue])

                public init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeys.self)
                    let type = try container.decodeIfPresent(String.self, forKey: .type)

                    switch type {
                        case "app.bsky.embed.external#viewArticle":
                            self = .viewArticle(try AppBskyLexicon.Embed.ExternalDefinition.ViewArticle(from: decoder))
                        case "app.bsky.embed.external#viewArticlePublication":
                            self = .viewArticlePublication(try AppBskyLexicon.Embed.ExternalDefinition.ViewArticlePublication(from: decoder))
                        case "app.bsky.embed.external#viewGallery":
                            self = .viewGallery(try AppBskyLexicon.Embed.ExternalDefinition.ViewGallery(from: decoder))
                        case "app.bsky.embed.external#viewLivestream":
                            self = .viewLivestream(try AppBskyLexicon.Embed.ExternalDefinition.ViewLivestream(from: decoder))
                        default:
                            let singleValueDecodingContainer = try decoder.singleValueContainer()
                            let dictionary = try Self.decodeDictionary(from: singleValueDecodingContainer, decoder: decoder)

                            self = .unknown(type ?? "unknown", dictionary)
                    }
                }

                public func encode(to encoder: any Encoder) throws {
                    var container = encoder.singleValueContainer()

                    switch self {
                        case .viewArticle(let value):
                            try container.encode(value)
                        case .viewArticlePublication(let value):
                            try container.encode(value)
                        case .viewGallery(let value):
                            try container.encode(value)
                        case .viewLivestream(let value):
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

    /// A request body model for getting hydrated views of multiple Atmosphere records.
    ///
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    ///
    /// - Note: According to the AT Protocol specifications: "Get hydrated views and raw associations
    /// for multiple Atmosphere records. Requires authentication. Roots may be latest or pinned to
    /// exact CIDs; dependencies are always latest."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.getAtmosphereRecordViews`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getAtmosphereRecordViews.json
    public struct GetAtmosphereRecordViewsRequestBody: Sendable, Codable {

        /// An array of references to the records to fetch.
        ///
        /// - Note: According to the AT Protocol specifications: "Records to fetch. Results preserve
        /// this order, including duplicates."
        ///
        /// - Note: Current maximum length is 25 items.
        public let records: [AppBskyLexicon.Unspecced.GetAtmosphereRecordViews.RecordReference]
    }

    /// An output model for getting hydrated views of multiple Atmosphere records.
    ///
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    ///
    /// - Note: According to the AT Protocol specifications: "Get hydrated views and raw associations
    /// for multiple Atmosphere records. Requires authentication. Roots may be latest or pinned to
    /// exact CIDs; dependencies are always latest."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.getAtmosphereRecordViews`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getAtmosphereRecordViews.json
    public struct GetAtmosphereRecordViewsOutput: Sendable, Codable {

        /// An array of hydrated record views.
        ///
        /// - Note: According to the AT Protocol specifications: "Index-aligned with the input
        /// records. Missing or invisible roots produce empty objects. Visible roots without a
        /// supported view still return raw associations. Each result includes only its own
        /// dependencies."
        public let views: [AppBskyLexicon.Unspecced.GetAtmosphereRecordViews.RecordView]
    }
}
