//
//  ComAtprotoServerCreateInviteCodeMethod.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-24.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Creates an invite code.
    ///
    /// - Note: If you need to create multiple invite codes at once, please use
    /// ``createInviteCodes(codeCount:for:)`` instead.
    ///
    /// - Note: According to the AT Protocol specifications: "Create an invite code."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.createInviteCode`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/createInviteCode.json
    ///
    /// - Parameters:
    ///   - codeCount: The number of invite codes to be created. Defaults to 1.
    ///   - account: The decentralized identifier (DID) of the user that can use the invite code.
    ///   Optional.
    /// - Returns: The details of the newly-created invite code.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func createInviteCode(
        _ codeCount: Int = 1,
        for account: String
    ) async throws -> ComAtprotoLexicon.Server.CreateInviteCodeOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        try await sessionConfiguration?.ensureValidToken()
        let accessToken = try await keychain.retrieveAccessToken()
        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.server.createInviteCode") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        // Make sure the number isn't lower than one.
        let requestBody = ComAtprotoLexicon.Server.CreateInviteCodeRequestBody(
            useCount: codeCount > 0 ? codeCount : 1,
            forAccount: account
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
                decodeTo: ComAtprotoLexicon.Server.CreateInviteCodeOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
