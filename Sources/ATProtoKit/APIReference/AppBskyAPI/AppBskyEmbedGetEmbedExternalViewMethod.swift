//
//  AppBskyEmbedGetEmbedExternalViewMethod.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-10.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Resolves one or more AT-URIs into the data needed to render an enhanced external embed.
    ///
    /// - Note: According to the AT Protocol specifications: "Resolve one or more AT-URIs into
    /// the data needed to render an enhanced external embed. Returns `associatedRefs`
    /// (strongRefs to embed into a post's external.associatedRefs), the raw `associatedRecords`,
    /// and a hydrated `view`. The response is empty (`{}`) when no records were resolvable, or
    /// when validation determined the resolved records don't actually back the requested URL;
    /// clients should fall back to their own link-card rendering in that case and skip writing
    /// strongRefs to the post."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.embed.getEmbedExternalView`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/getEmbedExternalView.json
    ///
    /// - Parameters:
    ///   - url: The canonical web URL the embed represents. Used as the returned view's `uri`.
    ///   - uris: AT-URIs of Atmosphere records that can be resolved and used to construct
    ///   the embed view. Current maximum is 4 items.
    /// - Returns: A hydrated embed view, associated strong references, and raw record data.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getEmbedExternalView(
        url: String,
        uris: [String]
    ) async throws -> AppBskyLexicon.Embed.GetEmbedExternalViewOutput {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.embed.getEmbedExternalView") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        queryItems.append(("url", url))

        let cappedURIs = uris.prefix(4)
        queryItems += cappedURIs.map { ("uris", $0) }

        let queryURL: URL

        do {
            queryURL = try apiClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = apiClientService.createRequest(
                forRequest: queryURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                requiresAuthorization: true
            )
            let response = try await apiClientService.sendRequest(
                request,
                decodeTo: AppBskyLexicon.Embed.GetEmbedExternalViewOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
