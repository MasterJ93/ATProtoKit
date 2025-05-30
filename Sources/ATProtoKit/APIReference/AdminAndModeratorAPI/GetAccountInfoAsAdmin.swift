//
//  GetAccountInfoAsAdmin.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-29.
//

import Foundation

extension ATProtoAdmin {

    /// Gets details about a user account.
    /// 
    /// - Important: This is an administrator task and as such, regular users won't be able to
    /// access this; if they attempt to do so, an error will occur.
    ///
    /// - Note: If you need to get details of multiple user accounts, use
    /// ``getAccountInfos(for:)`` instead.
    ///
    /// - Note: According to the AT Protocol specifications: "Get details about an account."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.admin.getAccountInfo`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/getAccountInfo.json
    ///
    /// - Parameter did: The decentralized identifier (DID) of the user account.
    /// - Returns: An account view.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getAccountInfo(for did: String) async throws -> ComAtprotoLexicon.Admin.AccountViewDefinition {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.admin.getAccountInfo") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let queryItems = [
            ("did", did)
        ]

        let queryURL: URL

        do {
            queryURL = try apiClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = apiClientService.createRequest(
                forRequest: queryURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await apiClientService.sendRequest(
                request,
                decodeTo: ComAtprotoLexicon.Admin.AccountViewDefinition.self
            )

            return response
        } catch {
            throw error
        }
    }
}
