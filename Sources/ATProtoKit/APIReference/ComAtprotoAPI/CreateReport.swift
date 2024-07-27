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
    /// - Returns: A view of the newly-created report that will be sent to the moderators.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func createReport(
        with reasonType: ComAtprotoLexicon.Moderation.ReasonTypeDefinition,
        withContextof reason: String? = nil,
        subject: ATUnion.CreateReportSubjectUnion
    ) async throws -> ComAtprotoLexicon.Moderation.CreateReportOutput {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.moderation.createReport") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ComAtprotoLexicon.Moderation.CreateReportRequestBody(
            reasonType: reasonType,
            reason: reason,
            subject: subject
        )

        do {
            let request = APIClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: "application/json",
                contentTypeValue: "application/json",
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await APIClientService.shared.sendRequest(
                request,
                withEncodingBody: requestBody,
                decodeTo: ComAtprotoLexicon.Moderation.CreateReportOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
