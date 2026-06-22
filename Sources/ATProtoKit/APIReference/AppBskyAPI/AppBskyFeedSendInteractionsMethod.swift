//
//  AppBskyFeedSendInteractionsMethod.swift
//
//
//  Created by Christopher Jr Riley on 2024-04-15.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Sends interactions to a feed generator.
    /// 
    /// - Warning: This is a work in progress. This method may not work as expected.
    /// Please use this at your own risk.
    ///
    /// - Note: According to the AT Protocol specifications: "Send information about interactions
    /// with feed items back to the feed generator that served them."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.sendInteractions`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/sendInteractions.json
    ///
    /// - Parameters:
    ///   - interactions: An array of interactions.
    ///   - feedGeneratorDID: The DID of the feed generator to route the request to. Optional.
    /// - Returns: An array of interactions.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func sendInteractions(
        _ interactions: [AppBskyLexicon.Feed.InteractionDefinition],
        feedGeneratorDID: String? = nil
    ) async throws -> AppBskyLexicon.Feed.SendInteractionsOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        try await sessionConfiguration?.ensureValidToken()
        let accessToken = try await keychain.retrieveAccessToken()
        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.feed.sendInteractions") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = AppBskyLexicon.Feed.SendInteractionsRequestBody(
            interactions: interactions
        )

        do {
            let request = apiClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: nil,
                contentTypeValue: nil,
                authorizationValue: "Bearer \(accessToken)",
                proxyValue: feedGeneratorDID.map { "\($0)#bsky_fg" }
            )
            let response = try await apiClientService.sendRequest(
                request,
                withEncodingBody: requestBody,
                decodeTo: AppBskyLexicon.Feed.SendInteractionsOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
