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
    ///   - shouldAuthenticate: Indicates whether the method will use the access token when
    ///   sending the request. Defaults to `true`.
    /// - Returns: A post thread that matches the `postURI`.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getPostThread(
        from postURI: String,
        depth: Int? = 6,
        parentHeight: Int? = 80,
        shouldAuthenticate: Bool = true
    ) async throws -> AppBskyLexicon.Feed.GetPostThreadOutput {
        let authorizationValue = prepareAuthorizationValue(
            shouldAuthenticate: shouldAuthenticate,
            session: session
        )

        guard self.pdsURL != "" else {
            throw ATRequestPrepareError.emptyPDSURL
        }

        guard let sessionURL = authorizationValue != nil ? session?.serviceEndpoint.absoluteString : self.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.feed.getPostThread") else {
            throw ATRequestPrepareError.invalidRequestURL
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

            let request = APIClientService.createRequest(
                forRequest: queryURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: authorizationValue
            )
            let response = try await APIClientService.shared.sendRequest(
                request,
                decodeTo: AppBskyLexicon.Feed.GetPostThreadOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
