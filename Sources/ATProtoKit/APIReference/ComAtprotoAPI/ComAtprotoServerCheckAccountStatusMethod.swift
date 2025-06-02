//
//  ComAtprotoServerCheckAccountStatusMethod.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-23.
//

import Foundation

extension ATProtoKit {

    /// Checks the status of the user's account.
    /// 
    /// - Note: According to the AT Protocol specifications: "Returns the status of an account,
    /// especially as pertaining to import or recovery. Can be called many times over the course
    /// of an account migration. Requires auth and can only be called pertaining to oneself."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.checkAccountStatus`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/checkAccountStatus.json
    /// 
    /// - Returns: The status of the user account, which includes the validity of the
    /// decentralized identifier (DID); it's active status; commits, revisions, and blocks of the
    /// repository, indexed records, and the number of private state values, indexed records, and
    /// blobs (both expected and imported).
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func checkAccountStatus() async throws -> ComAtprotoLexicon.Server.CheckAccountStatusOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.server.checkAccountStatus") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        do {
            let request = apiClientService.createRequest(
                forRequest: requestURL,
                andMethod: .get,
                contentTypeValue: nil,
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await apiClientService.sendRequest(
                request,
                decodeTo: ComAtprotoLexicon.Server.CheckAccountStatusOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
