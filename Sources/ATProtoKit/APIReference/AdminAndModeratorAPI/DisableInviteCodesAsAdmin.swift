//
//  DisableInviteCodesAsAdmin.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-28.
//

import Foundation

extension ATProtoAdmin {

    /// Disables some or all of the invite codes for one or more user accounts as an administrator.
    /// 
    /// - Important: This is an administrator task and as such, regular users won't be able to
    /// access this; if they attempt to do so, an error will occur.
    ///
    /// - Note: According to the AT Protocol specifications: "Disable some set of codes and/or
    /// all codes associated with a set of users."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.admin.disableInviteCodes`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/disableInviteCodes.json
    ///
    /// - Parameters:
    ///   - codes: The invite codes to disable.
    ///   - accountDIDs: The decentralized identifiers (DIDs) of the user accounts.
    ///
    ///   - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func disableInviteCodes(
        codes: [String],
        accountDIDs: [String]
    ) async throws {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.admin.disableInviteCodes") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ComAtprotoLexicon.Admin.DisableInviteCodesRequestBody(
            codes: codes,
            accountDIDs: accountDIDs
        )

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .post,
                                                         acceptValue: nil,
                                                         contentTypeValue: "'application/json",
                                                         authorizationValue: "Bearer \(accessToken)")

            try await APIClientService.shared.sendRequest(
                request,
                withEncodingBody: requestBody
            )
        } catch {
            throw error
        }
    }
}
