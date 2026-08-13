//
//  ToolsOzoneQueueUpdateQueueMethod.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-13.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoAdmin {

    /// Updates the properties of a moderation queue.
    ///
    /// - Note: According to the AT Protocol specifications: "Update queue properties."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.queue.updateQueue`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/queue/updateQueue.json
    ///
    /// - Parameters:
    ///   - queueID: The ID of the queue to update.
    ///   - name: A new display name for the queue. Optional.
    ///   - isEnabled: Whether the queue is enabled. Optional.
    ///   - description: A description of the queue. Optional.
    ///   - recommendedPolicies: Recommended policy keys for actioning reports in this queue. Optional.
    /// - Returns: The updated moderation queue.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func updateModerationQueue(
        by queueID: Int,
        name: String? = nil,
        isEnabled: Bool? = nil,
        description: String? = nil,
        recommendedPolicies: [String]? = nil
    ) async throws -> ToolsOzoneLexicon.Queue.UpdateQueueOutput {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.queue.updateQueue") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ToolsOzoneLexicon.Queue.UpdateQueueRequestBody(
            queueID: queueID,
            name: name,
            isEnabled: isEnabled,
            description: description,
            recommendedPolicies: recommendedPolicies
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
                decodeTo: ToolsOzoneLexicon.Queue.UpdateQueueOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
