//
//  ToolsOzoneQueueListQueuesMethod.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-13.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoAdmin {

    /// Lists all configured moderation queues with statistics.
    ///
    /// - Note: According to the AT Protocol specifications: "List all configured moderation
    /// queues with statistics."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.queue.listQueues`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/queue/listQueues.json
    ///
    /// - Parameters:
    ///   - isEnabled: Filter by enabled status. Optional.
    ///   - subjectType: Filter queues that handle this subject type. Optional.
    ///   - collection: Filter queues by collection name. Optional.
    ///   - reportTypes: Filter queues that handle any of these report reason types. Optional.
    ///   - limit: The number of queues in the array. Optional. Defaults to `50`.
    ///   - cursor: The mark used to indicate the starting point for the next set of
    ///   results. Optional.
    /// - Returns: An array of moderation queues based on the given filters, with an optional
    /// cursor to extend the array.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func listModerationQueues(
        isEnabled: Bool? = nil,
        subjectType: String? = nil,
        collection: String? = nil,
        reportTypes: [String]? = nil,
        limit: Int = 50,
        cursor: String? = nil
    ) async throws -> ToolsOzoneLexicon.Queue.ListQueuesOutput {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.queue.listQueues") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        if let isEnabled {
            queryItems.append(("enabled", "\(isEnabled)"))
        }

        if let subjectType {
            queryItems.append(("subjectType", subjectType))
        }

        if let collection {
            queryItems.append(("collection", collection))
        }

        if let reportTypes {
            let cappedReportTypes = reportTypes.prefix(10)
            queryItems += cappedReportTypes.map { ("reportTypes", $0) }
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
                decodeTo: ToolsOzoneLexicon.Queue.ListQueuesOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
