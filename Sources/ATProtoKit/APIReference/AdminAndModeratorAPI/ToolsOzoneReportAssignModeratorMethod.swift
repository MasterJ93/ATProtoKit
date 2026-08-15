//
//  ToolsOzoneReportAssignModeratorMethod.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-13.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoAdmin {

    /// Assigns a moderator to a report.
    ///
    /// - Note: According to the AT Protocol specifications: "Assign a report to a user. Defaults
    /// to the caller. Admins may assign to any moderator."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.report.assignModerator`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/report/assignModerator.json
    ///
    /// - Parameters:
    ///   - did: The decentralized identifier (DID) of the moderator to assign. Optional.
    ///   - reportID: The ID of the report to assign.
    ///   - queueID: An optional queue ID to associate the assignment with. Optional.
    ///   - isPermanent: Whether the assignment has no expiry. Optional.
    /// - Returns: The report assignment view.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func assignModeratorToReport(
        _ did: String? = nil,
        reportID: Int,
        queueID: Int? = nil,
        isPermanent: Bool? = nil
    ) async throws -> ToolsOzoneLexicon.Report.ReportAssignmentViewDefinition {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.report.assignModerator") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ToolsOzoneLexicon.Report.AssignModeratorRequestBody(
            reportID: reportID,
            queueID: queueID,
            did: did,
            isPermanent: isPermanent
        )

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
