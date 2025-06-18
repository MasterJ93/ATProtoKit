//
//  ComAtprotoIdentityRefreshIdentityMethod.swift
//
//
//  Created by Christopher Jr Riley on 2025-02-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Requests the server to re-resolve a decentralized identity (DID) and handle of a
    /// user account.
    /// 
    /// - Note: According to the AT Protocol specifications: "Request that the server re-resolve
    /// an identity (DID and handle). The server may ignore this request, or require
    /// authentication, depending on the role, implementation, and policy of the server."
    /// 
    /// - SeeAlso: This is based on the [`com.atproto.identity.refreshIdentity`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/identity/refreshIdentity.json
    /// 
    /// - Parameter identifier: The AT-identifier of the user account.
    /// - Returns: The decentralized identifier (DID), handle, and DID document of the
    /// user account.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func refreshIdentity(with identifier: String) async throws -> ComAtprotoLexicon.Identity.IdentityInfoDefinition {
        guard let requestURL = URL(string: "\(self.pdsURL)/xrpc/com.atproto.identity.refreshIdentity") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ComAtprotoLexicon.Identity.RefreshIdentityRequestBody(
            identifier: identifier
        )

        do {
            let request = apiClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: "application/json",
                contentTypeValue: "application/json",
                authorizationValue: nil
            )

            let response = try await apiClientService.sendRequest(
                request,
                withEncodingBody: requestBody,
                decodeTo: ComAtprotoLexicon.Identity.IdentityInfoDefinition.self
            )

            return response
        } catch {
            throw error
        }
    }
}
