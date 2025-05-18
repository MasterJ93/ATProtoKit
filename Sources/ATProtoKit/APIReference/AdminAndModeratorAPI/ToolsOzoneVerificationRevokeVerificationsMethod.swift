//
//  ToolsOzoneVerificationRevokeVerificationsMethod.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-05-18.
//

import Foundation

extension ATProtoAdmin {

    /// Revokes an array of verifications.
    ///
    /// - Note: According to the AT Protocol specifications: "Revoke previously granted verifications in
    /// batches of up to 100."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.verification.revokeVerifications`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/verification/revokeVerifications.json
    ///
    /// - Parameters:
    ///   - recordURIs: An array of verification record URIs. Can be up to 100 items.
    ///   - revokeReason: The reason the verification is being revoked. Can be up to 100 characters.
    /// - Returns: An array of record URIs that were successful and an array of errors for any
    /// unsuccessful revocations.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func revokeVerifications(
        recordURIs: [String],
        revokeReason: String
    ) async throws -> ToolsOzoneLexicon.Verification.RevokeVerificationsOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.verification.revokeVerifications") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ToolsOzoneLexicon.Verification.RevokeVerificationsRequestBody(
            recordURIs: recordURIs,
            revokeReason: revokeReason
        )

        do {
            let request = await APIClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: "application/json",
                contentTypeValue: "application/json",
                authorizationValue: "Bearer \(accessToken)"
            )

            let response = try await APIClientService.shared.sendRequest(
                request,
                withEncodingBody: requestBody,
                decodeTo: ToolsOzoneLexicon.Verification.RevokeVerificationsOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
