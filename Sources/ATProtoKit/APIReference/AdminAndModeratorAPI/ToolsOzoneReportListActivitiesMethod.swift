//
//  ToolsOzoneReportListActivitiesMethod.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-13.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoAdmin {

    /// Lists all activities for a moderation report.
    ///
    /// - Note: According to the AT Protocol specifications: "List all activities for a report,
    /// sorted most-recent-first."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.report.listActivities`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/report/listActivities.json
    ///
    /// - Parameters:
    ///   - reportID: The ID of the report whose activities to list.
    ///   - limit: The number of activities in the array. Optional. Defaults to `50`.
    ///   - cursor: The mark used to indicate the starting point for the next set of
    ///   results. Optional.
    /// - Returns: An array of report activities, with an optional cursor to extend the array.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func listReportActivities(
        reportID: Int,
        limit: Int = 50,
        cursor: String? = nil
    ) async throws -> ToolsOzoneLexicon.Report.ListActivitiesOutput {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.report.listActivities") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        queryItems.append(("reportId", "\(reportID)"))

        let finalLimit = max(1, min(limit, 100))
        queryItems.append(("limit", "\(finalLimit)"))

        if let cursor {
            queryItems.append(("cursor", cursor))
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
                requiresAuthorization: true
            )
            let response = try await apiClientService.sendRequest(
                request,
                decodeTo: ToolsOzoneLexicon.Report.ListActivitiesOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
