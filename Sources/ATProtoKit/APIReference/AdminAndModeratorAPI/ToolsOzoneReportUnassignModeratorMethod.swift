//
//  ToolsOzoneReportUnassignModeratorMethod.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-13.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoAdmin {

    /// Removes a report assignment.
    ///
    /// - Note: According to the AT Protocol specifications: "Remove report assignment."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.report.unassignModerator`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/report/unassignModerator.json
    ///
    /// - Parameter reportID: The ID of the report to unassign.
    /// - Returns: The updated report assignment view.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func unassignModeratorFromReport(
        _ reportID: Int
    ) async throws -> ToolsOzoneLexicon.Report.ReportAssignmentViewDefinition {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.report.unassignModerator") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ToolsOzoneLexicon.Report.UnassignModeratorRequestBody(reportID: reportID)

        do {
            let request = apiClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: "application/json",
                contentTypeValue: "application/json",
                requiresAuthorization: true
            )
            let response = try await apiClientService.sendRequest(
                request,
                withEncodingBody: requestBody,
                decodeTo: ToolsOzoneLexicon.Report.ReportAssignmentViewDefinition.self
            )

            return response
        } catch {
            throw error
        }
    }
}
