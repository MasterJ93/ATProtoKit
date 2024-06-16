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
    /// - Important: The lexicon associated with this model may be removed at any time.
    /// This may not work.
    ///
    /// - Note: According to the AT Protocol specifications: "Check accounts location in signup queue."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.temp.checkSignupQueue`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/temp/checkSignupQueue.json
    ///
    /// - Parameter query: The string used to search for the username.
    /// - Returns: A `Result`, containing either a
    /// ``ComAtprotoLexicon/Temp/CheckSignupQueueOutput``
    /// if successful, ot an `Error` if not.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func checkSignupQueue(for query: String) async throws -> Result<ComAtprotoLexicon.Temp.CheckSignupQueueOutput, Error> {
        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.temp.checkSignupQueue") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        var queryItems = [(String, String)]()

        queryItems.append(("q", query))

        let queryURL: URL

        do {
            queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = APIClientService.createRequest(forRequest: queryURL,
                                                         andMethod: .post,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: "application/json",
                                                         authorizationValue: nil)
            let response = try await APIClientService.sendRequest(request,
                                                                  decodeTo: ComAtprotoLexicon.Temp.CheckSignupQueueOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
