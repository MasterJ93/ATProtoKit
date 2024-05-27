//
//  SendInteractions.swift
//
//
//  Created by Christopher Jr Riley on 2024-04-15.
//

import Foundation

extension ATProtoKit {

    /// Sends interactions to a feed generator.
    /// 
    /// - Warning: This is a work in progress. This method may not work as expected.
    /// Please use this at your own risk.
    ///
    /// - Note: According to the AT Protocol specifications: "end information about interactions
    /// with feed items back to the feed generator that served them."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.sendInteractions`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/sendInteractions.json
    ///
    /// - Parameter interactions: An array of interactions.
    /// - Returns: A `Result`, containing either a ``FeedSendInteractionsOutput``
    /// if sucessful, or an `Error` if not.
    public func sendInteractions(_ interactions: [FeedInteraction]) async throws -> Result<FeedSendInteractionsOutput, Error>{
        guard session != nil,
              let accessToken = session?.accessToken else {
            return .failure(ATRequestPrepareError.missingActiveSession)
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.feed.sendInteractions") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        let requestBody = FeedSendInteractions(
            interactions: interactions
        )

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .post,
                                                         acceptValue: nil,
                                                         contentTypeValue: nil,
                                                         authorizationValue: "Bearer \(accessToken)")
            let response = try await APIClientService.sendRequest(request,
                                                                  withEncodingBody: requestBody,
                                                                  decodeTo: FeedSendInteractionsOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
