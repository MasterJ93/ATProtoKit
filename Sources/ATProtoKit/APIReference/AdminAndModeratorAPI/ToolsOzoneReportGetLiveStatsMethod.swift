//
//  ToolsOzoneReportGetLiveStatsMethod.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-13.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoAdmin {

    /// Gets live report statistics from the past 24 hours.
    ///
    /// - Note: According to the AT Protocol specifications: "Get live report statistics from the
    /// past 24 hours. Filter by queue, moderator, or report type. Omit all parameters for
    /// aggregate stats."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.report.getLiveStats`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/report/getLiveStats.json
    ///
    /// - Parameters:
    ///   - queueID: Filter stats by queue. Use `-1` for unqueued reports. Optional.
    ///   - moderatorDID: Filter stats by moderator DID. Optional.
    ///   - reportTypes: Filter stats by report types. Optional.
    /// - Returns: Live report statistics for the requested filter.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getLiveReportStats(
        queueID: Int? = nil,
        moderatorDID: String? = nil,
        reportTypes: [String]? = nil
    ) async throws -> ToolsOzoneLexicon.Report.GetLiveStatsOutput {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.report.getLiveStats") else {
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
                decodeTo: ToolsOzoneLexicon.Report.GetLiveStatsOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
