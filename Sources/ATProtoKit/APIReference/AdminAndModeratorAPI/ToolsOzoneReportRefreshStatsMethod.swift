//
//  ToolsOzoneReportRefreshStatsMethod.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-13.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoAdmin {

    /// Recomputes report statistics for a date range.
    ///
    /// - Note: According to the AT Protocol specifications: "Recompute report statistics for a
    /// date range. Useful for backfilling after failures or data corrections."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.report.refreshStats`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/report/refreshStats.json
    ///
    /// - Parameters:
    ///   - startDate: The start date for recomputation, inclusive (YYYY-MM-DD).
    ///   - endDate: The end date for recomputation, inclusive (YYYY-MM-DD).
    ///   - queueIDs: An optional list of queue IDs to recompute. Optional.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func refreshReportStats(
        startDate: Date,
        endDate: Date,
        queueIDs: [Int]? = nil
    ) async throws {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.report.refreshStats") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        let requestBody = ToolsOzoneLexicon.Report.RefreshStatsRequestBody(
            startDate: dateFormatter.string(from: startDate),
            endDate: dateFormatter.string(from: endDate),
            queueIDs: queueIDs
        )

        do {
            let request = apiClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: nil,
                contentTypeValue: "application/json",
                requiresAuthorization: true
            )
            _ = try await apiClientService.sendRequest(request, withEncodingBody: requestBody)
        } catch {
            throw error
        }
    }
}
