//
//  GetServiceToken.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-25.
//

import Foundation

extension ATProtoKit {
    /// Retrieves a token from a requested service.
    /// 
    /// - Parameter serviceDID: The decentralized identifier (DID) of the service.
    /// - Returns: A `Result`, containing either a ``ServerGetServiceAuthOutput`` if successful, or an `Error`if not.
    public func getServiceToken(_ serviceDID: String) async throws -> Result<ServerGetServiceAuthOutput, Error> {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.server.getServiceAuth") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        let queryItems = [
            ("aud", serviceDID)
        ]

        do {
            let queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = APIClientService.createRequest(forRequest: queryURL, andMethod: .get, acceptValue: "application/json", contentTypeValue: nil, authorizationValue: "Bearer \(session.accessToken)")
            let response = try await APIClientService.sendRequest(request, decodeTo: ServerGetServiceAuthOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
