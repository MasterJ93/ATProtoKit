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
    /// - Note: According to the AT Protocol specifications: "Validates a PLC operation to ensure that it doesn't violate a service's constraints or get the identity into a bad state, then submits it to the PLC registry."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.identity.submitPlcOperation`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/identity/submitPlcOperation.json
    ///
    /// - Parameter operation:
    /// - Returns: A `Result`, containing either an ``IdentitySignPLCOperationOutput`` if successful, or an `Error` if not.
    public func submitPLCOperation(_ operation: UnknownType) async throws -> Result<IdentitySignPLCOperation, Error> {
        guard session != nil,
              let accessToken = session?.accessToken else {
            return .failure(ATRequestPrepareError.missingActiveSession)
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.identity.identitySubmitPLCOperation") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        let requestBody = IdentitySignPLCOperationOutput(
            operation: operation
        )

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .post,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: nil,
                                                         authorizationValue: nil)
            let response = try await APIClientService.sendRequest(request,
                                                                  withEncodingBody: requestBody,
                                                                  decodeTo: IdentitySignPLCOperation.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
