//
//  CheckSignupQueue.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-17.
//

import Foundation

extension ATProtoKit {
    /// Retrieves information about the sign up queue location.
    /// 
    /// - Important: The lexicon associated with this model may be removed at any time. This may not work.
    /// 
    /// - Parameter query: The string used to search for the username.
    /// - Returns: A `Result`, containing either a ``TempCheckSignupQueueOutput`` if successful, ot an `Error` if not.
    public func checkSignupQueue(for query: String) async throws -> Result<TempCheckSignupQueueOutput, Error> {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.temp.checkSignupQueue") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        var queryItems = [(String, String)]()

        queryItems.append(("q", query))

        do {
            let queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .post,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: "application/json",
                                                         authorizationValue: nil)
            let response = try await APIClientService.sendRequest(request, decodeTo: TempCheckSignupQueueOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
