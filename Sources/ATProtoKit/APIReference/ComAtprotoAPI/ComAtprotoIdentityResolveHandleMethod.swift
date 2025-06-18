//
//  ComAtprotoIdentityResolveHandleMethod.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-27.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Retrieves a decentralized identifier (DID) based on a given handle from a specified
    /// Personal Data Server (PDS).
    ///
    /// - Note: According to the AT Protocol specifications: "Resolves a handle (domain name)
    /// to a DID."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.identity.resolveHandle`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/identity/resolveHandle.json
    ///
    /// - Parameter handle: The handle to resolve into a decentralized identifier (DID).
    /// - Returns: The resolved handle's decentralized identifier (DID).
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func resolveHandle(from handle: String) async throws -> ComAtprotoLexicon.Identity.ResolveHandleOutput {
        guard let requestURL = URL(string: "\(self.pdsURL)/xrpc/com.atproto.identity.resolveHandle") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let queryItems = [
            ("handle", handle)
        ]

        let queryURL: URL

        do {
            queryURL = try apiClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = apiClientService.createRequest(
                forRequest: queryURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: nil
            )
            let response = try await apiClientService.sendRequest(
                request,
                decodeTo: ComAtprotoLexicon.Identity.ResolveHandleOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
