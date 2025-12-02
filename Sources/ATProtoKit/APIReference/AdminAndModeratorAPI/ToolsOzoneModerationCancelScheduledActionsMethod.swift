//
//  ToolsOzoneModerationCancelScheduledActionsMethod.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-11-18.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoAdmin {

    /// Cancels any pending scheduled moderation actions for the specified user accounts.
    ///
    /// - Note: According to the AT Protocol specifications: "Cancel all pending scheduled moderation actions for specified subjects"
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.cancelScheduledActions`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/cancelScheduledActions.json
    ///
    /// - Parameters:
    ///   - subjects: An array of decentralized identifiers (DIDs) for which the cancellations will
    ///   occur on.
    ///   - comment: A comment to attach to the cancellation. Optional.
    /// - Returns: Results of the cancelled pending actions.
    ///
    /// /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func cancelScheduledActions(
        for dids: [String],
        comment: String
    ) async throws -> ToolsOzoneLexicon.Moderation.CancelScheduledActions.CancellationResults {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        try await sessionConfiguration?.ensureValidToken()
        let accessToken = try await keychain.retrieveAccessToken()

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.moderation.cancelScheduledActions") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ToolsOzoneLexicon.Moderation.CancelScheduledActionsRequestBody(
            subjects: dids,
            comment: comment
        )

        do {
            let request = apiClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: "application/json",
                contentTypeValue: "application/json",
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await apiClientService.sendRequest(
                request,
                withEncodingBody: requestBody,
                decodeTo: ToolsOzoneLexicon.Moderation.CancelScheduledActions.CancellationResults.self
            )

            return response
        } catch {
            throw error
        }
    }
}
