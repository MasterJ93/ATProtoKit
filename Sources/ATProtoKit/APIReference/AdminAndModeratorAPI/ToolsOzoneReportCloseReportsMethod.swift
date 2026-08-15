//
//  ToolsOzoneReportCloseReportsMethod.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-13.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoAdmin {

    /// Closes all reports on a subject matching the given criteria.
    ///
    /// - Note: According to the AT Protocol specifications: "Close all reports on a subject
    /// matching the given criteria. Reports whose current status does not permit a transition
    /// to closed are skipped silently. Intended for automated flows that resolve reports
    /// without taking action on the subject."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.report.closeReports`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/report/closeReports.json
    ///
    /// - Parameters:
    ///   - subject: The subject whose reports should be closed. Can be a decentralized
    ///   identifier (DID) for account-level reports or an AT-URI for record-level reports.
    ///   - reportTypes: A filter of report types (fully qualified reason NSIDs) to close.
    ///   Optional. When omitted, all non-closed reports on the subject are targeted.
    ///   - internalNote: A moderator-only note recorded on each close activity. Optional.
    ///   - isAutomated: Determines whether this action is triggered by an automated process.
    ///   Optional. Defaults to `false`.
    /// - Returns: The number of closed reports, as well as an array of their IDs.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func closeReports(
        subject: String,
        reportTypes: [String]? = nil,
        internalNote: String? = nil,
        isAutomated: Bool? = nil
    ) async throws -> ToolsOzoneLexicon.Report.CloseReportsOutput {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.report.closeReports") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ToolsOzoneLexicon.Report.CloseReportsRequestBody(
            subject: subject,
            reportTypes: reportTypes,
            internalNote: internalNote,
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
                decodeTo: ToolsOzoneLexicon.Report.CloseReportsOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
