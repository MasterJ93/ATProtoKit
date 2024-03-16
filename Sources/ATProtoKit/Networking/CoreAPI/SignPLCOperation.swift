//
//  SignPLCOperation.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-16.
//

import Foundation

extension ATProtoKit {
    ///
    /// 
    /// - Parameters:
    ///   - token: A token received from ``ATProtoKit/ATProtoKit/requestPLCOperationSignature()``. Optional.
    ///   - rotationKeys: The rotation keys recommended to be added in the DID document. Optional.
    ///   - alsoKnownAs: An array of aliases of the user account. Optional.
    ///   - verificationMethods: A verification method recommeneded to be added in the DID document. Optional.
    ///   - service: The service endpoint recommended in the DID document. Optional.
    /// - Returns: A `Result`, containing either an ``IdentitySignPLCOperationOutput`` if successful, ot an `Error` if not.
    public func signPLCOperation(token: String, rotationKeys: [String]?, alsoKnownAs: [String]?, verificationMethods: VerificationMethod?, service: ATService?) async throws -> Result<IdentitySignPLCOperationOutput, Error> {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.identity.signPLCOperation") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        let requestBody = IdentitySignPLCOperation(
            token: token,
            rotationKeys: rotationKeys,
            alsoKnownAs: alsoKnownAs,
            verificationMethods: verificationMethods,
            service: service
        )

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .post,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: "application/json",
                                                         authorizationValue: "Bearer \(session.accessToken)")
            let response = try await APIClientService.sendRequest(request, withEncodingBody: requestBody, decodeTo: IdentitySignPLCOperationOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
