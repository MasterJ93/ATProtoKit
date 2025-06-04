//
//  ComAtprotoServerCreateSessionMethod.swift
//
//
//  Created by Christopher Jr Riley on 2024-12-04.
//

import Foundation

extension ATProtoKit {

    /// Creates a session for the user account.
    ///
    /// It's best to use ``ATProtocolConfiguration`` or another ``SessionConfiguration``-conforming
    /// `class` instead of using this method directly. If you're making a `class` that conforms to
    /// ``SessionConfiguration``, be sure to use this with the method used for creating a session.
    ///
    /// - Note: According to the AT Protocol specifications: "Handle or other identifier supported
    /// by the server for the authenticating user."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.createSession`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/createSession.json
    ///
    /// - Parameters:
    ///   - identifier: An identifier (typically a handle) for the user account.
    ///   - password: The password for the user account.
    ///   - authenticationFactorToken: The token used if the user account has
    ///   multi-factor authorization. Optional.
    ///
    /// - Returns: An instance of an authenticated user session within the AT Protocol. It may also
    /// have logging information, as well as the URL of the Personal Data Server (PDS).
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func createSession(
        with identifier: String,
        and password: String,
        authenticationFactorToken: String? = nil
    ) async throws -> ComAtprotoLexicon.Server.CreateSessionOutput {
        guard let requestURL = URL(string: "\(self.pdsURL)/xrpc/com.atproto.server.createSession") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ComAtprotoLexicon.Server.CreateSessionRequestBody(
            identifier: identifier,
            password: password,
            authenticationFactorToken: authenticationFactorToken
        )

        do {
            let request = apiClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post
            )

            let response = try await apiClientService.sendRequest(
                request,
                withEncodingBody: requestBody,
                decodeTo: ComAtprotoLexicon.Server.CreateSessionOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
