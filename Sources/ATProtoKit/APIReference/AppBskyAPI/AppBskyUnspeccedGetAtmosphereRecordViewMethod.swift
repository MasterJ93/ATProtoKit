//
//  AppBskyUnspeccedGetAtmosphereRecordViewMethod.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Gets a hydrated view of an Atmosphere record.
    ///
    /// - Important: This is an unspecced method, and as such, this is highly volatile and may change or be
    /// removed at any time. Use at your own risk.
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
    ///
    /// - Parameters:
    ///   - uri: The URI of the record.
    ///   - cid: The CID hash of the record. Optional.
    /// - Returns: A hydrated view of the record, with its associated strong references and raw
    /// record data.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getAtmosphereRecordView(
        uri: String,
        cid: String? = nil
    ) async throws -> AppBskyLexicon.Unspecced.GetAtmosphereRecordViewOutput {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.unspecced.getAtmosphereRecordView") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        queryItems.append(("uri", uri))

        if let cid {
            queryItems.append(("cid", cid))
        }

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
                decodeTo: AppBskyLexicon.Unspecced.GetAtmosphereRecordViewOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
