//
//  ComAtprotoLexiconResolveLexiconMethod.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-11-13.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Maps a Namespaced Identifier (NSID) to its corresponding lexicon schema definition.
    ///
    /// - Note: According to the AT Protocol specifications: "Resolves an atproto lexicon (NSID) to
    /// a schema."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.lexicon.resolveLexicon`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/lexicon/resolveLexicon.json
    ///
    /// - Parameter nsid: The lexicon Namespaced Identifier (NSID) to resolve.
    /// - Returns: A record containing the resolved lexicon schema, along with the CID and AT-URI assocated
    /// with the schema.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func resolveLexicon(by nsid: String) async throws -> ComAtprotoLexicon.Lexicon.ResolveLexiconOutput {
        guard let requestURL = URL(string: "\(self.pdsURL)/xrpc/com.atproto.lexicon.resolveLexicon") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        queryItems.append(("nsid", nsid))

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
                decodeTo: ComAtprotoLexicon.Lexicon.ResolveLexiconOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
