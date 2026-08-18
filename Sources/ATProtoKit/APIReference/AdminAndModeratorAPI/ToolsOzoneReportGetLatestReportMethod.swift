//
//  ToolsOzoneReportGetLatestReportMethod.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-13.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoAdmin {

    /// Gets the most recent moderation report.
    ///
    /// - Note: According to the AT Protocol specifications: "Get the most recent report."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.report.getLatestReport`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/report/getLatestReport.json
    ///
    /// - Returns: The most recent moderation report.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getLatestReport() async throws -> ToolsOzoneLexicon.Report.GetLatestReportOutput {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.report.getLatestReport") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        do {
            let request = apiClientService.createRequest(
                forRequest: requestURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                requiresAuthorization: true
            )
            let response = try await apiClientService.sendRequest(
                request,
                decodeTo: ToolsOzoneLexicon.Report.GetLatestReportOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
