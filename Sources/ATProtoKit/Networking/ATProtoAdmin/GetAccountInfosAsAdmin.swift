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
    /// ``getAccountInfo(_:)`` instead.
    ///
    /// - Note: According to the AT Protocol specifications: "Get details about some accounts."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.admin.getAccountInfos`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/getAccountInfos.json
    ///
    /// - Parameter accountDIDs: An array of decentralized identifiers (DIDs) of user accounts.
    /// - Returns: A `Result`, containing either an ``AdminGetInviteCodesOutput``
    /// if successful, or an `Error` if not.
    public func getAccountInfos(_ accountDIDs: [String]) async throws -> Result<AdminGetAccountInfosOutput, Error> {
        guard session != nil,
              let accessToken = session?.accessToken else {
            return .failure(ATRequestPrepareError.missingActiveSession)
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.admin.getAccountInfos") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        let queryItems = accountDIDs.map { ("dids", $0) }

        let queryURL: URL

        do {
            queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = APIClientService.createRequest(forRequest: queryURL,
                                                         andMethod: .get,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: nil,
                                                         authorizationValue: "Bearer \(accessToken)")
            let response = try await APIClientService.sendRequest(request,
                                                                  decodeTo: AdminGetAccountInfosOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
