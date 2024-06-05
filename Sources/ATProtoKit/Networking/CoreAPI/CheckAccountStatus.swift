//
//  CheckAccountStatus.swift
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
    /// - Returns: A `Result`, containing either
    /// ``ComAtprotoLexicon/Server/CheckAccountStatusOutput``
    /// if successful, or an `Error` if not.
    public func checkAccountStatus() async throws -> Result<ComAtprotoLexicon.Server.CheckAccountStatusOutput, Error> {
        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.server.checkAccountStatus") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .get,
                                                         contentTypeValue: nil,
                                                         authorizationValue: nil)
            let response = try await APIClientService.sendRequest(request,
                                                                  decodeTo: ComAtprotoLexicon.Server.CheckAccountStatusOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
