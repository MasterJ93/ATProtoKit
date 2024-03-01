//
//  GetAccountInfoAsAdmin.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-29.
//

import Foundation

extension ATProtoKit {
    /// Gets details about a user account.
    /// 
    /// - Important: This is an administrator task and as such, regular users won't be able to access this; if they attempt to do so, an error will occur.
    ///
    /// - Parameter accountDID: The decentralized identifier (DID) of the user account.
    /// - Returns: A `Result`, containing either an ``AdminAccountView`` if successful, or an `Error` if not.
    public func getAccountInfoAsAdmin(_ accountDID: String) async throws -> Result<AdminAccountView, Error> {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.admin.getAccountInfo") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        let queryItems = [
            ("did", accountDID)
        ]

        do {
            let queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = APIClientService.createRequest(forRequest: requestURL, andMethod: .get, acceptValue: "application/json", contentTypeValue: nil, authorizationValue: "Bearer \(session.pdsURL)")
            let response = try await APIClientService.sendRequest(request, decodeTo: AdminAccountView.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
