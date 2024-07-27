//
//  UpdateHandle.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-10.
//

import Foundation

extension ATProtoKit {

    /// Replaces the user's current handle with a new one.
    ///
    /// - Note: According to the AT Protocol specifications: "Updates the current account's handle.
    /// Verifies handle validity, and updates did:plc document if necessary. Implemented by PDS,
    /// and requires auth."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.identity.updateHandle`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/identity/updateHandle.json
    ///
    /// - Parameter handle: The object which conains the user's new handle.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func updateHandle(_ handle: String) async throws {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.identity.updateHandle") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ComAtprotoLexicon.Identity.UpdateHandleRequestBody(
            handle: handle
        )

        do {
            let request = APIClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
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
