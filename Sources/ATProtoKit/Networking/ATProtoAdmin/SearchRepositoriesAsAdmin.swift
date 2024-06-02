//
//  SearchReposAsAdmin.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-02.
//

import Foundation

extension ATProtoAdmin {

    /// Searches for repositories as an administrator or moderator.
    ///
    /// - Important: This is a moderator task and as such, regular users won't be able to
    /// access this; if they attempt to do so, an error will occur.
    ///
    /// - Note: According to the AT Protocol specifications: "Find repositories based on a search term."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.searchRepos`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/searchRepos.json
    ///
    /// - Parameters:
    ///   - query: The string used against a list of actors. Optional.
    ///   - limit: The number of repositories in the array. Optional. Defaults to `50`. Can only
    ///   choose between `1` and `100`.
    ///   - cursor: The mark used to indicate the starting point for the next set of
    ///   results. Optional.
    /// - Returns: A `Result`, containing either an ``ComAtprotoLexicon/Admin/SearchRepositoriesOutput``
    /// if successful, or an `Error` if not.
    public func searchRepositories(
        _ query: String?,
        withLimitOf limit: Int? = 50,
        cursor: String?
    ) async throws -> Result<ComAtprotoLexicon.Admin.SearchRepositoriesOutput, Error> {
        guard session != nil,
              let accessToken = session?.accessToken else {
            return .failure(ATRequestPrepareError.missingActiveSession)
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.moderation.searchRepos") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        var queryItems = [(String, String)]()

        if let query {
            queryItems.append(("q", query))
        }

        if let limit {
            let finalLimit = max(1, min(limit, 100))
            queryItems.append(("limit", "\(finalLimit)"))
        }

        if let cursor {
            queryItems.append(("cursor", cursor))
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
                                                                  decodeTo: ComAtprotoLexicon.Admin.SearchRepositoriesOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
