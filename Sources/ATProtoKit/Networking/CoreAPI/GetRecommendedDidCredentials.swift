//
//  GetRecommendedDidCredentials.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-15.
//

import Foundation

extension ATProtoKit {
    /// Retrieves the required information of a Personal Data Server's (PDS) DID document for migration.
    ///
    /// - Returns: A `Result`, containing either an ``IdentityGetRecommendedDidCredentialsOutput`` if successful, or an `Error` if not.
    public func getRecommendedDIDCredentials() async throws -> Result<IdentityGetRecommendedDidCredentialsOutput, Error> {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/`com.atproto.identity.getRecommendedDidCredentials") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .get,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: nil,
                                                         authorizationValue: nil)
            let response = try await APIClientService.sendRequest(request, decodeTo: IdentityGetRecommendedDidCredentialsOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
