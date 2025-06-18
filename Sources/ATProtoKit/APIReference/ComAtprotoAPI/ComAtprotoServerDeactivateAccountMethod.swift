//
//  ComAtprotoServerDeactivateAccountMethod.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-24.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Deactivates the user's account.
    ///
    /// - Note: If you don't add `deleteAfter`, make sure to use
    /// ``deleteAccount(for:password:deletionToken:)`` at some point after.
    ///
    /// - Note: According to the AT Protocol specifications: "Deactivates a currently active
    /// account. Stops serving of repo, and future writes to repo until reactivated. Used to
    /// finalize account migration with the old host after the account has been activated on
    /// the new host."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.deactivateAccount`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/deactivateAccount.json
    ///
    /// - Parameter date: The date and time of when the server should delete the account.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func deactivateAccount(withDeletedDateOf date: Date) async throws {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()
        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.server.deactivateAccount") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ComAtprotoLexicon.Server.DeactivateAccountRequestBody(
            deleteAfter: date
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
