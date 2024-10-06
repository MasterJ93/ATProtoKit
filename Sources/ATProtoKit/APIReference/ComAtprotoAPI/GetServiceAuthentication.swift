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
    ///   -  serviceDID: The decentralized identifier (DID) of the service.
    ///   - expirationTime: The exporation date of the session tokens expire. Optional.
    ///   Defaults to 60 seconds in the Unix Epoch format.
    ///   - lexiconMethod: The Namespaced Identifier (NSID) of the lexicon that the token is
    ///   bound to. Optional.
    /// - Returns: The signed token from the service that matches `serviceDID`.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getServiceAuthentication(
        from serviceDID: String,
        expirationTime: Int? = Int(Date().timeIntervalSince1970) + 60,
        lexiconMethod: String?
    ) async throws -> ComAtprotoLexicon.Server.GetServiceAuthOutput {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.server.getServiceAuth") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [
            ("aud", serviceDID)
        ]

        if let expirationTime {
            queryItems.append(("exp", "\(expirationTime)"))
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

            let request = APIClientService.createRequest(
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
