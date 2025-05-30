//
//  ComAtprotoSyncGetHostStatusMethod.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-05-17.
//

import Foundation

extension ATProtoKit {

    /// Describes a specified upstream host, as used by the server.
    ///
    /// - Note: According to the AT Protocol specifications: "Returns information about a specified upstream
    /// host, as consumed by the server. Implemented by relays."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.sync.getHostStatus`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/sync/getHostStatus.json
    ///
    /// - Parameter hostname: The name of the host, such as a Personal Data Server (PDS) or Relay.
    /// - Returns: Details about the host, including the hostname, sequence number, the number of
    /// user accounts connected to the host, and its status.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getHostStatus(from hostname: String) async throws -> ComAtprotoLexicon.Sync.GetHostStatusOutput {
        guard let _ = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()
//        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "https://bsky.network/xrpc/com.atproto.sync.getHostStatus") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        queryItems.append(("hostname", hostname))

        let queryURL: URL

        do {
            queryURL = try apiClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = apiClientService.createRequest(
                forRequest: queryURL,
                andMethod: .post,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await apiClientService.sendRequest(
                request,
                decodeTo: ComAtprotoLexicon.Sync.GetHostStatusOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
