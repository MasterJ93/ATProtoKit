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
    ///   - actorDID: The decentralized identifier (DID) of the primaty user account.
    ///   - otherDIDs: An array of decentralized identifiers (DIDs) for the other user accounts
    ///   that the primary user account may be related to. Optional. Current maximum item length
    ///   is `30`.
    /// - Returns: A `Result`, containing either a ``GraphGetRelationships``
    /// if successful, or an `Error` if not.
    public func getRelationships(between actorDID: String, and otherDIDs: [String]? = nil, maxLength: Int? = 50,
                                        pdsURL: String? = nil) async throws -> Result<GraphGetRelationships, Error> {
        guard let sessionURL = pdsURL != nil ? pdsURL : session?.pdsURL,
            let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.graph.getRelationships") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        var queryItems = [(String, String)]()

        queryItems.append(("actor", actorDID))

        if let otherDIDs {
            let cappedOtherDIDsArray = otherDIDs.prefix(30)
            queryItems += cappedOtherDIDsArray.map { ("others", $0) }
        }

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
                                                                  decodeTo: GraphGetRelationships.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
