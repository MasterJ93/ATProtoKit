//
//  SignatureSearchAccountsAsAdmin.swift
//
//
//  Created by Christopher Jr Riley on 2024-10-24.
//

import Foundation

extension ATProtoAdmin {

    /// Searches user accounts that match one or more threat signature values.
    ///
    /// - Note: According to the AT Protocol specifications: "Search for accounts that match one or
    /// more threat signature values."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.signature.searchAccounts`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/signature/searchAccounts.json
    ///
    public func searchAccounts(
        matching values: [String],
        cursor: String? = nil,
        limit: Int? = 50
    ) async throws -> ToolsOzoneLexicon.Signature.SearchAccountsOutput {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.signature.searchAccounts") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        queryItems += values.map { ("values", $0) }

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

            let request = APIClientService.createRequest(
                forRequest: queryURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await APIClientService.shared.sendRequest(
                request,
                decodeTo: ToolsOzoneLexicon.Signature.SearchAccountsOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
