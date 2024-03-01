//
//  GetAccountInfosAsAdmin.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-29.
//

import Foundation

extension ATProtoKit {
    /// Gets details from multiple user accounts.
    /// 
    /// - Important: This is an administrator task and as such, regular users won't be able to access this; if they attempt to do so, an error will occur.
    /// 
    /// - Note: If you need details for just one user account, it's better to simply use ``getAccountInfoAsAdmin(_:)`` instead.
    /// 
    /// - Parameter accountDIDs: An array of decentralized identifiers (DIDs) of user accounts.
    /// - Returns: A `Result`, containing either an ``AdminGetInviteCodesOutput`` if successful, or an `Error` if not.
    public func getAccountInfosAsAdmin(_ accountDIDs: [String]) async throws -> Result<AdminGetAccountInfosOutput, Error> {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.admin.getAccountInfos") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        let queryItems = accountDIDs.map { ("dids", $0) }

        do {
            let queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = APIClientService.createRequest(forRequest: queryURL, andMethod: .get, acceptValue: "application/json", contentTypeValue: nil, authorizationValue: "Bearer \(session.accessToken)")
            let response = try await APIClientService.sendRequest(request, decodeTo: AdminGetAccountInfosOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
