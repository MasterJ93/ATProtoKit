//
//  ResolveIdentity.swift
//
//
//  Created by Christopher Jr Riley on 2025-02-26.
//

import Foundation

extension ATProtoKit {

    /// Resolves a decentralized identifier (DID) and handle to a DID document and verified handle.
    /// 
    /// - Note: According to the AT Protocol specifications: "Resolves an identity (DID or Handle)
    /// to a full identity (DID document and verified handle)."
    /// 
    /// - SeeAlso: This is based on the [`com.atproto.identity.resolveIdentity`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/identity/resolveIdentity.json
    /// 
    /// - Parameter identifier: The decentralized identifier (DID) or handle of the user account.
    /// - Returns: The decentralized identifier (DID), handle, and DID document of the
    /// user account.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func resolveIdentity(_ identifier: String) async throws -> ComAtprotoLexicon.Identity.IdentityInfoDefinition {
        guard let requestURL = URL(string: "\(self.pdsURL)/xrpc/com.atproto.identity.resolveIdentity") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        queryItems.append(("identifier", identifier))

        let queryURL: URL

        do {
            queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = APIClientService.createRequest(
                forRequest: queryURL,
                andMethod: .post,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: nil
            )
            let response = try await APIClientService.shared.sendRequest(
                request,
                decodeTo: ComAtprotoLexicon.Identity.IdentityInfoDefinition.self
            )

            return response
        } catch {
            throw error
        }
    }
}
