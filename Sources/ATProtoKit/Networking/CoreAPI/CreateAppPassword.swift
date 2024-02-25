//
//  CreateAppPassword.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-24.
//

import Foundation

extension ATProtoKit {
    /// Creates an App Password for the user's account.
    ///
    /// App Passowrds are highly recommended to be used in your application (as opposed to their actual password) due to the restrictions an App Password has compared to the full account access of the normal password.
    ///
    /// - Important: Ensure a strong password is created.
    /// - Parameter passwordName: The name given to the App Password to help distingush it from others.
    /// - Returns: A `Result`, either containing a ``ServerCreateAppPasswordOutput`` if successful, or an `Error` if not.
    public func createAppPassword(_ passwordName: String) async throws -> Result<ServerCreateAppPasswordOutput, Error> {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.server.createAppPassword") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        let requestBody = ServerCreateAppPassword(name: passwordName)

        do {
            let request = APIClientService.createRequest(forRequest: requestURL, andMethod: .get, acceptValue: "application/json", contentTypeValue: "Bearer \(session.accessToken)", authorizationValue: "application/json")
            let response = try await APIClientService.sendRequest(request, withEncodingBody: requestBody, decodeTo: ServerCreateAppPasswordOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }

    }
}
