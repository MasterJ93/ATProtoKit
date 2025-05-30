//
//  ComAtprotoSyncListHostsMethod.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-05-17.
//

import Foundation

extension ATProtoKit {

    /// Lists the upstream hosts, such as a Personal Data Server (PDS) or Relay) that this service uses.
    ///
    /// - Note: According to the AT Protocol specifications: "Enumerates upstream hosts (eg, PDS or
    /// relay instances) that this service consumes from. Implemented by relays."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.sync.listHosts`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/sync/listHosts.json
    ///
    /// - Parameters:
    ///   - limit: The number of items that can be in the list. Optional. Defaults to `200`.
    ///   - cursor: The mark used to indicate the starting point for the next set
    ///   of result. Optional.
    /// - Returns: An array of hosts.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func listHosts(
        limit: Int? = 200,
        cursor: String? = nil
    ) async throws -> ComAtprotoLexicon.Sync.ListHostsOutput {
        guard let _ = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()
//        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "https://bsky.network/xrpc/com.atproto.sync.listHosts") else {
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
                decodeTo: ComAtprotoLexicon.Sync.ListHostsOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
