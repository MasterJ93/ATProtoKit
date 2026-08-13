//
//  ToolsOzoneReportQueryActivitiesMethod.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-13.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoAdmin {

    /// Queries report activities across all reports.
    ///
    /// - Note: According to the AT Protocol specifications: "Query report activities across all
    /// reports, ordered by createdAt. Used by downstream pollers; for per-report activity history
    /// use listActivities."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.report.queryActivities`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/report/queryActivities.json
    ///
    /// - Parameters:
    ///   - activityTypes: Filter to specific activity types. Optional.
    ///   - createdAfter: Retrieve activities created at or after a given timestamp. Optional.
    ///   - createdBefore: Retrieve activities created at or before a given timestamp. Optional.
    ///   - sortDirection: The direction to sort results. Optional. Defaults to `.descending`.
    ///   - limit: The number of activities in the array. Optional. Defaults to `50`.
    ///   - cursor: The mark used to indicate the starting point for the next set of
    ///   results. Optional.
    /// - Returns: An array of report activities, with an optional cursor to extend the array.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func queryReportActivities(
        activityTypes: [String]? = nil,
        createdAfter: Date? = nil,
        createdBefore: Date? = nil,
        sortDirection: ToolsOzoneLexicon.Report.QueryActivities.SortDirection? = .descending,
        limit: Int = 50,
        cursor: String? = nil
    ) async throws -> ToolsOzoneLexicon.Report.QueryActivitiesOutput {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.report.queryActivities") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        if let activityTypes {
            queryItems += activityTypes.map { ("activityTypes", $0) }
        }

        if let createdAfter, let formatted = CustomDateFormatter.shared.string(from: createdAfter) {
            queryItems.append(("createdAfter", formatted))
        }

        if let createdBefore, let formatted = CustomDateFormatter.shared.string(from: createdBefore) {
            queryItems.append(("createdBefore", formatted))
        }

        if let sortDirection {
            queryItems.append(("sortDirection", sortDirection.rawValue))
        }

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
                decodeTo: ToolsOzoneLexicon.Report.QueryActivitiesOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
