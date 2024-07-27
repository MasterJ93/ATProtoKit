//
//  ResolveHandle.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-27.
//

import Foundation

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
    /// - Parameters:
    ///   - handle: The handle to resolve into a decentralized identifier (DID).
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `nil`.
    /// - Returns: The resolved handle's decentralized identifier (DID).
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func resolveHandle(
        from handle: String,
        pdsURL: String? = nil
    ) async throws -> ComAtprotoLexicon.Identity.ResolveHandleOutput {
        guard let sessionURL = pdsURL != nil ? pdsURL : session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.identity.resolveHandle") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let queryItems = [
            ("handle", handle)
        ]

        let queryURL: URL

        do {
            queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = APIClientService.createRequest(
                forRequest: queryURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: nil
            )
            let response = try await APIClientService.shared.sendRequest(
                request,
                decodeTo: ComAtprotoLexicon.Identity.ResolveHandleOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
