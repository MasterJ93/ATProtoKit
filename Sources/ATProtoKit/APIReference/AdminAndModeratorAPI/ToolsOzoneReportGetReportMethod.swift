//
//  ToolsOzoneReportGetReportMethod.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-13.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoAdmin {

    /// Gets details about a single moderation report by ID.
    ///
    /// - Note: According to the AT Protocol specifications: "Get details about a single moderation
    /// report by ID."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.report.getReport`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/report/getReport.json
    ///
    /// - Parameter id: The ID of the report to retrieve.
    /// - Returns: The moderation report view.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getReport(
        by id: Int
    ) async throws -> ToolsOzoneLexicon.Report.ReportViewDefinition {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.report.getReport") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()
        queryItems.append(("id", "\(id)"))

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
                decodeTo: ToolsOzoneLexicon.Report.ReportViewDefinition.self
            )

            return response
        } catch {
            throw error
        }
    }
}
