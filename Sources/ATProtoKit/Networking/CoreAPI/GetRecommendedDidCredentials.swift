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
    /// - Note: According to the AT Protocol specifications: "Describe the credentials that should be included in the DID doc of an account that is migrating to this service."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.identity.getRecommendedDidCredentials`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/identity/getRecommendedDidCredentials.json
    ///
    /// - Returns: A `Result`, containing either an ``IdentityGetRecommendedDidCredentialsOutput`` if successful, or an `Error` if not.
    public func getRecommendedDIDCredentials() async throws -> Result<IdentityGetRecommendedDidCredentialsOutput, Error> {
        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.identity.getRecommendedDidCredentials") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .get,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: nil,
                                                         authorizationValue: nil)
            let response = try await APIClientService.sendRequest(request, decodeTo:
                                                                  IdentityGetRecommendedDidCredentialsOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
