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
    /// - Note: According to the AT Protocol specifications: "Submit a moderation report regarding
    /// an atproto account or record. Implemented by moderation services (with PDS proxying),
    /// and requires auth."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.moderation.createReport`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/moderation/createReport.json
    ///
    /// - Parameters:
    ///   - reasonType: The reason for the report.
    ///   - reason: Any additional context accompanying the report. Optional.
    ///   - subject: The responsible party being reported.
    /// - Returns: A `Result`, containing either ``ModerationCreateReportOutput``
    /// if successful, or an `Error` if not.
    public func createReport(with reasonType: ModerationReasonType, withContextof reason: String?,
                             subject: RepositoryReferencesUnion) async throws -> Result<ModerationCreateReportOutput, Error> {
        guard session != nil,
              let accessToken = session?.accessToken else {
            return .failure(ATRequestPrepareError.missingActiveSession)
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.moderation.createReport") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
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
                                                         authorizationValue: "Bearer \(accessToken)")
            let response = try await APIClientService.sendRequest(request,
                                                                  withEncodingBody: requestBody,
                                                                  decodeTo: ModerationCreateReportOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
