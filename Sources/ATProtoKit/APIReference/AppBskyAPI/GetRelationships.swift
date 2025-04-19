//
//  GetRelationships.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-10.
//

import Foundation

extension ATProtoKit {

    /// Retrieves the public relationship between the two user accounts.
    /// 
    /// - Note: According to the AT Protocol specifications: "Enumerates public relationships
    /// between one account, and a list of other accounts. Does not require auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.graph.getRelationships`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/getRelationships.json
    ///
    /// - Parameters:
    ///   - actor: The AT Identifier of the primaty user account.
    ///   - others: An array of AT Identifiers for the other user accounts
    ///   that the primary user account may be related to. Optional. Current maximum item length
    ///   is `30`.
    /// - Returns: The metadata which containing the relationship between mutliple user accounts,
    /// as well as the decentralized identifier (DID) of the user account that matched
    /// the `actorDID`.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getRelationships(
        between actor: String,
        and others: [String]? = nil
    ) async throws -> AppBskyLexicon.Graph.GetRelationshipsOutput {
        guard self.pdsURL != "" else {
            throw ATRequestPrepareError.emptyPDSURL
        }

        guard let requestURL = URL(string: "\(self.pdsURL)/xrpc/app.bsky.graph.getRelationships") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        queryItems.append(("actor", actor))

        if let others {
            let cappedOthersArray = others.prefix(30)
            queryItems += cappedOthersArray.map { ("others", $0) }
        }

        let queryURL: URL

        do {
            queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = await APIClientService.createRequest(
                forRequest: queryURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: nil
            )
            let response = try await APIClientService.shared.sendRequest(
                request,
                decodeTo: AppBskyLexicon.Graph.GetRelationshipsOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
