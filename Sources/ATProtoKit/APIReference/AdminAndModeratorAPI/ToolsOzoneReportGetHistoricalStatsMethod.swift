//
//  ToolsOzoneReportGetHistoricalStatsMethod.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-13.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoAdmin {

    /// Gets historical daily report statistics.
    ///
    /// - Note: According to the AT Protocol specifications: "Get historical daily report statistics.
    /// Returns a paginated list of daily stat snapshots, newest first. Filter by queue, moderator,
    /// or report type."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.report.getHistoricalStats`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/report/getHistoricalStats.json
    ///
    /// - Parameters:
    ///   - queueID: Filter stats by queue. Use `-1` for unqueued reports. Optional.
    ///   - moderatorDID: Filter stats by moderator DID. Optional.
    ///   - reportTypes: Filter stats by report types. Optional.
    ///   - startDate: The earliest date to include (inclusive). Optional.
    ///   - endDate: The latest date to include (inclusive). Optional.
    ///   - limit: The maximum number of entries to return. Optional. Defaults to `30`.
    ///   - cursor: The mark used to indicate the starting point for the next set of
    ///   results. Optional.
    /// - Returns: An array of daily historical statistics snapshots, with an optional cursor
    /// to extend the array.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getHistoricalReportStats(
        queueID: Int? = nil,
        moderatorDID: String? = nil,
        reportTypes: [String]? = nil,
        startDate: Date? = nil,
        endDate: Date? = nil,
        limit: Int = 30,
        cursor: String? = nil
    ) async throws -> ToolsOzoneLexicon.Report.GetHistoricalStatsOutput {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.report.getHistoricalStats") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        if let queueID {
            queryItems.append(("queueId", "\(queueID)"))
        }

        if let moderatorDID {
            queryItems.append(("moderatorDid", moderatorDID))
        }

        if let reportTypes {
            queryItems += reportTypes.map { ("reportTypes", $0) }
        }

        if let startDate, let formatted = CustomDateFormatter.shared.string(from: startDate) {
            queryItems.append(("startDate", formatted))
        }

        if let endDate, let formatted = CustomDateFormatter.shared.string(from: endDate) {
            queryItems.append(("endDate", formatted))
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
                decodeTo: ToolsOzoneLexicon.Report.GetHistoricalStatsOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
