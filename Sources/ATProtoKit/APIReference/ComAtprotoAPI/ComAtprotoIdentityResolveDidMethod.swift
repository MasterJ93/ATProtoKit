//
//  ComAtprotoIdentityResolveDidMethod.swift
//
//
//  Created by Christopher Jr Riley on 2025-02-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Resolves the decentralized identifier (DID) to the equivalent DID document.
    /// 
    /// - Note: According to the AT Protocol specifications: "Resolves DID to DID document.
    /// Does not bi-directionally verify handle."
    /// 
    /// - SeeAlso: This is based on the [`com.atproto.identity.resolveDid`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/identity/resolveDid.json
    /// 
    /// - Parameter did: The decentralized identifier (DID) of the user account.
    /// - Returns: The DID document of the user account.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func resolveDID(_ did: String) async throws -> ComAtprotoLexicon.Identity.ResolveDIDOutput {
        guard let requestURL = URL(string: "\(self.pdsURL)/xrpc/com.atproto.identity.resolveDid") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        queryItems.append(("did", did))

        let queryURL: URL

        do {
            queryURL = try apiClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = apiClientService.createRequest(
                forRequest: queryURL,
                andMethod: .post,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: nil
            )
            let response = try await apiClientService.sendRequest(
                request,
                decodeTo: ComAtprotoLexicon.Identity.ResolveDIDOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
