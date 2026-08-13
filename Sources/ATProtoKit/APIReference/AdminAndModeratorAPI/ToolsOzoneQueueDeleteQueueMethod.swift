//
//  ToolsOzoneQueueDeleteQueueMethod.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-13.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoAdmin {

    /// Deletes a moderation queue.
    ///
    /// - Note: According to the AT Protocol specifications: "Delete a moderation queue.
    /// Optionally migrate reports to another queue."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.queue.deleteQueue`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/queue/deleteQueue.json
    ///
    /// - Parameters:
    ///   - queueID: The ID of the queue to delete.
    ///   - migrateToQueueID: The ID of a queue to migrate reports to. Optional.
    /// - Returns: The deletion result, including whether deletion succeeded and how many
    /// reports were migrated.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func deleteModerationQueue(
        by queueID: Int,
        migrateToQueueID: Int? = nil
    ) async throws -> ToolsOzoneLexicon.Queue.DeleteQueueOutput {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.queue.deleteQueue") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ToolsOzoneLexicon.Queue.DeleteQueueRequestBody(
            queueID: queueID,
            migrateToQueueID: migrateToQueueID
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
                decodeTo: ToolsOzoneLexicon.Queue.DeleteQueueOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
