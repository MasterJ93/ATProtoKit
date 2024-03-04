//
//  DescribeFeedGenerator.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-04.
//

import Foundation

// TODO: Figure out the proper version of this.
extension ATProtoKit {
    /// Gets information about a given feed generator.
    /// 
    /// - Returns: A `Result`, containing either a ``FeedDescribeFeedGenerator`` if successful, or an `Error` if not.
    public static func describeFeedGenerator(_ pdsURL: String = "https://bsky.social") async throws -> Result<FeedDescribeFeedGeneratorOutput, Error> {
        guard let requestURL = URL(string: "\(pdsURL)/app.bsky.feed.describeFeedGenerator") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .get,
                                                         acceptValue: nil,
                                                         contentTypeValue: "application/json",
                                                         authorizationValue: nil)
            let response = try await APIClientService.sendRequest(request, decodeTo: FeedDescribeFeedGeneratorOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
