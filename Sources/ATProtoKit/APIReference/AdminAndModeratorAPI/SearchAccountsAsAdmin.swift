//
//  SearchAccountsAsAdmin.swift
//
//
//  Created by Christopher Jr Riley on 2024-06-05.
//

import Foundation

extension ATProtoAdmin {

    /// Lists accounts from a search query as an adminstrator.
    /// 
    /// - Important: This is an administrator task and as such, regular users won't be able to
    /// access this; if they attempt to do so, an error will occur.
    /// 
    /// - Note: According to the AT Protocol specifications: "Get list of accounts that matches
    /// your search query."
    /// 
    /// - SeeAlso: This is based on the [`com.atproto.admin.searchAccounts`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/searchAccounts.json
    /// 
    /// - Parameters:
    ///   - email: The email addressed used as the search query. Optional.
    ///   - cursor: The mark used to indicate the starting point for the next set of
    ///   results. Optional.
    ///   - limit: The number of repositories in the array. Optional. Defaults to `50`. Can only
    ///   choose between `1` and `100`.
    /// - Returns: A `Result`, containing either an
    /// ``ComAtprotoLexicon/Admin/SearchAccountsOutput``
    /// if successful, or an `Error` if not.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func searchAccounts(
        by email: String? = nil,
        cursor: String? = nil,
        limit: Int? = 50
    ) async throws -> Result<ComAtprotoLexicon.Admin.SearchAccountsOutput, Error> {
        guard session != nil,
              let accessToken = session?.accessToken else {
            return .failure(ATRequestPrepareError.missingActiveSession)
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.admin.searchAccounts") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        var queryItems = [(String, String)]()

        if let email {
            queryItems.append(("email", email))
        }

        if let cursor {
            queryItems.append(("cursor", cursor))
        }

        if let limit {
            let finalLimit = max(1, min(limit, 100))
            queryItems.append(("limit", "\(finalLimit)"))
        }

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
                                                                  decodeTo: ComAtprotoLexicon.Admin.SearchAccountsOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
