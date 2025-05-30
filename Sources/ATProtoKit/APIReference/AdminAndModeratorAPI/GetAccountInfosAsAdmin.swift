//
//  GetAccountInfosAsAdmin.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-29.
//

import Foundation

extension ATProtoAdmin {

    /// Gets details from multiple user accounts.
    /// 
    /// - Important: This is an administrator task and as such, regular users won't be able to
    /// access this; if they attempt to do so, an error will occur.
    ///
    /// - Note: If you need details for just one user account, it's better to simply use
    /// ``getAccountInfo(for:)`` instead.
    ///
    /// - Note: According to the AT Protocol specifications: "Get details about some accounts."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.admin.getAccountInfos`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/getAccountInfos.json
    ///
    /// - Parameter dids: An array of decentralized identifiers (DIDs) of user accounts.
    /// - Returns: An array of user account information.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getAccountInfos(for dids: [String]) async throws -> ComAtprotoLexicon.Admin.GetAccountInfosOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.admin.getAccountInfos") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let queryItems = dids.map { ("dids", $0) }

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
                decodeTo: ComAtprotoLexicon.Admin.GetAccountInfosOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
