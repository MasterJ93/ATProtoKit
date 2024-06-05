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
    /// - Returns: A `Result`, containing either a
    /// ``ComAtprotoLexicon/Server/ListAppPasswordsOutput``
    /// if successful, or an `Error` if not.
    public func listAppPasswords() async throws -> Result<ComAtprotoLexicon.Server.ListAppPasswordsOutput, Error> {
        guard session != nil,
              let accessToken = session?.accessToken else {
            return .failure(ATRequestPrepareError.missingActiveSession)
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.server.listAppPasswords") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .get,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: nil,
                                                         authorizationValue: "Bearer \(accessToken)")
            let response = try await APIClientService.sendRequest(request,
                                                                  decodeTo: ComAtprotoLexicon.Server.ListAppPasswordsOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
