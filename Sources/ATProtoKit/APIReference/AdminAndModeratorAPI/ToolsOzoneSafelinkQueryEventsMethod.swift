//
//  ToolsOzoneSafelinkQueryEventsMethod.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-07-12.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoAdmin {

    /// Queries URL safety audit events.
    ///
    /// - Note: According to the AT Protocol specifications: "Query URL safety audit events."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.safelink.queryEvents`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/safelink/queryEvents.json
    ///
    /// - Parameters:
    ///   - cursor: The mark used to indicate the starting point for the next set of results. Optional.
    ///   - limit: The number of events in the array. Defaults to `50`. Can only choose between
    ///   `1` and `100`.
    ///   - urls: An array of URLs listed for auditing. Optional.
    ///   - patternType: Filter results based on the selected pattern type. Optional.
    ///   - sortDirection: Sets the sorting direction of the audit array. Optional.
    ///   Defaults to `.descending`.
    public func queryEvents(
        cursor: String? = nil,
        limit: Int = 50,
        urls: [URL]? = nil,
        patternType: String? = nil,
        sortDirection: ToolsOzoneLexicon.Safelink.QueryEvents.SortDirection? = .descending
    ) async throws -> ToolsOzoneLexicon.Safelink.QueryEventsOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.safelink.queryEvents") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let finalLimit = max(1, min(limit, 100))

        let requestBody = ToolsOzoneLexicon.Safelink.QueryEventsRequestBody(
            cursor: cursor,
            limit: finalLimit,
            urls: urls,
            patternType: patternType,
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
                decodeTo: ToolsOzoneLexicon.Safelink.QueryEventsOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
