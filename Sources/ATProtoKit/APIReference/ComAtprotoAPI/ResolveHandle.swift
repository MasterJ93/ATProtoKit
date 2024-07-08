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
    /// - Returns: A `Result`, containing either a
    /// ``ComAtprotoLexicon/Identity/ResolveHandleOutput``
    /// if successful, or an `Error` if not.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func resolveHandle(
        from handle: String,
        pdsURL: String? = nil
    ) async throws -> Result<ComAtprotoLexicon.Identity.ResolveHandleOutput, Error> {
        guard let sessionURL = pdsURL != nil ? pdsURL : session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.identity.resolveHandle") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
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

            let request = APIClientService.createRequest(forRequest: queryURL,
                                                         andMethod: .get,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: nil,
                                                         authorizationValue: nil)
            let response = try await APIClientService.sendRequest(request,
                                                                  decodeTo: ComAtprotoLexicon.Identity.ResolveHandleOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
