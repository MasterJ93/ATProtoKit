//
//  ListAppPasswords.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-25.
//

import Foundation

extension ATProtoKit {

    /// Lists all of the App Passwords in a user's account.
    /// 
    /// - Important: This won't show the actual App Passwords; it'll only display the names
    /// associated with the App Passwords.
    ///
    /// - Note: According to the AT Protocol specifications: "List all App Passwords."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.listAppPasswords`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/listAppPasswords.json
    ///
    /// - Returns: An array of App Passwords belonging to the user account.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func listAppPasswords() async throws -> ComAtprotoLexicon.Server.ListAppPasswordsOutput {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.server.listAppPasswords") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .get,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: nil,
                                                         authorizationValue: "Bearer \(accessToken)")
            let response = try await APIClientService.sendRequest(request,
                                                                  decodeTo: ComAtprotoLexicon.Server.ListAppPasswordsOutput.self)

            return response
        } catch {
            throw error
        }
    }
}
