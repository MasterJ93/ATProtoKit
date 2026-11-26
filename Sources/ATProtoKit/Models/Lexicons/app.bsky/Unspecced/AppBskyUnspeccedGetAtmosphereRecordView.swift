//
//  AppBskyUnspeccedGetAtmosphereRecordView.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Unspecced {

    /// An output model for getting a hydrated view of an Atmosphere record.
    ///
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    ///
    /// - Note: According to the AT Protocol specifications: "Get a hydrated view of one Atmosphere
    /// record. Requires authentication. Without `cid` the latest version of the record is returned;
    /// with `cid` exactly that version is returned, never another. Dependencies of the record are
    /// always latest. Returns an empty object when the record is missing or not visible. When the
    /// record is visible but cannot produce a view, only the associations are returned."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.getAtmosphereRecordView`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getAtmosphereRecordView.json
    public struct GetAtmosphereRecordViewOutput: Sendable, Codable {

        /// The hydrated view of the record. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Hydrated view of the record. Present
        /// only when the records supply enough information to populate the required fields."
        public let view: ViewUnion?

        /// An array of strong references to the record and its dependency records. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "StrongRefs (URI+CID) of the record
        /// itself, followed by the dependency records selected for its collection (a document's
        /// publication; a gallery's items and photos). Index-aligned with `associatedRecords`."
        public let associatedRefs: [ComAtprotoLexicon.Repository.StrongReference]?

        /// The raw record data of the record and its dependency records. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "The raw record data, index-aligned
        /// with `associatedRefs`."
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
