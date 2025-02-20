//
//  ListMembersAsAdmin.swift
//
//
//  Created by Christopher Jr Riley on 2024-06-29.
//

import Foundation

extension ATProtoAdmin {

    /// Lists all of the ozone service members as an administrator.
    /// 
    /// - Important: This is an administrator task and as such, regular users won't be able to
    /// access this; if they attempt to do so, an error will occur.
    /// 
    /// - Note: According to the AT Protocol specifications: "List all members with access to the
    /// ozone service."
    /// 
    /// - SeeAlso: This is based on the [`tools.ozone.team.listMembers`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/team/listMembers.json
    /// 
    /// - Parameters:
    ///   - isDisabled: Determines whether the members are disabled. Optional.
    ///   - roles: An array of roles for the members. Optional.
    ///   - limit: The number of invite codes in the list. Defaults to `50`.
    ///   - cursor: The mark used to indicate the starting point for the next set
    ///   of results. Optional.
    /// - Returns: An array of members in the ozone service that the administrator is in, with an
    /// optional cursor to extend the array.
    /// 
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func listMembers(
        isDisabled: Bool? = nil,
        roles: [String]? = nil,
        limit: Int? = 50,
        cursor: String? = nil
    ) async throws -> ToolsOzoneLexicon.Team.ListMembersOutput {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.team.listMembers") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        if let limit {
            let finalLimit = max(1, min(limit, 100))
            queryItems.append(("limit", "\(finalLimit)"))
        }

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
                decodeTo: ToolsOzoneLexicon.Team.ListMembersOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
