//
//  QueryModerationEventsAsAdmin.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-01.
//

import Foundation

extension ATProtoAdmin {

    /// List all moderator events pertaining a subject.
    /// 
    /// - Important: This is an moderator task and as such, regular users won't be able to access
    /// this; if they attempt to do so, an error will occur.
    ///
    /// - Note: Many of the parameter's descriptions are taken directly from the
    /// AT Protocol's specification.
    ///
    /// - Note: According to the AT Protocol specifications: "List moderation events related
    /// to a subject."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.queryEvents`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/queryEvents.json
    ///
    /// - Parameters:
    ///   - eventTypes: An array of event types. Optional.
    ///   - createdBy: The decentralized identifier (DID) of the user who created
    ///   the events. Optional.
    ///   - sortDirection: The direction set for sorting the events. Optional. Defaults
    ///   to `.descending`.
    ///   - createdAfter: States that the moderator events displayed should be after a
    ///   specified date. Optional.
    ///   - createdBefore: States that the moderator events displayed should be before a
    ///   specified date. Optional.
    ///   - subject: The URI of the subject related to the events. Optional.
    ///   - canIncludeAllUserRecords: If true, events on all record types (posts, lists, profile
    ///   etc.) owned by the did are returned. Optional.  Defaults to `false`.
    ///   - limit: The number of events that can be displayed at once. Optional. Defaults to `50`.
    ///   - doesHaveComment: Indicates whether the list should only include events with comments.
    ///   - comment: A query that makes the list display events with comments containing the
    ///   keywords used here. Optional.
    ///   - addedLabels: An array of labels that makes the list display events that have the
    ///   labels added. Optional.
    ///   - removedLabels: An array of labels that makes the list display events that don't have
    ///   the labels added. Optional.
    ///   - addedTags: An array of tags that makes the list display events that contains the
    ///   added tags. Optional.
    ///   - removedTags: An array of tags that makes the list display events that doesn't contain
    ///   the added tags. Optional.
    ///   - reportTypes: An array of report types.
    ///   - cursor: The mark used to indicate the starting point for the next set
    ///   of results. Optional.
    /// - Returns: An array of all moderation events pertaining a subject, with an optional cursor
    /// to extend the array.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func queryEvents(
        _ eventTypes: [String]? = nil,
        createdBy: String? = nil,
        sortDirection: ToolsOzoneLexicon.Moderation.QueryEvents.SortDirection? = .descending,
        createdAfter: Date? = nil,
        createdBefore: Date? = nil,
        subject: String? = nil,
        canIncludeAllUserRecords: Bool? = false,
        limit: Int? = 50,
        doesHaveComment: Bool? = nil,
        comment: String? = nil,
        addedLabels: [String]? = nil,
        removedLabels: [String]? = nil,
        addedTags: [String]? = nil,
        removedTags: [String]? = nil,
        reportTypes: [String]? = nil,
        cursor: String? = nil
    ) async throws -> ToolsOzoneLexicon.Moderation.QueryEventsOutput {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.moderation.queryEvents") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        // eventTypes (types)
        if let eventTypes {
            queryItems += eventTypes.map { ("types", $0) }
        }

        // createdBy
        if let createdBy {
            queryItems.append(("createdBy", createdBy))
        }

        // sortDirection
        if let sortDirection {
            queryItems.append(("sortDirection", "\(sortDirection)"))
        }

        // createdAfter
        if let createdAfterDate = createdAfter, let formattedCreatedAfter = CustomDateFormatter.shared.string(from: createdAfterDate) {
            queryItems.append(("createdAfter", formattedCreatedAfter))
        }

        // createdBefore
        if let createdBeforeDate = createdBefore, let formattedCreatedBefore = CustomDateFormatter.shared.string(from: createdBeforeDate) {
            queryItems.append(("createdBefore", formattedCreatedBefore))
        }

        // subject
        if let subject {
            queryItems.append(("subject", subject))
        }

        // canIncludeAllUserRecords (includeAllUserRecords)
        if let canIncludeAllUserRecords {
            queryItems.append(("includeAllUserRecords", "\(canIncludeAllUserRecords)"))
        }

        // limit
        if let limit {
            let finalLimit = max(1, min(limit, 100))
            queryItems.append(("limit", "\(finalLimit)"))
        }

        // doesHaveComment (hasComment)
        if let doesHaveComment {
            queryItems.append(("hasComment", "\(doesHaveComment)"))
        }

        // comment
        if let comment {
            queryItems.append(("comment", comment))
        }

        // addedLabels
        if let addedLabels {
            queryItems += addedLabels.map { ("addedLabels", $0) }
        }

        // removeLabels
        if let removedLabels {
            queryItems += removedLabels.map { ("removedLabels", $0) }
        }

        // addedTags
        if let addedTags {
            queryItems += addedTags.map { ("addedTags", $0) }
        }

        // removeTags
        if let addedTags {
            queryItems += addedTags.map { ("removedLabels", $0) }
        }

        // reportTypes
        if let reportTypes {
            queryItems += reportTypes.map { ("reportTypes", $0) }
        }

        // cursor
        if let cursor {
            queryItems.append(("cursor", cursor))
        }

        let queryURL: URL

        do {
            queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = APIClientService.createRequest(
                forRequest: queryURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await APIClientService.shared.sendRequest(
                request,
                decodeTo: ToolsOzoneLexicon.Moderation.QueryEventsOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
