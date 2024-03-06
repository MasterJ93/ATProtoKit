//
//  GetPostThread.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-05.
//

import Foundation

extension ATProtoKit {
    /// Retrieves a post thread.
    /// 
    /// - Parameters:
    ///   - postURI: The URI of the post.
    ///   - depth: The number of reply layers that can be included in the result. Optional. Defaults to `6`. Can be between `0` and `1000`.
    ///   - parentHeight: The number of parent layers that can be included in the result. Optional. Defaults to `80`. Can be between `0` and `1000`.
    ///   - accessToken: The token used to authenticate the user. Optional.
    ///   - pdsURL: The URL for the Personal Data Server (PDS). Optional. Defaults to `https://bsky.social`.
    /// - Returns: A `Result`, containing either a ``FeedGetPostThreadOutput`` if successful, or an `Error` if not.
    public static func getPostThread(from postURI: String, depth: Int? = 6, parentHeight: Int? = 80,
                                     accessToken: String? = nil,
                                     pdsURL: String = "https://bsky.social") async throws -> Result<FeedGetPostThreadOutput, Error> {
        guard let requestURL = URL(string: "\(pdsURL)/xrpc/app.bsky.feed.getPostThread") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        // Use guard to check if accessToken is non-nil and non-empty, otherwise set authorizationValue to nil.
        let authorizationValue: String? = {
            guard let token = accessToken, !token.isEmpty else { return nil }
            return "Bearer \(token)"
        }()

        var queryItems = [(String, String)]()

        queryItems.append(("uri", postURI))

        if let depth {
            queryItems.append(("depth", "\(depth)"))
        }

        if let parentHeight {
            queryItems.append(("parentHeight", "\(parentHeight)"))
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
                                                         authorizationValue: authorizationValue)
            let response = try await APIClientService.sendRequest(request, decodeTo: FeedGetPostThreadOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
