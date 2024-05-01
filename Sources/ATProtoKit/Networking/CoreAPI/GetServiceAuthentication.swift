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
    /// - Parameter serviceDID: The decentralized identifier (DID) of the service.
    /// - Returns: A `Result`, containing either a ``ServerGetServiceAuthOutput``
    /// if successful, or an `Error`if not.
    public func getServiceAuthentication(from serviceDID: String) async throws -> Result<ServerGetServiceAuthOutput, Error> {
        guard session != nil,
              let accessToken = session?.accessToken else {
            return .failure(ATRequestPrepareError.missingActiveSession)
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.server.getServiceAuth") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        let queryItems = [
            ("aud", serviceDID)
        ]

        let queryURL: URL

        do {
            queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = APIClientService.createRequest(forRequest: queryURL,
                                                         andMethod: .get,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: nil,
                                                         authorizationValue: "Bearer \(accessToken)")
            let response = try await APIClientService.sendRequest(request,
                                                                  decodeTo: ServerGetServiceAuthOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
