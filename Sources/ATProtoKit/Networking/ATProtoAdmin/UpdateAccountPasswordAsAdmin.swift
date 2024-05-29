//
//  UpdateAccountPasswordAsAdmin.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-03.
//

import Foundation

extension ATProtoAdmin {

    /// Updates the password of a user account as an administrator.
    /// 
    /// - Note: According to the AT Protocol specifications: "Update the password for a user
    /// account as an administrator."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.admin.updateAccountPassword`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/updateAccountPassword.json
    ///
    /// - Parameters:
    ///   - accountDID: The decentralized identifier (DID) of the user account.
    ///   - newPassword: The new password for the user account.
    public func updateAccountPassword(
        for accountDID: String,
        newPassword: String
    ) async throws {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.admin.updateAccountPassword") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = AdminUpdateAccountPassword(
            accountDID: accountDID,
            newPassword: newPassword
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
