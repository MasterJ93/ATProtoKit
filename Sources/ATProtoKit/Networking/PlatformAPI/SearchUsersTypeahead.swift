//
//  SearchUsersTypeahead.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-23.
//

import Foundation

extension ATProtoKit {
    /// Looks for user profiles (actors) matching the prefixed search term.
    ///
    /// This will search for the display names, descriptions, and handles within the user profiles.
    ///
    /// - Bug: According to the AT Protocol specifications, this API call does not require authentication. However, there's an issue where it asks for authentication if there's no `accessToken`. It's unknown whether this is an issue on the AT Protocol's end or `AKProtoKit`'s end. For now, use the `accessToken` parameter when using this method.
    /// - Parameters:
    ///   - query: The string used against a list of actors.
    ///   - limit: The number of suggested users to follow. Optional. Defaults to 50. Can only choose between 1 and 100.
    ///   - accessToken: The access token
    ///   - pdsURL: The URL of the Personal Data Server. Defaults to `https://bsky.social`.
    /// - Returns: A `Result`, containing either ``ActorSearchActorsOutput`` if successful, and an `Error` if not.
    public static func searchUsersTypeahead(by query: String, limit: Int? = 10, accessToken: String? = nil, pdsURL: String? = "https://bsky.social") async throws -> Result<ActorSearchActorsTypeaheadOutput, Error> {
        let finalPDSURL = determinePDSURL(accessToken: accessToken, customPDSURL: pdsURL)

        guard let requestURL = URL(string: "\(finalPDSURL)/xrpc/app.bsky.actor.searchActors") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        // Use guard to check if accessToken is non-nil and non-empty, otherwise set authorizationValue to nil.
        let authorizationValue: String? = {
            guard let token = accessToken, !token.isEmpty else { return nil }
            return "Bearer \(token)"
        }()

        // Make sure limit is between 1 and 100. If no value is given, set it to 25.
        let finalLimit = max(1, min(limit ?? 10, 100))

        let queryItems = [
            ("q", query),
            ("limit", "\(finalLimit)")
        ]

        do {
            let queryURL = try APIClientService.setQueryItems(for: requestURL, with: queryItems)

            let request = APIClientService.createRequest(forRequest: queryURL, andMethod: .get, acceptValue: "application/json", authorizationValue: authorizationValue)
            let response = try await APIClientService.sendRequest(request, decodeTo: ActorSearchActorsTypeaheadOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
