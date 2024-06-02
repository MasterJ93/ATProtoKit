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
    /// ``getAccountInfos(_:)`` instead.
    ///
    /// - Note: According to the AT Protocol specifications: "Get details about an account."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.admin.getAccountInfo`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/getAccountInfo.json
    ///
    /// - Parameter accountDID: The decentralized identifier (DID) of the user account.
    /// - Returns: A `Result`, containing either an ``ComAtprotoLexicon/Admin/AccountViewDefinition``
    /// if successful, or an `Error` if not.
    public func getAccountInfo(_ accountDID: String) async throws -> Result<ComAtprotoLexicon.Admin.AccountViewDefinition, Error> {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.admin.getAccountInfo") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        let queryItems = [
            ("did", accountDID)
        ]

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
                                                                  decodeTo: ComAtprotoLexicon.Admin.AccountViewDefinition.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
