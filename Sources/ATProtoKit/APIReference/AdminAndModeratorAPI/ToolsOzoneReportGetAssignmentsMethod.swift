//
//  ToolsOzoneReportGetAssignmentsMethod.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-13.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoAdmin {

    /// Gets assignments for reports.
    ///
    /// - Note: According to the AT Protocol specifications: "Get assignments for reports."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.report.getAssignments`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/report/getAssignments.json
    ///
    /// - Parameters:
    ///   - onlyActive: When `true`, only returns active assignments. Optional. Defaults to `true`.
    ///   - reportIDs: Filter assignments to specific reports. Optional.
    ///   - dids: Filter assignments to specific moderators. Optional.
    ///   - limit: The number of assignments in the array. Optional. Defaults to `50`.
    ///   - cursor: The mark used to indicate the starting point for the next set of
    ///   results. Optional.
    /// - Returns: An array of report moderator assignments, with an optional cursor to extend
    /// the array.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getReportAssignments(
        onlyActive: Bool = true,
        reportIDs: [Int]? = nil,
        dids: [String]? = nil,
        limit: Int = 50,
        cursor: String? = nil
    ) async throws -> ToolsOzoneLexicon.Report.GetAssignmentsOutput {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.report.getAssignments") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        queryItems.append(("onlyActive", "\(onlyActive)"))

        if let reportIDs {
            let cappedReportIDs = reportIDs.prefix(50)
            queryItems += cappedReportIDs.map { ("reportIds", "\($0)") }
        }

        if let dids {
            let cappedDIDs = dids.prefix(50)
            queryItems += cappedDIDs.map { ("dids", $0) }
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
                decodeTo: ToolsOzoneLexicon.Report.GetAssignmentsOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
