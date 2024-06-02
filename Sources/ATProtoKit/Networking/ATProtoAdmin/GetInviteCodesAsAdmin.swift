//
//  GetInviteCodesAsAdmin.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-29.
//

import Foundation

extension ATProtoAdmin {

    /// Retrieves the invite codes from a user account.
    /// 
    /// - Important: This is an administrator task and as such, regular users won't be able to
    /// access this; if they attempt to do so, an error will occur.
    ///
    /// - Note: According to the AT Protocol specifications: "Get an admin view of invite codes."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.admin.getInviteCodes`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/getInviteCodes.json
    ///
    /// - Parameters:
    ///   - sort: The order the invite codes will be sorted by. Defaults to `.recent`.
    ///   - limit: The number of invite codes in the list. Defaults to `100`.
    ///   - cursor: The mark used to indicate the starting point for the next set of results. Optional.
    /// - Returns: A `Result`, containing either an ``ComAtprotoLexicon/Admin/GetInviteCodesOutput``
    /// if successful, or an `Error` if not.
    public func getInviteCodes(
        sortedBy sort: ComAtprotoLexicon.Admin.GetInviteCodes.Sort = .recent,
        withLimitOf limit: Int = 100,
        cursor: String?) async throws -> Result<ComAtprotoLexicon.Admin.GetInviteCodesOutput, Error> {
        guard session != nil,
              let accessToken = session?.accessToken else {
            return .failure(ATRequestPrepareError.missingActiveSession)
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.admin.getInviteCodes") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        // Make sure limit is between 1 and 500.
        let finalLimit = max(1, min(limit, 500))
        var queryItems = [
            ("sort", "\(sort)"),
            ("limit", "\(finalLimit)")
        ]

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
                                                                  decodeTo: ComAtprotoLexicon.Admin.GetInviteCodesOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
