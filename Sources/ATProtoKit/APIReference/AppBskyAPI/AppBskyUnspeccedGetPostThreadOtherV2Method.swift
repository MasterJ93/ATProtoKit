//
//  AppBskyUnspeccedGetPostThreadOtherV2Method.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Retrieves additional posts under a post thread (v2).
    ///
    /// - Important: This is an unspecced method, and as such, this is highly volatile and may change or be
    /// removed at any time. Use at your own risk.
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
    ///
    /// - Parameters:
    ///   - anchorURI: The URI of the anchor post.
    ///   - labelersValue: The `atproto-accept-labelers` header value, containing the labeler
    ///   services whose labels should be applied to the response. Optional.
    /// - Returns: A flat array of other thread items below the anchor post.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getPostThreadOtherV2(
        from anchorURI: String,
        labelersValue: String? = nil
    ) async throws -> AppBskyLexicon.Unspecced.GetPostThreadOtherV2Output {
        let session = try await self.getUserSession()
        let requiresAuthorization = session != nil

        let sessionURL = session?.serviceEndpoint.absoluteString ?? self.pdsURL
        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.unspecced.getPostThreadOtherV2") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        queryItems.append(("anchor", anchorURI))

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
                requiresAuthorization: requiresAuthorization,
                labelersValue: labelersValue
            )
            let response = try await apiClientService.sendRequest(
                request,
                decodeTo: AppBskyLexicon.Unspecced.GetPostThreadOtherV2Output.self
            )

            return response
        } catch {
            throw error
        }
    }
}
