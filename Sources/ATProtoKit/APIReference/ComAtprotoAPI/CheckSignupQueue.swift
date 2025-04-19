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
    /// - Returns: Ths status of the future user account's status in the sign up queue, which
    /// includes the activation status, its place in the queue, and an estimated number of minutes
    /// to wait until the user can use the service.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func checkSignupQueue(matching query: String) async throws -> ComAtprotoLexicon.Temp.CheckSignupQueueOutput {
        guard let requestURL = URL(string: "\(self.pdsURL)/xrpc/com.atproto.temp.checkSignupQueue") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        queryItems.append(("q", query))

        let queryURL: URL

        do {
            queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = await APIClientService.createRequest(
                forRequest: queryURL,
                andMethod: .post,
                acceptValue: "application/json",
                contentTypeValue: "application/json",
                authorizationValue: nil
            )
            let response = try await APIClientService.shared.sendRequest(
                request,
                decodeTo: ComAtprotoLexicon.Temp.CheckSignupQueueOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
