//
//  AppBskyUnspeccedGetPostThreadV2Method.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Retrieves a post thread (v2).
    ///
    /// - Important: This is an unspecced method, and as such, this is highly volatile and may change or be
    /// removed at any time. Use at your own risk.
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
    ///
    /// - Parameters:
    ///   - anchorURI: The URI of the anchor post. The thread will be built around it.
    ///   - above: Determines whether to include the parents above the anchor post. Optional.
    ///   Defaults to `true`.
    ///   - below: The number of reply layers below the anchor post that can be included in the
    ///   result. Optional. Defaults to `6`. Can be between `0` and `20`.
    ///   - branchingFactor: The maximum number of replies that can be included at each level of the
    ///   thread, except for the direct replies to the anchor post. Optional. Defaults to `10`.
    ///   Can be between `0` and `100`.
    ///   - sort: The sorting order of the thread replies. Optional. Defaults to `.oldest`.
    ///   - labelersValue: The `atproto-accept-labelers` header value, containing the labeler
    ///   services whose labels should be applied to the response. Optional.
    /// - Returns: A flat array of thread items around the anchor post, with an optional threadgate
    /// view and whether the thread has additional replies.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getPostThreadV2(
        from anchorURI: String,
        above: Bool? = true,
        below: Int? = 6,
        branchingFactor: Int? = 10,
        sort: AppBskyLexicon.Unspecced.GetPostThreadV2.Sort? = .oldest,
        labelersValue: String? = nil
    ) async throws -> AppBskyLexicon.Unspecced.GetPostThreadV2Output {
        let session = try await self.getUserSession()
        let requiresAuthorization = session != nil

        let sessionURL = session?.serviceEndpoint.absoluteString ?? self.pdsURL
        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.unspecced.getPostThreadV2") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        queryItems.append(("anchor", anchorURI))

        if let above {
            queryItems.append(("above", "\(above)"))
        }

        if let below {
            let finalBelow = max(0, min(below, 20))
            queryItems.append(("below", "\(finalBelow)"))
        }

        if let branchingFactor {
            let finalBranchingFactor = max(0, min(branchingFactor, 100))
            queryItems.append(("branchingFactor", "\(finalBranchingFactor)"))
        }

        if let sort {
            queryItems.append(("sort", sort.rawValue))
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
                requiresAuthorization: requiresAuthorization,
                labelersValue: labelersValue
            )
            let response = try await apiClientService.sendRequest(
                request,
                decodeTo: AppBskyLexicon.Unspecced.GetPostThreadV2Output.self
            )

            return response
        } catch {
            throw error
        }
    }
}
