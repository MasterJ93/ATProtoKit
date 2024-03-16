//
//  SubmitPLCOperation.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-16.
//

import Foundation

extension ATProtoKit {
    /// Validating a PLC operation.
    /// 
    /// - Parameter operation:
    /// - Returns: A `Result`, containing either an ``IdentitySignPLCOperationOutput`` if successful, or an `Error` if not.
    public func submitPLCOperation(_ operation: UnknownType) async throws -> Result<IdentitySignPLCOperation, Error> {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/`com.atproto.identity.identitySubmitPLCOperation") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
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
            let response = try await APIClientService.sendRequest(request, withEncodingBody: requestBody, decodeTo: IdentitySignPLCOperation.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
