//
//  UpdateAccountHandleAsAdmin.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-03.
//

import Foundation

extension ATProtoKit {
    /// Updates the handle of a user account as an administrator.
    /// 
    /// - Note: Many of the parameter's descriptions are taken directly from the AT Protocol's specification.
    /// 
    /// - Parameters:
    ///   - accountDID: The decentralized identifier (DID) of the user account.
    ///   - accountHandle: The new handle for the user account.
    public func updateAccountHandleAsAdmin(_ accountDID: String, accountHandle: String) async throws {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.admin.updateAccountHandle") else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }

        let requestBody = AdminUpdateAccountHandle(accountDID: accountDID, accountHandle: accountHandle)

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
