//
//  RequestPLCOperationSignature.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-15.
//

import Foundation

extension ATProtoKit {

    /// Sends a request for an email that contains a code for a signed PLC operation.
    ///
    /// - Note: According to the AT Protocol specifications: "Request an email with a code to in
    /// order to request a signed PLC operation. Requires Auth."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.identity.requestPlcOperationSignature`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/identity/requestPlcOperationSignature.json
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func requestPLCOperationSignature() async throws {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.identity.requestPLCOperationSignature") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        do {
            let request = APIClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: nil,
                contentTypeValue: nil,
                authorizationValue: "Bearer \(accessToken)"
            )

            _ = try await APIClientService.shared.sendRequest(request)
        } catch {
            throw error
        }
    }
}
