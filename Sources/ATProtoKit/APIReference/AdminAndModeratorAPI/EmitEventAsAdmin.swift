//
//  EmitEventAsAdmin.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-29.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoAdmin {

    /// Enacts on an action against a user's account as a moderator.
    ///
    /// - Important: This is a moderator task and as such, regular users won't be able to access
    /// this; if they attempt to do so, an error will occur.
    ///
    /// - Note: According to the AT Protocol specifications: "Take a moderation action on
    /// an actor."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.emitEvent`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/emitEvent.json
    ///
    /// - Parameters:
    ///   - event: The type of event the moderator is taking,
    ///   - subject: The type of repository reference.
    ///   - subjectBlobCIDs: An array of CID hashes related to blobs for the moderator's
    ///   event view. Optional.
    ///   - createdBy: The decentralized identifier (DID) of the moderator taking this action.
    /// - Returns: A moderation event view.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func emitEvent(
        _ event: ToolsOzoneLexicon.Moderation.EmitEventRequestBody.EmitEventUnion,
        subject: ToolsOzoneLexicon.Moderation.EmitEventRequestBody.EmitEventSubjectUnion,
        subjectBlobCIDs: [String]? = nil,
        createdBy: String
    ) async throws -> ToolsOzoneLexicon.Moderation.ModerationEventViewDefinition {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.moderation.emitEvent") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ToolsOzoneLexicon.Moderation.EmitEventRequestBody(
            event: event,
            subject: subject,
            subjectBlobCIDs: subjectBlobCIDs,
            createdBy: createdBy
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
                decodeTo: ToolsOzoneLexicon.Moderation.ModerationEventViewDefinition.self
            )

            return response
        } catch {
            throw error
        }
    }
}
