//
//  SubmitPLCOperation.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-16.
//

import Foundation

extension ATProtoKit {

    /// Validates a PLC operation.
    ///
    /// - Note: According to the AT Protocol specifications: "Validates a PLC operation to ensure
    /// that it doesn't violate a service's constraints or get the identity into a bad state, then submits
    /// it to the PLC registry."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.identity.submitPlcOperation`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/identity/submitPlcOperation.json
    ///
    /// - Parameter operation:
    public func submitPLCOperation(_ operation: UnknownType) async throws {
        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.identity.identitySubmitPLCOperation") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ComAtprotoLexicon.Identity.SubmitPLCOperationRequestBody(
            operation: operation
        )

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .post,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: nil,
                                                         authorizationValue: nil)
            try await APIClientService.sendRequest(request,
                                                   withEncodingBody: requestBody)
        } catch {
            throw error
        }
    }
}
