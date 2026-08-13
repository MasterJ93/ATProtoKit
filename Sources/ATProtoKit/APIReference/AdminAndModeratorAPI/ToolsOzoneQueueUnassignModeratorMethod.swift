//
//  ToolsOzoneQueueUnassignModeratorMethod.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-13.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoAdmin {

    /// Removes a moderator's assignment from a queue.
    ///
    /// - Note: According to the AT Protocol specifications: "Remove a user's assignment
    /// from a queue."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.queue.unassignModerator`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/queue/unassignModerator.json
    ///
    /// - Parameters:
    ///   - did: The decentralized identifier (DID) of the moderator to unassign.
    ///   - queueID: The ID of the queue to unassign the moderator from.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func unassignModeratorFromQueue(
        _ did: String,
        queueID: Int
    ) async throws {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.queue.unassignModerator") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ToolsOzoneLexicon.Queue.UnassignModeratorRequestBody(
            queueID: queueID,
            did: did
        )

        do {
            let request = apiClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: nil,
                contentTypeValue: "application/json",
                requiresAuthorization: true
            )
            _ = try await apiClientService.sendRequest(request, withEncodingBody: requestBody)
        } catch {
            throw error
        }
    }
}
