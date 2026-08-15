//
//  AppBskyEmbedGetEmbedExternalView.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-10.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Embed {

    /// An output model for resolving AT-URIs into the data needed to render an enhanced external embed.
    ///
    /// - Note: According to the AT Protocol specifications: "Resolve one or more AT-URIs into the
    /// data needed to render an enhanced external embed."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.embed.getEmbedExternalView`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/getEmbedExternalView.json
    public struct GetEmbedExternalViewOutput: Sendable, Codable {

        /// The hydrated view of the embed. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Present only when the resolved
        /// records back the requested URL and supply enough information to populate the required
        /// `viewExternal` fields."
        public let view: AppBskyLexicon.Embed.ExternalDefinition.View?

        /// Strong references to the Atmosphere records that backed this view. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "StrongRefs (URI+CID) of the
        /// Atmosphere records that backed this view, suitable for embedding into a post's
        /// external.associatedRefs."
        public let associatedRefs: [ComAtprotoLexicon.Repository.StrongReference]?

        /// The raw record data of the Atmosphere records that backed this view. Optional.
        public let associatedRecords: [[String: CodableValue]]?
    }
}
