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
    /// - Note: If you don't add `deleteAfter`, make sure to use
    /// ``deleteAccount(_:password:token:)`` at some point after.
    ///
    /// - Note: According to the AT Protocol specifications: "Deactivates a currently active
    /// account. Stops serving of repo, and future writes to repo until reactivated. Used to
    /// finalize account migration with the old host after the account has been activated on
    /// the new host."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.deactivateAccount`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/deactivateAccount.json
    ///
    /// - Parameter date: The date and time of when the server should delete the account.
    public func deactivateAccount(withDeletedDateOf date: Date) async throws {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.server.deactivateAccount") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ServerDeactivateAccount(
            deleteAfter: date
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
