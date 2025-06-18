//
//  ListOptionsAsAdmin.swift
//
//
//  Created by Christopher Jr Riley on 2025-01-01.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoAdmin {

    /// Lists settings that can be filtered.
    /// 
    /// - Note: According to the AT Protocol specifications: "List settings with optional filtering."
    /// 
    /// - SeeAlso: This is based on the [`tools.ozone.setting.listOptions`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/setting/listOptions.json
    /// 
    /// - Parameters:
    ///   - limit: The number of invite codes in the list. Optional. Defaults to `50`.
    ///   - cursor: The mark used to indicate the starting point for the next set
    ///   of results. Optional.
    ///   - scope: The scope of the options. Optional. Defaults to `.instance`.
    ///   - prefix: Filter keys by prefix. Optional.
    ///   - key: Filters the data to include only the specified keys, ignoring any provided prefix.
    ///   Optional.
    /// - Returns: An array of options, with an optional cursor to expand the array.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func listOptions(
        withLimitOf limit: Int? = 50,
        cursor: String? = nil,
        scope: ToolsOzoneLexicon.Setting.ListOptions.Scope? = .instance,
        prefix: String? = nil,
        key: [String]? = []
    ) async throws -> ToolsOzoneLexicon.Setting.ListOptionsOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.setting.listOptions") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        if let cursor {
            queryItems.append(("cursor", cursor))
        }

        if let limit {
            let finalLimit = max(1, min(limit, 100))
            queryItems.append(("limit", "\(finalLimit)"))
        }

        if let scope {
            queryItems.append(("scope", "\(scope)"))
        }
        
        if let prefix {
            queryItems.append(("prefix", prefix))
        }
        
        if let key {
            queryItems += key.map { ("removedLabels", $0) }
        }

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
                decodeTo: ToolsOzoneLexicon.Setting.ListOptionsOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
