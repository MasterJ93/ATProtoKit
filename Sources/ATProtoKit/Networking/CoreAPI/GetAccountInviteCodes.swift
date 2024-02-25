//
//  GetAccountInviteCodes.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-25.
//

import Foundation

extension ATProtoKit {
    /// Retrieves the invite codes from the user's account.
    ///
    /// - Parameters:
    ///   - areUsedCodesIncluded: Indicates whether the invite codes that have already been used be included in the list. Optional. Defaults to `true`.
    ///   - areEarnedCodesIncluded: Indicates whether the invite codes that the user earned should be included in the list. Optional. Defaults to `true`.
    /// - Returns: A `Result`, containing either ``ServerGetAccountInviteCodesOutput`` if successful, and an `Error` if not.
    public func getAccountInviteCodes(_ areUsedCodesIncluded: Bool = true, areEarnedCodesIncluded: Bool = true) async throws -> Result<ServerGetAccountInviteCodesOutput, Error> {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.server.getAccountInviteCodes") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        let queryItems = [
            ("includeUsed", "\(areUsedCodesIncluded)"),
            ("createAvailable", "\(areEarnedCodesIncluded)")
        ]

        do {
            let queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            print("===Query URL: \(queryURL)")

            let request = APIClientService.createRequest(forRequest: queryURL, andMethod: .get, acceptValue: "application/json", contentTypeValue: nil, authorizationValue: "Bearer \(session.accessToken)")
            let response = try await APIClientService.sendRequest(request, decodeTo: ServerGetAccountInviteCodesOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
