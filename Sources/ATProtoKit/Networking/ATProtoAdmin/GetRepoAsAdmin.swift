//
//  GetRepoAsAdmin.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-01.
//

import Foundation

extension ATProtoAdmin {
    /// Get details about a repository as an administrator.
    /// 
    /// - Important: This is an administrator task and as such, regular users won't be able to access this; if they attempt to do so, an error will occur.
    /// 
    /// - Parameter repoDID: The decentralized identifier (DID) of the repository.
    /// - Returns: A `Result`, containing either an ``AdminRepoViewDetail`` if successful, or an `Error` if not.
    public func getRepoAsAdmin(_ repoDID: String) async throws -> Result<AdminRepoViewDetail, Error> {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.admin.getRepo") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        let queryItems = [("did", repoDID)]

        do {
            let queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = APIClientService.createRequest(forRequest: queryURL,
                                                         andMethod: .get,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: nil,
                                                         authorizationValue: "Bearer \(session.accessToken)")
            let response = try await APIClientService.sendRequest(request, decodeTo: AdminRepoViewDetail.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
