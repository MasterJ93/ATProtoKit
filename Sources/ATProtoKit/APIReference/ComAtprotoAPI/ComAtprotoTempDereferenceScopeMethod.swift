//
//  ComAtprotoTempDereferenceScopeMethod.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-09-27.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Resolves the OAuth permission scope from a reference.
    ///
    ///
    /// - Note: According to the AT Protocol specifications: "Allows finding the oauth permission scope from a reference."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.temp.dereferenceScope`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/temp/dereferenceScope.json
    ///
    /// - Parameter scope: A scope reference string that begins with `ref:`.
    /// - Returns: The complete OAuth permission scope.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func dereferenceScope(_ scope: String) async throws -> ComAtprotoLexicon.Temp.DereferenceScopeOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        try await sessionConfiguration?.ensureValidToken()
        let accessToken = try await keychain.retrieveAccessToken()
        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.temp.dereferenceScope") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        queryItems.append(("scope", scope))

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
                decodeTo: ComAtprotoLexicon.Temp.DereferenceScopeOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
