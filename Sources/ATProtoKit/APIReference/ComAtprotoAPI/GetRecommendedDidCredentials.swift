//
//  GetRecommendedDidCredentials.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-15.
//

import Foundation

extension ATProtoKit {

    /// Retrieves the required information of a Personal Data Server's (PDS) DID document
    /// for migration.
    ///
    /// - Note: According to the AT Protocol specifications: "Describe the credentials that should
    /// be included in the DID doc of an account that is migrating to this service."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.identity.getRecommendedDidCredentials`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/identity/getRecommendedDidCredentials.json
    ///
    /// - Returns: The DID document of the Personal Data Server (PDS).
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getRecommendedDIDCredentials() async throws -> ComAtprotoLexicon.Identity.GetRecommendedDidCredentialsOutput {
        guard let requestURL = URL(string: "\(self.pdsURL)/xrpc/com.atproto.identity.getRecommendedDidCredentials") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        do {
            let request = APIClientService.createRequest(
                forRequest: requestURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: nil
            )
            let response = try await APIClientService.shared.sendRequest(
                request, decodeTo:
                ComAtprotoLexicon.Identity.GetRecommendedDidCredentialsOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
