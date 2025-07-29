//
//  ToolsOzoneVerificationsGrantVerificationsMethod.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-05-18.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoAdmin {

    /// Gives out a verification to user accounts.
    ///
    /// - Note: According to the AT Protocol specifications: "Grant verifications to multiple subjects.
    /// Allows batch processing of up to 100 verifications at once."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.verification.grantVerifications`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/verification/grantVerifications.json
    ///
    /// - Parameter verifications: An array of verification requests.
    /// - Returns: An array of either successful verifications, unsuccessful verifications or both.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func grantVerifications(_ verifications: [ToolsOzoneLexicon.Verification.GrantVerifications.VerificationInput]) async throws -> ToolsOzoneLexicon.Verification.GrantVerificationsOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        try await sessionConfiguration?.ensureValidToken()
        let accessToken = try await keychain.retrieveAccessToken()

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.verification.grantVerifications") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ToolsOzoneLexicon.Verification.GrantVerificationsRequestBody(
            verifications: verifications
        )

        do {
            let request = apiClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: "application/json",
                contentTypeValue: "application/json",
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await apiClientService.sendRequest(
                request,
                withEncodingBody: requestBody,
                decodeTo: ToolsOzoneLexicon.Verification.GrantVerificationsOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
