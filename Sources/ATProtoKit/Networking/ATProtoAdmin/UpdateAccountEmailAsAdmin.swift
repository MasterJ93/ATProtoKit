//
//  UpdateAccountEmailAsAdmin.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-02.
//

import Foundation

extension ATProtoAdmin {
    /// Updates the email address of a user account as an administrator.
    /// 
    /// - Important: This is an administrator task and as such, regular users won't be able to access this; if they attempt to do so, an error will occur.
    ///
    /// - Note: Many of the parameter's descriptions are taken directly from the AT Protocol's specification.
    /// 
    /// - Parameters:
    ///   - accountDID: The decentralized identifier (DID) of the user account.
    ///   - newEmail: The new email address the user wants to change to.
    public func updateAccountEmail(for accountDID: String, newEmail: String) async throws {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.admin.updateAccountEmail") else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }

        let requestBody = AdminUpdateAccountEmail(accountDID: accountDID, accountEmail: newEmail)

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .post,
                                                         acceptValue: nil,
                                                         contentTypeValue: "application/json",
                                                         authorizationValue: "Bearer \(session.accessToken)")

            try await APIClientService.sendRequest(request, withEncodingBody: requestBody)
        } catch {
            throw error
        }
    }
}
