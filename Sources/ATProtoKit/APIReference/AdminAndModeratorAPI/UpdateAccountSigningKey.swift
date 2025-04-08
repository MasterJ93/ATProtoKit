//
//  UpdateAccountSigningKey.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-04-01.
//

import Foundation

extension ATProtoKit {

    /// Updates an account's signing key in their DID document as an administrator.
    ///
    /// - Note: According to the AT Protocol specifications: "Administrative action to update an
    /// account's signing key in their Did document."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.admin.updateAccountSigningKey`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/updateAccountSigningKey.json
    ///
    public func updateAccountSigningKey(
        did: String,
        signingKey: String
    ) async throws {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.admin.updateAccountSigningKey") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ComAtprotoLexicon.Admin.UpdateAccountSigningKeyRequestBody(
            did: did,
            signingKey: signingKey
        )

        do {
            let request = APIClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: "application/json",
                contentTypeValue: "application/json",
                authorizationValue: "Bearer \(accessToken)"
            )

            _ = try await APIClientService.shared.sendRequest(
                request,
                withEncodingBody: requestBody
            )
        } catch {
            throw error
        }
    }
}
