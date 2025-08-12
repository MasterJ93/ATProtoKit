//
//  ToolsOzoneListVerificationsMethod.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-05-18.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoAdmin {

    /// Displays a list of verifications.
    ///
    /// If `isRevoked` is `nil`, then the list will not filter out the revoking status of the verifications.
    ///
    /// - Note: According to the AT Protocol specifications: "List verifications."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.verification.listVerifications`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/verification/listVerifications.json
    ///
    /// - Parameters:
    ///   - cursor: The mark used to indicate the starting point for the next set of results. Optional.
    ///   - limit: The number of repositories in the array. Optional. Defaults to `50`. Can only
    ///   choose between `1` and `100`.
    ///   - createdAfter: Filter to include verifications completed after this timestamp. Optional.
    ///   - createdBefore: Filter to include verifications completed before this timestamp. Optional.
    ///   - issuers: An array of decentralized identifiers (DIDs) attached to verification issuers. Optional.
    ///   Can contain up to 100 items.
    ///   - subjects: An array of decentralized identifiers (DIDs) attached to verified users. Optional.
    ///   Can contain up to 100 items.
    ///   - sortDirection: The direction the list will be ordered. Optional. Defaults to `.descending`.
    ///   - isRevoked: Filter to determine which revoking status stays in the list. Optional.
    /// - Returns: An array of verifications based on the filter.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func listVerifications(
        cursor: String? = nil,
        limit: Int? = 50,
        createdAfter: Date? = nil,
        createdBefore: Date? = nil,
        issuers: [String]? = nil,
        subjects: [String]? = nil,
        sortDirection: ToolsOzoneLexicon.Verification.ListVerifications.SortDirection? = .descending,
        isRevoked: Bool? = nil
    ) async throws -> ToolsOzoneLexicon.Verification.ListVerificationsOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        try await sessionConfiguration?.ensureValidToken()
        let accessToken = try await keychain.retrieveAccessToken()

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.verification.listVerifications") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        if let cursor {
            queryItems.append(("cursor", cursor))
        }

        if let limit {
            let finalLimit = max(1, min(limit, 100))
            queryItems.append(("limit", "\(finalLimit)"))
        }

        if let createdAfterDate = createdAfter, let formattedCreatedAfter = CustomDateFormatter.shared.string(from: createdAfterDate) {
            queryItems.append(("createdAfter", formattedCreatedAfter))
        }

        if let createdBeforeDate = createdBefore, let formattedCreatedBefore = CustomDateFormatter.shared.string(from: createdBeforeDate) {
            queryItems.append(("createdBefore", formattedCreatedBefore))
        }

        if let issuers {
            let cappedIssuersArray = issuers.prefix(100)
            queryItems += cappedIssuersArray.map { ("issuers", $0) }
        }

        if let subjects {
            let cappedSubjectsArray = subjects.prefix(100)
            queryItems += cappedSubjectsArray.map { ("subjects", $0) }
        }

        if let sortDirection {
            queryItems.append(("sortDirection", "\(sortDirection.rawValue)"))
        }

        if let isRevoked {
            queryItems.append(("isRevoked", "\(isRevoked)"))
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
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await apiClientService.sendRequest(
                request,
                decodeTo: ToolsOzoneLexicon.Verification.ListVerificationsOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
