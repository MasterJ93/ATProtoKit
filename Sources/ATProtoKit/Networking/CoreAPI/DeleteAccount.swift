//
//  DeleteAccount.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-24.
//

import Foundation

extension ATProtoKit {
    /// Deletes a user account from the server.
    /// 
    /// - Note: A request token is required before deleting the account.
    /// 
    /// - Parameters:
    ///   - account: The decentralized identifier (DID) of the user account to be deleted.
    ///   - password: The password of the user account.
    ///   - token: A token to confirm the deletion of the account.
    public func deleteAccount(_ account: String, password: String, token: String) async throws {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.server.deleteAccount") else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }

        let requestBody = ServerDeleteAccount(accountDID: account, accountPassword: password, token: token)

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .post,
                                                         acceptValue: nil,
                                                         contentTypeValue: "application/json",
                                                         authorizationValue: nil)

            try await APIClientService.sendRequest(request, withEncodingBody: requestBody)
        } catch {
            throw error
        }
    }
}
