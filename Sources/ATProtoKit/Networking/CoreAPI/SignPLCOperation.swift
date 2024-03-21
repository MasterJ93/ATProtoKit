//
//  SignPLCOperation.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-16.
//

import Foundation

extension ATProtoKit {
    /// Assigns a PLC task to modify specific values in the document of the requesting DID document.
    ///
    /// - Note: According to the AT Protocol specifications: "Signs a PLC operation to update some value(s) in the requesting DID's document."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.identity.signPlcOperation`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/identity/signPlcOperation.json
    ///
    /// - Parameters:
    ///   - token: A token received from ``ATProtoKit/ATProtoKit/requestPLCOperationSignature()``. Optional.
    ///   - rotationKeys: The rotation keys recommended to be added in the DID document. Optional.
    ///   - alsoKnownAs: An array of aliases of the user account. Optional.
    ///   - verificationMethods: A verification method recommeneded to be added in the DID document. Optional.
    ///   - service: The service endpoint recommended in the DID document. Optional.
    /// - Returns: A `Result`, containing either an ``IdentitySignPLCOperationOutput`` if successful, ot an `Error` if not.
    public func signPLCOperation(token: String, rotationKeys: [String]?, alsoKnownAs: [String]?, verificationMethods: VerificationMethod?, service: ATService?) async throws -> Result<IdentitySignPLCOperationOutput, Error> {
        guard session != nil,
              let accessToken = session?.accessToken else {
            return .failure(ATRequestPrepareError.missingActiveSession)
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.identity.signPLCOperation") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
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
                                                         authorizationValue: "Bearer \(accessToken)")
            let response = try await APIClientService.sendRequest(request,
                                                                  withEncodingBody: requestBody,
                                                                  decodeTo: IdentitySignPLCOperationOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
