//
//  ToolsOzoneQueueCreateQueueMethod.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-13.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoAdmin {

    /// Creates a new moderation queue.
    ///
    /// - Note: According to the AT Protocol specifications: "Create a new moderation queue. A queue
    /// can have optional matching criteria that ozone's queue router will use to match reports. A
    /// queue with no criteria must have reports assigned to it manually via (1) `modTool.meta.queueId`
    /// in `tools.ozone.moderation.emitEvent` or (2) `tools.ozone.report.reassignQueue`."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.queue.createQueue`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/queue/createQueue.json
    ///
    /// - Parameters:
    ///   - name: The display name for the queue.
    ///   - subjectTypes: Subject types this queue accepts. Optional.
    ///   - collection: Collection name for record subjects. Optional.
    ///   - reportTypes: Report reason types for this queue. Optional.
    ///   - description: A description of the queue. Optional.
    ///   - recommendedPolicies: Recommended policy keys for actioning reports in this queue. Optional.
    /// - Returns: The newly created moderation queue.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func createModerationQueue(
        name: String,
        subjectTypes: [String]? = nil,
        collection: String? = nil,
        reportTypes: [String]? = nil,
        description: String? = nil,
        recommendedPolicies: [String]? = nil
    ) async throws -> ToolsOzoneLexicon.Queue.CreateQueueOutput {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.queue.createQueue") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ToolsOzoneLexicon.Queue.CreateQueueRequestBody(
            name: name,
            subjectTypes: subjectTypes,
            collection: collection,
            reportTypes: reportTypes,
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
                decodeTo: ToolsOzoneLexicon.Queue.CreateQueueOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
