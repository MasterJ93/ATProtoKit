//
//  QueryModerationStatusesAsAdmin.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-02.
//

import Foundation

extension ATProtoAdmin {

    /// Gets the moderation statuses of records and repositories.
    /// 
    /// - Important: This is an moderator task and as such, regular users won't be able to
    /// access this; if they attempt to do so, an error will occur.
    ///
    /// - Note: Many of the parameter's descriptions are taken directly from the
    /// AT Protocol's specification.
    ///
    /// - Note: According to the AT Protocol specifications: "View moderation statuses of subjects
    /// (record or repo)."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.queryStatuses`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/queryStatuses.json
    ///
    /// - Parameters:
    ///   - queueCount: The number of queues. Optional.
    ///   - queueIndex: The index of the queue to fetch subjects from. Optional.
    ///   - queueSeed: The seed value to randomize the items.
    ///   - canIncludeAllUserRecords: If true, events on all record types (posts, lists, profile
    ///   etc.) owned by the did are returned. Optional.  Defaults to `false`.
    ///   - subject: The URI of the subject. Optional.
    ///   - comment: A query that makes the list display events with comments containing the
    ///   keywords used here. Optional.
    ///   - reportedAfter: States that the moderator statuses reports displayed should be after
    ///   a specified report date. Optional.
    ///   - reportedBefore: States that the moderator statuses displayed should before a specified
    ///   report date. Optional.
    ///   - reviewedAfter: States that the moderator statuses displayed should be after a specified
    ///   review date. Optional.
    ///   - hostingDeletedAfter: Search subjects where the associated record/account was deleted
    ///   after a given timestamp. Optional.
    ///   - hostingDeletedBefore: Search subjects where the associated record/account was deleted
    ///   before a given timestamp. Optional.
    ///   - hostingUpdatedAfter: Search subjects where the associated record/account was updated
    ///   after a given timestamp. Optional.
    ///   - hostingUpdatedBefore: Search subjects where the associated record/account was updated
    ///   before a given timestamp. Optional.
    ///   - hostingStatuses: Search subjects by the status of the associated record/account.
    ///   Optional.
    ///   - reviewedBefore: States that the moderator statuses displayed should be before a specified
    ///   review date. Optional.
    ///   - shouldIncludeMuted: Indicates whether muted subjects should be included in the results.
    ///   Optional. Defaults to `false`.
    ///   - isOnlyMuted: Indicates whether only muted subjects and reporters will be returned.
    ///   - reviewState: Specify when fetching subjects in a certain state. Optional.
    ///   - ignoreSubjects: An array of records and repositories to ignore. Optional.
    ///   - lastReviewedBy: Specifies the decentralized identifier (DID) of the moderator whose
    ///   reviewed statuses are queried. Optional.
    ///   - sortField: Sets the sort field of the queried array. Optional.
    ///   - sortDirection: Sets the sorting direction of the queried array. Optional.
    ///   - isTakenDown: Indicates whether the queried array contains moderator statuses that have
    ///   records and repositories that have been taken down. Optional.
    ///   - isAppealed: Indicates whether the queried array contains moderator statuses that have
    ///   been appealed. Optional.
    ///   - limit: The number of events that can be displayed at once. Optional. Defaults to `50`.
    ///   - tags: An array of tags that makes the list display events that contains the
    ///   added tags. Optional.
    ///   - excludeTags: An array of tags that makes the list display events that doesn't contain
    ///   the added tags. Optional.
    ///   - cursor: The mark used to indicate the starting point for the next set
    ///   of results. Optional.
    ///   - collections: Sets where the subject belongs to the given collections will be returned.
    ///   - subjectType: The specified subject type for the event. Optional.
    ///   - minimumAccountSuspendCount: The minimum number of accounts that have been suspended.
    ///   Optional. Defaults to `nil`.
    ///   - minimumReportedRecordsCount: The minimum number of reported records. Optional.
    ///   Defaults to `nil`.
    ///   - minimumTakendownRecordsCount: The minimum number of takedown records. Optional.
    ///   Defaults to `nil`.
    ///   - minimumPriorityScore: The minimum score that the subject needs to be at. Optional.
    /// - Returns: An array of all moderation events pertaining a subject, with an optional cursor
    /// to extend the array.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func queryStatuses(
        queueCount: Int? = nil,
        queueIndex: Int? = nil,
        queueSeed: String? = nil,
        canIncludeAllUserRecords: Bool? = nil,
        subject: String? = nil,
        comment: String? = nil,
        reportedAfter: Date? = nil,
        reportedBefore: Date? = nil,
        reviewedAfter: Date? = nil,
        hostingDeletedAfter: Date? = nil,
        hostingDeletedBefore: Date? = nil,
        hostingUpdatedAfter: Date? = nil,
        hostingUpdatedBefore: Date? = nil,
        hostingStatuses: [String]? = nil,
        reviewedBefore: Date? = nil,
        shouldIncludeMuted: Bool? = false,
        isOnlyMuted: Bool? = nil,
        reviewState: String? = nil,
        ignoreSubjects: [String]? = nil,
        lastReviewedBy: String? = nil,
        sortField: ToolsOzoneLexicon.Moderation.QueryStatuses.SortField? = .lastReportedAt,
        sortDirection: ToolsOzoneLexicon.Moderation.QueryStatuses.SortDirection? = .descending,
        isTakenDown: Bool? = nil,
        isAppealed: Bool? = nil,
        limit: Int? = 50,
        tags: [String]? = nil,
        excludeTags: [String]? = nil,
        cursor: String? = nil,
        collections: [String]? = nil,
        subjectType: ToolsOzoneLexicon.Moderation.QueryStatuses.SubjectType? = nil,
        minimumAccountSuspendCount: Int? = nil,
        minimumReportedRecordsCount: Int? = nil,
        minimumTakendownRecordsCount: Int? = nil,
        minimumPriorityScore: Int? = nil
    ) async throws -> ToolsOzoneLexicon.Moderation.QueryStatusesOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.moderation.queryStatuses") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        // queueCount
        if let queueIndex {
            queryItems.append(("queueCount", "\(queueIndex)"))
        }

        // queueIndex
        if let queueCount {
            queryItems.append(("queueIndex", "\(queueCount)"))
        }

        // queueSeed
        if let queueSeed {
            queryItems.append(("queueSeed", queueSeed))
        }
        
        // canIncludeAllUserRecords
        if let canIncludeAllUserRecords {
            queryItems.append(("includeAllUserRecords", "\(canIncludeAllUserRecords)"))
        }
        
        if let subject {
            queryItems.append(("subject", subject))
        }

        // comment
        if let comment {
            queryItems.append(("comment", comment))
        }

        // reportedAfter
        if let reportedAfterDate = reportedAfter, let formattedReportedAfter = CustomDateFormatter.shared.string(from: reportedAfterDate) {
            queryItems.append(("reportedAfter", formattedReportedAfter))
        }

        // hostingDeletedAfter
        if let hostingDeletedAfterDate = hostingDeletedAfter, let formattedHostingDeletedAfter = CustomDateFormatter.shared.string(from: hostingDeletedAfterDate) {
            queryItems.append(("hostingDeletedAfter", "\(formattedHostingDeletedAfter)"))
        }

        // hostingDeletedBefore
        if let hostingDeletedBeforeDate = hostingDeletedBefore, let formattedHostingDeletedBefore = CustomDateFormatter.shared.string(from: hostingDeletedBeforeDate) {
            queryItems.append(("hostingDeletedBefore", formattedHostingDeletedBefore))
        }

        // hostingUpdatedAfter
        if let hostingUpdatedAfterDate = hostingUpdatedAfter, let formattedHostingUpdatedAfter = CustomDateFormatter.shared.string(from: hostingUpdatedAfterDate) {
            queryItems.append(("hostingUpdatedAfter", formattedHostingUpdatedAfter))
        }

        // hostingUpdatedBefore
        if let hostingUpdatedBeforeDate = hostingUpdatedBefore, let formattedHostingUpdatedBefore = CustomDateFormatter.shared.string(from: hostingUpdatedBeforeDate) {
            queryItems.append(("hostingUpdatedBefore", formattedHostingUpdatedBefore))
        }

        // hostingStatuses
        if let hostingStatuses {
            queryItems += hostingStatuses.map { ("hostingStatuses", $0) }
        }

        // reportedBefore
        if let reportedBeforeDate = reportedBefore, let formattedReportedBefore = CustomDateFormatter.shared.string(from: reportedBeforeDate) {
            queryItems.append(("reportedBefore", formattedReportedBefore))
        }

        // reviewedAfter
        if let reviewedAfterDate = reviewedAfter, let formattedreviewedAfter = CustomDateFormatter.shared.string(from: reviewedAfterDate) {
            queryItems.append(("reviewedAfter", formattedreviewedAfter))
        }

        // shouldIncludeMuted (includeMuted)
        if let shouldIncludeMuted {
            queryItems.append(("includeMuted", "\(shouldIncludeMuted)"))
        }

        // isOnlyMuted (onlyMuted)
        if let isOnlyMuted {
            queryItems.append(("onlyMuted", "\(isOnlyMuted)"))
        }

        // reviewState
        if let reviewState {
            queryItems.append(("reviewState", reviewState))
        }

        // ignoreSubjects
        if let ignoreSubjects {
            queryItems += ignoreSubjects.map { ("ignoreSubjects", $0) }
        }

        // lastReviewedBy
        if let lastReviewedBy {
            queryItems.append(("lastReviewedBy", lastReviewedBy))
        }

        // sortField
        if let sortField {
            queryItems.append(("sortField", "\(sortField)"))
        }

        // sortDirection
        if let sortDirection {
            queryItems.append(("sortDirection", "\(sortDirection.rawValue)"))
        }

        // isTakenDown (takendown)
        if let isTakenDown {
            queryItems.append(("takendown", "\(isTakenDown)"))
        }

        // isAppealed (appealed)
        if let isAppealed {
            queryItems.append(("appealed", "\(isAppealed)"))
        }

        // limit
        if let limit {
            let finalLimit = max(1, min(limit, 100))
            queryItems.append(("limit", "\(finalLimit)"))
        }

        // tags
        if let tags {
            queryItems += tags.map { ("tags", $0) }
        }

        // excludeTags
        if let excludeTags {
            queryItems += excludeTags.map { ("excludeTags", $0) }
        }

        // cursor
        if let cursor {
            queryItems.append(("cursor", cursor))
        }

        // collections
        if let collections {
            let cappedCollectionsArray = collections.prefix(20)
            queryItems += cappedCollectionsArray.map { ("collections", $0) }
        }

        // subjectType
        if let subjectType {
            queryItems.append(("subjectType", "\(subjectType.rawValue)"))
        }

        // minimumAccountSuspendCount
        if let minimumAccountSuspendCount {
            queryItems.append(("minAccountSuspendCount", "\(minimumAccountSuspendCount)"))
        }

        // minimumReportedRecordsCount
        if let minimumReportedRecordsCount {
            queryItems.append(("minReportedRecordsCount", "\(minimumReportedRecordsCount)"))
        }

        // minimumTakendownRecordsCount
        if let minimumTakendownRecordsCount {
            queryItems.append(("minTakendownRecordsCount", "\(minimumTakendownRecordsCount)"))
        }

        // minimumPriorityScore
        if let minimumPriorityScore {
            let finalMinimumPriorityScore = max(1, min(minimumPriorityScore, 100))
            queryItems.append(("minPriorityScore", "\(finalMinimumPriorityScore)"))
        }

        let queryURL: URL

        do {
            queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = await APIClientService.createRequest(
                forRequest: queryURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await APIClientService.shared.sendRequest(
                request,
                decodeTo: ToolsOzoneLexicon.Moderation.QueryStatusesOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
