//
//  AppBskyUnspeccedGetAtmosphereRecordViewsMethod.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Gets hydrated views of multiple Atmosphere records.
    ///
    /// - Important: This is an unspecced method, and as such, this is highly volatile and may change or be
    /// removed at any time. Use at your own risk.
    ///
    /// - Note: According to the AT Protocol specifications: "Get hydrated views and raw associations
    /// for multiple Atmosphere records. Requires authentication. Roots may be latest or pinned to
    /// exact CIDs; dependencies are always latest."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.getAtmosphereRecordViews`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getAtmosphereRecordViews.json
    ///
    /// - Parameter records: An array of references to the records to fetch. Current maximum is
    /// 25 items.
    /// - Returns: An array of hydrated record views, index-aligned with `records`.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getAtmosphereRecordViews(
        records: [AppBskyLexicon.Unspecced.GetAtmosphereRecordViews.RecordReference]
    ) async throws -> AppBskyLexicon.Unspecced.GetAtmosphereRecordViewsOutput {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.unspecced.getAtmosphereRecordViews") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = AppBskyLexicon.Unspecced.GetAtmosphereRecordViewsRequestBody(
            records: Array(records.prefix(25))
        )

        do {
            let request = apiClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: "application/json",
                contentTypeValue: "application/json",
                requiresAuthorization: true
            )
            let response = try await apiClientService.sendRequest(
                request,
                withEncodingBody: requestBody,
                decodeTo: AppBskyLexicon.Unspecced.GetAtmosphereRecordViewsOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
