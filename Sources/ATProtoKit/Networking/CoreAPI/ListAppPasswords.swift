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
    /// - Important: This won't show the actual App Passwords; it'll only display the names associated with the App Passwords.
    ///
    /// - Returns: A `Result`, containing either a ``ServerListAppPasswordsOutput`` if successful, or an `Error` if not.
    public func listAppPasswords() async throws -> Result<ServerListAppPasswordsOutput, Error> {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.server.listAppPasswords") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "Invalid URL"]))
        }

        do {
            let request = APIClientService.createRequest(forRequest: requestURL, andMethod: .get, acceptValue: "application/json", contentTypeValue: nil, authorizationValue: "Bearer \(session.accessToken)")
            let response = try await APIClientService.sendRequest(request, decodeTo: ServerListAppPasswordsOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
