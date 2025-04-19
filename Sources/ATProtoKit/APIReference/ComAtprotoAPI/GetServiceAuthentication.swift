//
//  GetServiceAuthentication.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-25.
//

import Foundation

extension ATProtoKit {

    /// Retrieves a token from a requested service.
    /// 
    /// - Note: According to the AT Protocol specifications: "Get a signed token on behalf of
    /// the requesting DID for the requested service."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.getServiceAuth`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/getServiceAuth.json
    ///
    /// - Parameters:
    ///   -  did: The decentralized identifier (DID) of the service.
    ///   - expirationTime: The exporation date of the session tokens expire. Optional.
    ///   Defaults to 60 seconds in the Unix Epoch format.
    ///   - lexiconMethod: The Namespaced Identifier (NSID) of the lexicon that the token is
    ///   bound to. Optional.
    /// - Returns: The signed token from the service that matches `serviceDID`.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getServiceAuthentication(
        from did: String,
        expirationTime: Int? = 60,
        lexiconMethod: String? = nil
    ) async throws -> ComAtprotoLexicon.Server.GetServiceAuthOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()
        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.server.getServiceAuth") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [
            ("aud", did)
        ]

        if let expirationTime {
            queryItems.append(("exp", "\(Int(Date().timeIntervalSince1970) + expirationTime)"))
        }

        if let lexiconMethod {
            queryItems.append(("lxm", lexiconMethod))
        }

        let queryURL: URL

        do {
            queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = await APIClientService.createRequest(
                forRequest: queryURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await APIClientService.shared.sendRequest(
                request,
                decodeTo: ComAtprotoLexicon.Server.GetServiceAuthOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
