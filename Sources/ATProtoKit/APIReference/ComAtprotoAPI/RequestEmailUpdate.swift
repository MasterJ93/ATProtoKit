//
//  RequestEmailUpdate.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-26.
//

import Foundation

extension ATProtoKit {

    /// Requests a token to be emailed to the user in order to update their email address.
    /// 
    /// - Note: According to the AT Protocol specifications: "Request a token in order to
    /// update email."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.requestEmailUpdate`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/requestEmailUpdate.json
    ///
    /// - Returns: An Indicatation of whether a token is required.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func requestEmailUpdate() async throws -> ComAtprotoLexicon.Server.RequestEmailUpdateOutput {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.server.requestEmailUpdate") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        do {
            let request = APIClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await APIClientService.shared.sendRequest(
                request,
                decodeTo: ComAtprotoLexicon.Server.RequestEmailUpdateOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
