//
//  ToolsOzoneReportQueryReportsMethod.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-13.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoAdmin {

    /// Queries moderation reports.
    ///
    /// - Note: According to the AT Protocol specifications: "View moderation reports. Reports are
    /// individual instances of content being reported, as opposed to subject statuses which
    /// aggregate reports at the subject level."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.report.queryReports`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/report/queryReports.json
    ///
    /// - Parameters:
    ///   - status: Filter by report status.
    ///   - queueID: Filter by queue ID. Use `-1` for unassigned reports. Optional.
    ///   - reportTypes: Filter by report types. Optional.
    ///   - subject: Filter by subject DID or AT-URI. Optional.
    ///   - did: Filter by the DID of the subject account. Optional.
    ///   - subjectType: Filter by subject type. Optional.
    ///   - collections: Filter by collections. Optional.
    ///   - reportedAfter: Filter to reports created after a given timestamp. Optional.
    ///   - reportedBefore: Filter to reports created before a given timestamp. Optional.
    ///   - isMuted: Filter by muted status. Optional.
    ///   - assignedTo: Filter by the DID of the assigned moderator. Optional.
    ///   - sortField: The field to sort results by. Optional. Defaults to `.createdAt`.
    ///   - sortDirection: The direction to sort results. Optional. Defaults to `.descending`.
    ///   - limit: The number of reports in the array. Optional. Defaults to `50`.
    ///   - cursor: The mark used to indicate the starting point for the next set of
    ///   results. Optional.
    /// - Returns: An array of moderation reports based on the given filters, with an optional
    /// cursor to extend the array.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func queryReports(
        status: ToolsOzoneLexicon.Report.ReportStatus,
        queueID: Int? = nil,
        reportTypes: [String]? = nil,
        subject: String? = nil,
        did: String? = nil,
        subjectType: String? = nil,
        collections: [String]? = nil,
        reportedAfter: Date? = nil,
        reportedBefore: Date? = nil,
        isMuted: Bool? = nil,
        assignedTo: String? = nil,
        sortField: ToolsOzoneLexicon.Report.QueryReports.SortField? = .createdAt,
        sortDirection: ToolsOzoneLexicon.Report.QueryReports.SortDirection? = .descending,
        limit: Int = 50,
        cursor: String? = nil
    ) async throws -> ToolsOzoneLexicon.Report.QueryReportsOutput {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.report.queryReports") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        queryItems.append(("status", status.rawValue))

        if let queueID {
            queryItems.append(("queueId", "\(queueID)"))
        }

        if let reportTypes {
            queryItems += reportTypes.map { ("reportTypes", $0) }
        }

        if let subject {
            queryItems.append(("subject", subject))
        }

        if let did {
            queryItems.append(("did", did))
        }

        if let subjectType {
            queryItems.append(("subjectType", subjectType))
        }

        if let collections {
            let cappedCollections = collections.prefix(20)
            queryItems += cappedCollections.map { ("collections", $0) }
        }

        if let reportedAfter, let formatted = CustomDateFormatter.shared.string(from: reportedAfter) {
            queryItems.append(("reportedAfter", formatted))
        }

        if let reportedBefore, let formatted = CustomDateFormatter.shared.string(from: reportedBefore) {
            queryItems.append(("reportedBefore", formatted))
        }

        if let isMuted {
            queryItems.append(("isMuted", "\(isMuted)"))
        }

        if let assignedTo {
            queryItems.append(("assignedTo", assignedTo))
        }

        if let sortField {
            queryItems.append(("sortField", sortField.rawValue))
        }

        if let sortDirection {
            queryItems.append(("sortDirection", sortDirection.rawValue))
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
                decodeTo: ToolsOzoneLexicon.Report.QueryReportsOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
