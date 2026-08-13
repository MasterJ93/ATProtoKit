//
//  ToolsOzoneQueueGetAssignmentsMethod.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-13.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoAdmin {

    /// Gets moderator assignments for queues.
    ///
    /// - Note: According to the AT Protocol specifications: "Get moderator assignments, optionally
    /// filtered by active status, queue, or moderator."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.queue.getAssignments`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/queue/getAssignments.json
    ///
    /// - Parameters:
    ///   - onlyActive: When `true`, only returns active assignments. Optional. Defaults to `true`.
    ///   - queueIDs: Filter assignments to specific queues. Optional.
    ///   - dids: Filter assignments to specific moderators. Optional.
    ///   - limit: The number of assignments in the array. Optional. Defaults to `50`.
    ///   - cursor: The mark used to indicate the starting point for the next set of
    ///   results. Optional.
    /// - Returns: An array of queue moderator assignments, with an optional cursor to extend
    /// the array.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getQueueAssignments(
        onlyActive: Bool = true,
        queueIDs: [Int]? = nil,
        dids: [String]? = nil,
        limit: Int = 50,
        cursor: String? = nil
    ) async throws -> ToolsOzoneLexicon.Queue.GetAssignmentsOutput {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.queue.getAssignments") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        queryItems.append(("onlyActive", "\(onlyActive)"))

        if let queueIDs {
            queryItems += queueIDs.map { ("queueIds", "\($0)") }
        }

        if let dids {
            queryItems += dids.map { ("dids", $0) }
        }

        let finalLimit = max(1, min(limit, 100))
        queryItems.append(("limit", "\(finalLimit)"))

        if let cursor {
            queryItems.append(("cursor", cursor))
        }

        let queryURL: URL

        do {
            queryURL = try apiClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = apiClientService.createRequest(
                forRequest: queryURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                requiresAuthorization: true
            )
            let response = try await apiClientService.sendRequest(
                request,
                decodeTo: ToolsOzoneLexicon.Queue.GetAssignmentsOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
