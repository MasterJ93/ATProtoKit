//
//  ToolsOzoneReportReassignQueueMethod.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-13.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoAdmin {

    /// Reassigns a moderation report to a different queue.
    ///
    /// - Note: According to the AT Protocol specifications: "Manually reassign a report to a
    /// different queue (or unassign it). Records a queueActivity entry on the report."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.report.reassignQueue`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/report/reassignQueue.json
    ///
    /// - Parameters:
    ///   - reportID: The ID of the report to reassign.
    ///   - queueID: The target queue ID. Use `-1` to unassign from any queue.
    ///   - comment: An optional moderator-only note. Optional.
    /// - Returns: The updated moderation report.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func reassignReportQueue(
        reportID: Int,
        queueID: Int,
        comment: String? = nil
    ) async throws -> ToolsOzoneLexicon.Report.ReassignQueueOutput {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.report.reassignQueue") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ToolsOzoneLexicon.Report.ReassignQueueRequestBody(
            reportID: reportID,
            queueID: queueID,
            comment: comment
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
                decodeTo: ToolsOzoneLexicon.Report.ReassignQueueOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
