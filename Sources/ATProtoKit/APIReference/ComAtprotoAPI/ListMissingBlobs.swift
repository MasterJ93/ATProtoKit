//
//  ListMissingBlobs.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-11.
//

import Foundation

extension ATProtoKit {

    /// Lists any missing blobs attached to the user account.
    /// 
    /// - Note: According to the AT Protocol specifications: "Returns a list of missing blobs for
    /// the requesting account. Intended to be used in the account migration flow."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.repo.listMissingBlobs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/repo/listMissingBlobs.json
    ///
    /// - Parameters:
    ///   - limit: The number of items that can be in the list. Optional. Defaults to `500`.
    ///   - cursor: The mark used to indicate the starting point for the next set
    ///   of results. Optional.
    /// - Returns: An array of missing blobs attached to the user account.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func listMissingBlobs(
        limit: Int? = 500,
        cursor: String? = nil
    ) async throws -> ComAtprotoLexicon.Repository.ListMissingBlobsOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()
        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.repo.listMissingBlobs") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        if let limit {
            let finalLimit = max(1, min(limit, 1_000))
            queryItems.append(("limit", "\(finalLimit)"))
        }

        if let cursor {
            queryItems.append(("cursor", cursor))
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
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await apiClientService.sendRequest(
                request,
                decodeTo: ComAtprotoLexicon.Repository.ListMissingBlobsOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
