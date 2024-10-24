//
//  QuerySetsAsAdmin.swift
//
//
//  Created by Christopher Jr Riley on 2024-10-24.
//

import Foundation

extension ATProtoAdmin {

    /// Queries available sets.
    /// 
    /// - Note: According to the AT Protocol specifications: "Query available sets."
    /// 
    /// - SeeAlso: This is based on the [`tools.ozone.set.querySets`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/set/querySets.json
    /// 
    /// - Parameters:
    ///   - limit: The number of invite codes in the list. Optional. Defaults to `50`.
    ///   - cursor: The mark used to indicate the starting point for the next set
    ///   of results. Optional.
    ///   - namePrefix: Filters query results to include only those sets whose names begin with
    ///   the specified prefix. Optional.
    ///   - sortBy: Defines sorting criteria for sets. Optional. Defaults to `.name`.
    ///   - sortDirection: Defines the sorting direction. Optional. Defaults to `.ascending`.
    /// - Returns: An array of sets. Optionally, a cursor.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func querySets(
        limit: Int? = 50,
        cursor: String? = nil,
        namePrefix: String? = nil,
        sortBy: ToolsOzoneLexicon.Set.QuerySets.SortBy? = .name,
        sortDirection: ToolsOzoneLexicon.Set.QuerySets.SortDirection? = .ascending
    ) async throws -> ToolsOzoneLexicon.Set.QuerySetsOutput {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.set.getValues") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        if let limit {
            let finalLimit = max(1, min(limit, 100))
            queryItems.append(("limit", "\(finalLimit)"))
        }

        if let cursor {
            queryItems.append(("cursor", cursor))
        }

        if let namePrefix {
            queryItems.append(("namePrefix", namePrefix))
        }

        if let sortBy {
            queryItems.append(("sortBy", "\(sortBy)"))
        }

        if let sortDirection {
            queryItems.append(("sortDirection", "\(sortDirection)"))
        }

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
                decodeTo: ToolsOzoneLexicon.Set.QuerySetsOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
