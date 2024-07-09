//
//  CreateInviteCode.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-24.
//

import Foundation

extension ATProtoKit {

    /// Creates an invite code.
    ///
    /// - Note: If you need to create multiple invite codes at once, please use
    /// ``createInviteCodes(_:for:)`` instead.
    ///
    /// - Note: According to the AT Protocol specifications: "Create an invite code."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.createInviteCode`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/createInviteCode.json
    ///
    /// - Parameters:
    ///   - codeCount: The number of invite codes to be created. Defaults to 1.
    ///   - forAccount: The decentralized identifier (DIDs) of the user that can use the
    ///   invite code. Optional.
    /// - Returns: The details of the newly-created invite code.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func createInviteCode(
        _ codeCount: Int = 1,
        for account: [String]
    ) async throws -> ComAtprotoLexicon.Server.CreateInviteCodeOutput {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.server.createInviteCode") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        // Make sure the number isn't lower than one.
        let requestBody = ComAtprotoLexicon.Server.CreateInviteCodeRequestBody(
            useCount: codeCount > 0 ? codeCount : 1,
            forAccount: account
        )

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .post,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: "application/json",
                                                         authorizationValue: "Bearer \(accessToken)")
            let response = try await APIClientService.sendRequest(request,
                                                                  withEncodingBody: requestBody,
                                                                  decodeTo: ComAtprotoLexicon.Server.CreateInviteCodeOutput.self)

            return response
        } catch {
            throw error
        }
    }
}
