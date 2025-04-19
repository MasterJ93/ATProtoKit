//
//  GetValuesAsAdmin.swift
//
//
//  Created by Christopher Jr Riley on 2024-10-24.
//

import Foundation

extension ATProtoAdmin {

    /// Gets a specific set and its values.
    /// 
    /// - Note: According to the AT Protocol specifications: "Get a specific set and its values."
    /// 
    /// - SeeAlso: This is based on the [`tools.ozone.set.getValues`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/set/getValues.json
    /// 
    /// - Parameters:
    ///   - name: The name of the set to retrieve the values from.
    ///   - limit: The number of invite codes in the list. Optional. Defaults to `100`.
    ///   - cursor: The mark used to indicate the starting point for the next set
    ///   of results. Optional.
    /// - Returns: The view of the set and array of values. Optionally, a cursor.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getValues(
        from name: String,
        limit: Int? = 100,
        cursor: String? = nil
    ) async throws -> ToolsOzoneLexicon.Set.GetValuesOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.set.getValues") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [("name", name)]

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

            let request = await APIClientService.createRequest(
                forRequest: queryURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await APIClientService.shared.sendRequest(
                request,
                decodeTo: ToolsOzoneLexicon.Set.GetValuesOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
