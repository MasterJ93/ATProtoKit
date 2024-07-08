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
    ///   - subject: The URI of the subject. Optional.
    ///   - comment: A query that makes the list display events with comments containing the
    ///   keywords used here. Optional.
    ///   - reportedAfter: States that the moderator statuses reports displayed should be after
    ///   a specified report date. Optional.
    ///   - reportedBefore: States that the moderator statuses displayed should before a specified
    ///   report date. Optional.
    ///   - reviewedAfter: States that the moderator statuses displayed should be after a specified
    ///   review date. Optional.
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
    ///   - cursor: The mark used to indicate the starting point for the next set of
    ///   results. Optional.
    /// - Returns: A `Result`, containing either an
    /// ``ToolsOzoneLexicon/Moderation/QueryStatusesOutput``
    /// if successful, or an `Error` if not.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func queryStatuses(
        _ subject: String?,
        comment: String?,
        reportedAfter: Date?,
        reportedBefore: Date?,
        reviewedAfter: Date?,
        reviewedBefore: Date?,
        shouldIncludeMuted: Bool? = false,
        isOnlyMuted: Bool?,
        reviewState: String?,
        ignoreSubjects: [String]?,
        lastReviewedBy: String?,
        sortField: ToolsOzoneLexicon.Moderation.QueryStatuses.SortField? = .lastReportedAt,
        sortDirection: ToolsOzoneLexicon.Moderation.QueryStatuses.SortDirection? = .descending,
        isTakenDown: Bool?,
        isAppealed: Bool?,
        limit: Int? = 50,
        tags: [String]?,
        excludeTags: [String]?,
        cursor: String?
    ) async throws -> Result<ToolsOzoneLexicon.Moderation.QueryStatusesOutput, Error> {
        guard session != nil,
              let accessToken = session?.accessToken else {
            return .failure(ATRequestPrepareError.missingActiveSession)
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.moderation.queryStatuses") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        var queryItems = [(String, String)]()

        // comment
        if let comment {
            queryItems.append(("comment", comment))
        }

        // reportedAfter
        if let reportedAfterDate = reportedAfter, let formattedReportedAfter = CustomDateFormatter.shared.string(from: reportedAfterDate) {
            queryItems.append(("reportedAfter", formattedReportedAfter))
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
            queryItems.append(("sortDirection", "\(sortDirection)"))
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

        let queryURL: URL

        do {
            queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = APIClientService.createRequest(forRequest: queryURL,
                                                         andMethod: .get,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: nil,
                                                         authorizationValue: "Bearer \(accessToken)")
            let response = try await APIClientService.sendRequest(request,
                                                                  decodeTo: ToolsOzoneLexicon.Moderation.QueryStatusesOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
