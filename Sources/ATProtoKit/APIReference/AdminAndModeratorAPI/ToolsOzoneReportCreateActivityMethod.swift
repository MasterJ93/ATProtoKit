//
//  ToolsOzoneReportCreateActivityMethod.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-13.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoAdmin {

    /// Registers an activity on a moderation report.
    ///
    /// - Note: According to the AT Protocol specifications: "Register an activity on a report. For
    /// state-change activity types, validates the transition and updates report.status atomically."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.report.createActivity`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/report/createActivity.json
    ///
    /// - Parameters:
    ///   - activity: The type of activity to record.
    ///   - reportID: The ID of the report to record activity on. Optional.
    ///   - eventID: The ID of the report moderation event. Optional.
    ///   - internalNote: An optional moderator-only note. Optional.
    ///   - publicNote: An optional public-facing note. Optional.
    ///   - isAutomated: Whether this activity is triggered by an automated process. Optional.
    /// - Returns: The recorded activity view.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func createReportActivity(
        _ activity: ToolsOzoneLexicon.Report.ActivityUnion,
        reportID: Int? = nil,
        eventID: Int? = nil,
        internalNote: String? = nil,
        publicNote: String? = nil,
        isAutomated: Bool? = nil
    ) async throws -> ToolsOzoneLexicon.Report.CreateActivityOutput {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.report.createActivity") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ToolsOzoneLexicon.Report.CreateActivityRequestBody(
            reportID: reportID,
            eventID: eventID,
            activity: activity,
            internalNote: internalNote,
            publicNote: publicNote,
            isAutomated: isAutomated
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
                decodeTo: ToolsOzoneLexicon.Report.CreateActivityOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
