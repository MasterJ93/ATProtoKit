//
//  CreateReport.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-25.
//

import Foundation

extension ATProtoAdmin {
    /// Creates a report to send to moderators.
    /// 
    /// - Parameters:
    ///   - reasonType: The reason for the report.
    ///   - reason: Any additional context accompanying the report. Optional.
    ///   - subject: The responsible party being reported.
    /// - Returns: A `Result`, containing either ``ModerationCreateReportOutput`` if successful, or an `Error` if not.
    public func createReport(with reasonType: ModerationReasonType, withContextof reason: String?,
                             subject: RepoReferencesUnion) async throws -> Result<ModerationCreateReportOutput, Error> {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.moderation.createReport") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        let requestBody = ModerationCreateReport(
            reasonType: reasonType,
            reason: reason,
            subject: subject
        )

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .post,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: "application/json",
                                                         authorizationValue: "Bearer \(session.accessToken)")
            let response = try await APIClientService.sendRequest(request, withEncodingBody: requestBody, decodeTo: ModerationCreateReportOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
