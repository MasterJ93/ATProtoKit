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
    /// App Passowrds are highly recommended to be used in your application (as opposed to their
    /// actual password) due to the restrictions an App Password has compared to the full account
    /// access of the normal password.
    ///
    /// - Note: According to the AT Protocol specifications: "Create an App Password."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.createAppPassword`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/createAppPassword.json
    ///
    /// - Parameters:
    ///   - passwordName: The name given to the App Password to help distingush it from others.
    ///   - isPrivileged: Indicates whether this App Password can be used to access sensitive
    ///   content from the user account.
    /// - Returns: A `Result`, either containing a ``ComAtprotoLexicon/Server/CreateAppPasswordOutput``
    /// if successful, or an `Error` if not.
    public func createAppPassword(
        named passwordName: String,
        isPrivileged: Bool?
    ) async throws -> Result<ComAtprotoLexicon.Server.CreateAppPasswordOutput, Error> {
        guard session != nil,
              let accessToken = session?.accessToken else {
            return .failure(ATRequestPrepareError.missingActiveSession)
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.server.createAppPassword") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        let requestBody = ComAtprotoLexicon.Server.CreateAppPasswordRequestBody(
            name: passwordName,
            isPrivileged: isPrivileged
        )

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .get,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: "application/json",
                                                         authorizationValue: "Bearer \(accessToken)")
            let response = try await APIClientService.sendRequest(request,
                                                                  withEncodingBody: requestBody,
                                                                  decodeTo: ComAtprotoLexicon.Server.CreateAppPasswordOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }

    }
}
