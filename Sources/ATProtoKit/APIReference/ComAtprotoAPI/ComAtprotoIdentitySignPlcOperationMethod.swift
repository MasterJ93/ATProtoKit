//
//  ComAtprotoIdentitySignPlcOperationMethod.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-16.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Assigns a PLC task to modify specific values in the document of the requesting
    /// DID document.
    ///
    /// - Note: According to the AT Protocol specifications: "Signs a PLC operation to update
    /// some value(s) in the requesting DID's document."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.identity.signPlcOperation`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/identity/signPlcOperation.json
    ///
    /// - Parameters:
    ///   - token: A token received from
    ///   ``ATProtoKit/ATProtoKit/requestPLCOperationSignature()``. Optional.
    ///   - rotationKeys: The rotation keys recommended to be added in the DID document. Optional.
    ///   - alsoKnownAs: An array of aliases of the user account. Optional.
    ///   - verificationMethods: A verification method recommeneded to be added in the
    ///   DID document. Optional.
    ///   - service: The service endpoint recommended in the DID document. Optional.
    /// - Returns: A signed PLC operation.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func signPLCOperation(
        token: String,
        rotationKeys: [String]? = nil,
        alsoKnownAs: [String]? = nil,
        verificationMethods: [String:String]?,
        services: [String: ComAtprotoLexicon.Identity.PLCOperationATService]?
    ) async throws -> ComAtprotoLexicon.Identity.SignPLCOperationOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        try await sessionConfiguration?.ensureValidToken()
        let accessToken = try await keychain.retrieveAccessToken()
        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.identity.signPlcOperation") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ComAtprotoLexicon.Identity.SignPLCOperationRequestBody(
            token: token,
            rotationKeys: rotationKeys,
            alsoKnownAs: alsoKnownAs,
            verificationMethods: verificationMethods,
            services: services
        )

        do {
            let request = apiClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: "application/json",
                contentTypeValue: "application/json",
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await apiClientService.sendRequest(
                request,
                withEncodingBody: requestBody,
                decodeTo: ComAtprotoLexicon.Identity.SignPLCOperationOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
