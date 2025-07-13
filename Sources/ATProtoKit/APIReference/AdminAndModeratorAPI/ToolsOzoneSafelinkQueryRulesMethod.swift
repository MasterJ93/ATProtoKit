//
//  ToolsOzoneSafelinkQueryRulesMethod.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-07-12.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoAdmin {

    /// Queries URL rule events.
    ///
    /// - Note: According to the AT Protocol specifications: "Query URL safety rules."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.safelink.queryRules`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/safelink/queryRules.json
    ///
    /// - Parameters:
    ///   - cursor: The mark used to indicate the starting point for the next set of results. Optional.
    ///   - limit: The number of events in the array. Optional.
    ///   - urls: An array of filtered results based on URL or domain. Optional.
    ///   - patternType: Filter results based on the pattern type of the URL rule. Optional.
    ///   - actions: An array of filtered results based on the actions of the URL rule. Optional.
    ///   - reason: Filter results based on the reason for the URL rule. Optional.
    ///   - createdBy: Filter results based on the decentralized identifier (DID) of the user account that
    ///   created the URL rules. Optional.
    ///   - sortDirection: Sets the sorting direction of the rules array. Optional.
    /// - Returns: An array of rules based on the filters given, with an optional cursor to extend
    /// the array.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func queryRules(
        cursor: String? = nil,
        limit: Int = 50,
        urls: [URL]? = nil,
        patternType: String? = nil,
        actions: [String]? = nil,
        reason: String? = nil,
        createdBy: String? = nil,
        sortDirection: ToolsOzoneLexicon.Safelink.QueryRules.SortDirection? = .descending
    ) async throws -> ToolsOzoneLexicon.Safelink.QueryRulesOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.safelink.queryRules") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let finalLimit = max(1, min(limit, 100))

        let requestBody = ToolsOzoneLexicon.Safelink.QueryRulesRequestBody(
            cursor: cursor,
            limit: finalLimit,
            urls: urls,
            patternType: patternType,
            actions: actions,
            reason: reason,
            createdBy: createdBy,
            sortDirection: sortDirection
        )

        do {
            let request = apiClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: "application/json",
                contentTypeValue: "application/json",
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await apiClientService.sendRequest(
                request,
                withEncodingBody: requestBody,
                decodeTo: ToolsOzoneLexicon.Safelink.QueryRulesOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
