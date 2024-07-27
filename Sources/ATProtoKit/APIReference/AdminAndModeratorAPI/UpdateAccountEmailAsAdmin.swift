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
    /// - Important: This is an administrator task and as such, regular users won't be able to
    /// access this; if they attempt to do so, an error will occur.
    ///
    /// - Note: According to the AT Protocol specifications: "Administrative action to update an
    /// account's email."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.admin.updateAccountEmail`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/updateAccountEmail.json
    ///
    /// - Parameters:
    ///   - accountDID: The decentralized identifier (DID) of the user account.
    ///   - newEmail: The new email address the user wants to change to.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func updateAccountEmail(
        for accountDID: String,
        newEmail: String
    ) async throws {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.admin.updateAccountEmail") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ComAtprotoLexicon.Admin.UpdateAccountEmailRequestBody(
            accountDID: accountDID,
            accountEmail: newEmail
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
