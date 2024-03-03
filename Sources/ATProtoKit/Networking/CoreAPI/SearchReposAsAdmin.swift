//
//  SearchReposAsAdmin.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-02.
//

import Foundation

extension ATProtoKit {
    /// Searches for repositories as an administrator.
    /// 
    /// - Important: This is an administrator task and as such, regular users won't be able to access this; if they attempt to do so, an error will occur.
    /// 
    /// - Parameters:
    ///   - query: The string used against a list of actors. Optional.
    ///   - limit: The number of repositories in the array. Optional. Defaults to `50`. Can only choose between `1` and `100`.
    ///   - cursor: The mark used to indicate the starting point for the next set of results. Optional.
    /// - Returns: A `Result`, containing either an ``AdminSearchReposOutput`` if successful, or an `Error` if not.
    public func searchReposAsAdmin(_ query: String?, limit: Int? = 50, cursor: String?) async throws -> Result<AdminSearchReposOutput, Error> {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.admin.searchRepos") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        let queryItems = [(String, String)]()

        if let query {
            queryItems.append(("q", query))
        }

        if let limit {
            queryItems.append(("limit", limit))
        }

        if let cursor {
            queryItems.append(("cursor", cursor))
        }

        do {
            let queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = APIClientService.createRequest(forRequest: queryURL, andMethod: .get, acceptValue: "application/json", contentTypeValue: nil, authorizationValue: "Bearer \(session.accessToken)")
            let response = APIClientService.sendRequest(request, decodeTo: AdminSearchReposOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
