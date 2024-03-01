//
//  EnableAccountInvitesAsAdmin.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-29.
//

import Foundation

extension ATProtoKit {
    /// Turns on the ability for the user account to receive invite codes again.
    /// 
    /// This only works if the user account had lost access to this ability.
    /// 
    /// - Important: This is an administrator task and as such, regular users won't be able to access this; if they attempt to do so, an error will occur.
    public func enableAccountInvitesAsAdmin(_ accountDID: String, note: String?) async throws {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.admin.disableAccountInvites") else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }

        let requestBody = AdminEnableAccountInvites(accountDID: accountDID, note: note)

        do {
            let request = APIClientService.createRequest(forRequest: requestURL, andMethod: .post, acceptValue: nil, contentTypeValue: "application/json", authorizationValue: "Bearer \(session.accessToken)")

            try await APIClientService.sendRequest(request, withEncodingBody: requestBody)
        } catch {
            throw error
        }
    }
}
