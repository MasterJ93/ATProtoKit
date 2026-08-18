//
//  ToolsOzoneQueueRouteReportsMethod.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-13.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoAdmin {

    /// Routes reports within an ID range to matching queues.
    ///
    /// - Note: According to the AT Protocol specifications: "Route reports within an ID range to
    /// matching queues based."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.queue.routeReports`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/queue/routeReports.json
    ///
    /// - Parameters:
    ///   - reportIDs: A range of report IDs. The first value is the start (inclusive) and the
    ///   second is the end (inclusive). The difference must be less than 5,000.
    /// - Returns: The number of reports assigned to a queue and the number of unmatched reports.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func routeReportsToQueue(
        _ reportIDs: ClosedRange<Int>
    ) async throws -> ToolsOzoneLexicon.Queue.RouteReportsOutput {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.queue.routeReports") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ToolsOzoneLexicon.Queue.RouteReportsRequestBody(
            startReportID: reportIDs.lowerBound,
            endReportID: reportIDs.upperBound
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
                decodeTo: ToolsOzoneLexicon.Queue.RouteReportsOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
