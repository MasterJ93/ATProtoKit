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
    /// - Note: According to the AT Protocol specifications: "Get posts in a thread. Does not
    /// require auth, but additional metadata and filtering will be applied for authed requests."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.getPostThread`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/getPostThread.json
    ///
    /// - Parameters:
    ///   - postURI: The URI of the post.
    ///   - depth: The number of reply layers that can be included in the result. Optional.
    ///   Defaults to `6`. Can be between `0` and `1000`.
    ///   - parentHeight: The number of parent layers that can be included in the result.
    ///   Optional. Defaults to `80`. Can be between `0` and `1000`.
    ///   - accessToken: The token used to authenticate the user. Optional.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `nil`.
    /// - Returns: A `Result`, containing either a
    /// ``AppBskyLexicon/Feed/GetPostThreadOutput``
    /// if successful, or an `Error` if not.
    public func getPostThread(
        from postURI: String,
        depth: Int? = 6,
        parentHeight: Int? = 80,
        pdsURL: String? = nil,
        shouldAuthenticate: Bool = false
    ) async throws -> Result<AppBskyLexicon.Feed.GetPostThreadOutput, Error> {
        let authorizationValue = prepareAuthorizationValue(
            methodPDSURL: pdsURL,
            shouldAuthenticate: shouldAuthenticate,
            session: session
        )

        guard let sessionURL = pdsURL != nil ? pdsURL : session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.feed.getPostThread") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        var queryItems = [(String, String)]()

        queryItems.append(("uri", postURI))

        if let depth {
            let finalDepth = max(0, min(depth, 1_000))
            queryItems.append(("depth", "\(finalDepth)"))
        }

        if let parentHeight {
            let finalParentHeight = max(0, min(parentHeight, 1_000))
            queryItems.append(("parentHeight", "\(finalParentHeight)"))
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
                                                         authorizationValue: authorizationValue)
            let response = try await APIClientService.sendRequest(request,
                                                                  decodeTo: AppBskyLexicon.Feed.GetPostThreadOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
