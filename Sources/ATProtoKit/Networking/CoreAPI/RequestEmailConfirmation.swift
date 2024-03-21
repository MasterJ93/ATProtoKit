//
//  RequestEmailConfirmation.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-26.
//

import Foundation

extension ATProtoKit {
    /// Requests an email confirmation to verify the email belongs to the user.
    ///
    /// - Note: According to the AT Protocol specifications: "Request an email with a code to confirm ownership of email."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.requestEmailConfirmation`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/requestEmailConfirmation.json
    public func requestEmailConfirmation() async throws {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.server.requestEmailConfirmation") else {
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

