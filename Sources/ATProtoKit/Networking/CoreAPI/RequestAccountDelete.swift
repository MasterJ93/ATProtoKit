//
//  RequestAccountDelete.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-25.
//

import Foundation

extension ATProtoKit {

    /// Requests the server to delete the user's account via email.
    ///
    /// - Warning: Doing this will permanently delete the user's account. Use caution when
    /// using this.
    ///
    /// - Note: According to the AT Protocol specifications: "Initiate a user account deletion
    /// via email."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.requestAccountDelete`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/requestAccountDelete.json
    public func requestAccountDeletion() async throws {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.server.requestAccountDelete") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .post,
                                                         acceptValue: nil,
                                                         contentTypeValue: nil,
                                                         authorizationValue: "Bearer \(accessToken)")

            _ = try await APIClientService.sendRequest(request)
        } catch {
            throw error
        }
    }
}
