//
//  EnableAccountInvitesAsAdmin.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-29.
//

import Foundation

extension ATProtoAdmin {

    /// Turns on the ability for the user account to receive invite codes again.
    /// 
    /// This only works if the user account had lost access to this ability.
    /// 
    /// - Important: This is an administrator task and as such, regular users won't be able to
    /// access this; if they attempt to do so, an error will occur.
    ///
    /// - Note: According to the AT Protocol specifications: "Re-enable an account's ability to
    /// receive invite codes."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.admin.enableAccountInvites`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/enableAccountInvites.json
    ///
    /// - Parameters:
    ///   - accountDID: The decentralized identifier (DID) of the user's account.
    ///   - note: A note as to why the user account is getting the ability to receive invite
    ///   codes reinstated. Optional.
    public func enableAccountInvites(
        for accountDID: String,
        note: String?
    ) async throws {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.admin.enableAccountInvites") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = AdminEnableAccountInvites(
            accountDID: accountDID,
            note: note
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
