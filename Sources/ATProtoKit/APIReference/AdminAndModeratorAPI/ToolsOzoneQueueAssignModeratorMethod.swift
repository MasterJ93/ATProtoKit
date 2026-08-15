//
//  ToolsOzoneQueueAssignModeratorMethod.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-13.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoAdmin {

    /// Assigns a moderator to a queue.
    ///
    /// - Note: According to the AT Protocol specifications: "Assign a user to a queue."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.queue.assignModerator`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/queue/assignModerator.json
    ///
    /// - Parameters:
    ///   - did: The decentralized identifier (DID) of the moderator to assign.
    ///   - queueID: The ID of the queue to assign the moderator to.
    /// - Returns: The queue assignment view.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func assignModeratorToQueue(
        _ did: String,
        queueID: Int
    ) async throws -> ToolsOzoneLexicon.Queue.QueueAssignmentViewDefinition {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.queue.assignModerator") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ToolsOzoneLexicon.Queue.AssignModeratorRequestBody(
            queueID: queueID,
            did: did
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
                decodeTo: ToolsOzoneLexicon.Queue.QueueAssignmentViewDefinition.self
            )

            return response
        } catch {
            throw error
        }
    }
}
