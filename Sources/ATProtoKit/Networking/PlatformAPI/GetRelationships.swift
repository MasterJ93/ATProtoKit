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
    /// - Parameters:
    ///   - actorDID: The decentralized identifier (DID) of the primaty user account.
    ///   - otherDIDs: An array of decentralized identifiers (DIDs) for the other user accounts that the primary user account may be related to. Optional. Current maximum item length is `30`.
    /// - Returns: A `Result`, containing either a ``GraphGetRelationships`` if successful, or an `Error` if not.
    public static func getRelationships(between actorDID: String, and otherDIDs: [String]? = nil, maxLength: Int? = 50, pdsURL: String? = "https://bsky.social") async throws -> Result<GraphGetRelationships, Error> {
        guard let sessionURL = pdsURL,
            let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.graph.getRelationships") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        var queryItems = [(String, String)]()

        queryItems.append(("actor", actorDID))

        if let otherDIDs {
            let cappedOtherDIDsArray = otherDIDs.prefix(30)
            queryItems += cappedOtherDIDsArray.map { ("others", $0) }
        }

        do {
            let queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = APIClientService.createRequest(forRequest: queryURL,
                                                         andMethod: .get,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: nil,
                                                         authorizationValue: nil)
            let response = try await APIClientService.sendRequest(request, decodeTo: GraphGetRelationships.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
