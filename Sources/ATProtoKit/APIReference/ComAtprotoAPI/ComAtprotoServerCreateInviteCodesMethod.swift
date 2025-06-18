//
//  ComAtprotoServerCreateInviteCodesMethod.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-24.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Creates several invite codes.
    /// 
    /// - Note: According to the AT Protocol specifications: "Create invite codes."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.createInviteCodes`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/createInviteCodes.json
    ///
    /// - Parameters:
    ///   - codeCount: The number of invite codes to be created. Defaults to `1`.
    ///   - accounts: An array of decentralized identifiers (DIDs) that can use the invite codes.
    /// - Returns: An array of newly-created invide codes.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func createInviteCodes(
        codeCount: Int = 1,
        for accounts: [String]
    ) async throws -> ComAtprotoLexicon.Server.CreateInviteCodesOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.server.createInviteCodes") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        // Make sure the number isn't lower than one.
        let requestBody = ComAtprotoLexicon.Server.CreateInviteCodesRequestBody(
            useCount: codeCount > 0 ? codeCount : 1,
            forAccounts: accounts
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
                decodeTo: ComAtprotoLexicon.Server.CreateInviteCodesOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
