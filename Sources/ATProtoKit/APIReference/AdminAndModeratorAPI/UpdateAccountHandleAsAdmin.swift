//
//  UpdateAccountHandleAsAdmin.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-03.
//

import Foundation

extension ATProtoAdmin {

    /// Updates the handle of a user account as an administrator.
    /// 
    /// - Note: Many of the parameter's descriptions are taken directly from the
    /// AT Protocol's specification.
    ///
    /// - Note: According to the AT Protocol specifications: "Administrative action to update
    /// an account's handle."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.admin.updateAccountHandle`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/updateAccountHandle.json
    ///
    /// - Parameters:
    ///   - accountDID: The decentralized identifier (DID) of the user account.
    ///   - newAccountHandle: The new handle for the user account.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func updateAccountHandle(
        for accountDID: String,
        newAccountHandle: String
    ) async throws {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.admin.updateAccountHandle") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ComAtprotoLexicon.Admin.UpdateAccountHandleRequestBody(
            accountDID: accountDID,
            accountHandle: newAccountHandle
        )

        do {
            let request = APIClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: nil,
                contentTypeValue: "application/json",
                authorizationValue: "Bearer \(accessToken)"
            )

            try await APIClientService.shared.sendRequest(
                request,
                withEncodingBody: requestBody
            )
        } catch {
            throw error
        }
    }
}
