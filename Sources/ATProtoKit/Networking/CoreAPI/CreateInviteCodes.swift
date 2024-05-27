//
//  CreateInviteCodes.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-24.
//

import Foundation

extension ATProtoKit {

    /// Creates several invite codes.
    /// 
    /// - Note: According to the AT Protocol specifications: "Create invite codes."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.createInviteCodes`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/createInviteCodes.json
    ///
    /// - Parameters:
    ///   - codeCount: The number of invite codes to be created. Defaults to `1`.
    ///   - forAccounts: An array of decentralized identifiers (DIDs) that can use the
    ///   invite codes.
    /// - Returns: A `Result`, containing either a ``ServerCreateInviteCodesOutput``
    /// if successful, or an `Error` if not.
    public func createInviteCodes(_ codeCount: Int = 1, for accounts: [String]) async throws -> Result<ServerCreateInviteCodesOutput, Error> {
        guard session != nil,
              let accessToken = session?.accessToken else {
            return .failure(ATRequestPrepareError.missingActiveSession)
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.server.createInviteCodes") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        // Make sure the number isn't lower than one.
        let requestBody = ServerCreateInviteCodes(
            useCount: codeCount > 0 ? codeCount : 1,
            forAccounts: accounts
        )

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .post,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: "application/json",
                                                         authorizationValue: "Bearer \(accessToken)")
            let response = try await APIClientService.sendRequest(request,
                                                                  withEncodingBody: requestBody,
                                                                  decodeTo: ServerCreateInviteCodesOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
