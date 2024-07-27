//
//  GetAccountInviteCodes.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-25.
//

import Foundation

extension ATProtoKit {

    /// Retrieves the invite codes from the user's account.
    ///
    /// - Note: According to the AT Protocol specifications: "Get all invite codes for the current
    /// account. Requires auth."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.getAccountInviteCodes`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/getAccountInviteCodes.json
    ///
    /// - Parameters:
    ///   - areUsedCodesIncluded: Indicates whether the invite codes that have already been used
    ///   be included in the list. Optional. Defaults to `true`.
    ///   - areEarnedCodesIncluded: Indicates whether the invite codes that the user earned should
    ///   be included in the list. Optional. Defaults to `true`.
    /// - Returns: An array of invite codes being held be the user account.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getAccountInviteCodes(
        _ areUsedCodesIncluded: Bool = true,
        areEarnedCodesIncluded: Bool = true
    ) async throws -> ComAtprotoLexicon.Server.GetAccountInviteCodesOutput {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.server.getAccountInviteCodes") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let queryItems = [
            ("includeUsed", "\(areUsedCodesIncluded)"),
            ("createAvailable", "\(areEarnedCodesIncluded)")
        ]

        let queryURL: URL

        do {
            queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = APIClientService.createRequest(
                forRequest: queryURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await APIClientService.shared.sendRequest(
                request,
                decodeTo: ComAtprotoLexicon.Server.GetAccountInviteCodesOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
