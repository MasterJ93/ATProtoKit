//
//  ComAtprotoTempRevokeAccountCredentialsMethod.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-09-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Revokes sessions, the account password, and app passwords associated with the account, which may be
    /// resolved by a password reset.
    ///
    /// - Note: According to the AT Protocol specifications: "Revoke sessions, password, and app passwords
    /// associated with account. May be resolved by a password reset."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.temp.revokeAccountCredentials`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/temp/revokeAccountCredentials.json
    ///
    /// - Parameter account: The AT Identifier of the user account to revoke their credentials for.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func revokeAccountCredentials(account: String) async throws {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        try await sessionConfiguration?.ensureValidToken()
        let accessToken = try await keychain.retrieveAccessToken()
        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.server.deleteAccount") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ComAtprotoLexicon.Temp.RevokeAccountCredentialsRequestBody(
            account: account
        )

        do {
            let request = apiClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: nil,
                contentTypeValue: "application/json",
                authorizationValue: "Bearer \(accessToken)"
            )

            _ = try await apiClientService.sendRequest(
                request,
                withEncodingBody: requestBody
            )
        } catch {
            throw error
        }
    }
}
