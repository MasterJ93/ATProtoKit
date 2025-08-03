//
//  DisableAccountInvitesAsAdmin.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-28.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoAdmin {

    /// Disables a user account's ability to receive future invite codes as an administrator.
    ///  
    /// - Important: This is an administrator task and as such, regular users won't be able to
    /// access this; if they attempt to do so, an error will occur.
    ///
    /// - Note: According to the AT Protocol specifications: "Disable an account from receiving
    /// new invite codes, but does not invalidate existing codes."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.admin.disableAccountInvites`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/disableAccountInvites.json
    ///
    /// - Parameters:
    ///   - did: The decentralized identifier (DID) of the user account.
    ///   - note: A note on why the account will lose the ability to get new invite codes.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func disableAccountInvites(
        for did: String,
        note: String? = nil
    ) async throws {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        try await sessionConfiguration?.ensureValidToken()
        let accessToken = try await keychain.retrieveAccessToken()

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.admin.disableAccountInvites") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ComAtprotoLexicon.Admin.DisableAccountInvitesRequestBody(
            accountDID: did,
            note: note
        )

        do {
            let request = apiClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: nil,
                contentTypeValue: "application/json",
                authorizationValue: "Bearer \(accessToken)"
            )

            _ = try await apiClientService.sendRequest(
                request,
                withEncodingBody: requestBody
            )
        } catch {
            throw error
        }
    }
}
