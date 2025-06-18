//
//  ComAtprotoServerRequestEmailConfirmationMethod.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Requests an email confirmation to verify the email belongs to the user.
    ///
    /// - Note: According to the AT Protocol specifications: "Request an email with a code
    /// to confirm ownership of email."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.requestEmailConfirmation`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/requestEmailConfirmation.json
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func requestEmailConfirmation() async throws {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()
        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.server.requestEmailConfirmation") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        do {
            let request = apiClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: nil,
                contentTypeValue: nil,
                authorizationValue: "Bearer \(accessToken)"
            )

            _ = try await apiClientService.sendRequest(request)
        } catch {
            throw error
        }
    }
}

