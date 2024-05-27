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
    /// - Note: According to the AT Protocol specifications: "Delete an actor's account with a
    /// token and password. Can only be called after requesting a deletion token. Requires auth."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.deleteAccount`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/deleteAccount.json
    ///
    /// - Parameters:
    ///   - accountDID: The decentralized identifier (DID) of the user account to be deleted.
    ///   - password: The password of the user account.
    ///   - token: A token to confirm the deletion of the account.
    public func deleteAccount(_ accountDID: String, password: String, token: String) async throws {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.server.deleteAccount") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ServerDeleteAccount(
            accountDID: accountDID,
            accountPassword: password,
            token: token
        )

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .post,
                                                         acceptValue: nil,
                                                         contentTypeValue: "application/json",
                                                         authorizationValue: "Bearer \(accessToken)")

            try await APIClientService.sendRequest(request,
                                                   withEncodingBody: requestBody)
        } catch {
            throw error
        }
    }
}
