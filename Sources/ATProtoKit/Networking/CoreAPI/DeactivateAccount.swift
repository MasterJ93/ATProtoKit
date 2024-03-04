//
//  DeactiviateAccount.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-24.
//

import Foundation

extension ATProtoKit {
    /// Deactivates the user's account.
    ///
    /// - Note: If you don't add `deleteAfter`, make sure to use `deleteAccount` at some point after. 
    /// 
    /// - Parameter date: The date and time of when the server should delete the account.
    public func deactivateAccount(withDeletedDateOf date: Date) async throws {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.server.deactivateAccount") else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }

        let requestBody = ServerDeactivateAccount(deleteAfter: date)

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
