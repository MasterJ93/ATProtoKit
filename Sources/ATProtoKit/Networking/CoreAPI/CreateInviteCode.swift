//
//  CreateInviteCode.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-24.
//

import Foundation

extension ATProtoKit {
    /// Creates an invite code.
    ///
    /// - Note: If you need to create multiple invite codes at once, please use ``create`` instead.
    /// 
    /// - Parameters:
    ///   - codeCount: The number of invite codes to be created. Defaults to 1.
    ///   - forAccount: The decentralized identifier (DIDs) of the user that can use the invite code. Optional.
    /// - Returns: A `Result`, containing either a ``ServerCreateInviteCodeOutput`` if successful, or an `Error` if not.
    public func createInviteCode(_ codeCount: Int = 1, for account: [String]) async throws -> Result<ServerCreateInviteCodeOutput, Error> {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.server.createInviteCode") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        // Make sure the number isn't lower than one.
        let requestBody = ServerCreateInviteCode(
            useCount: codeCount > 0 ? codeCount : 1,
            forAccount: account
        )

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .post,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: "application/json",
                                                         authorizationValue: "Bearer \(session.accessToken)")
            let response = try await APIClientService.sendRequest(request, withEncodingBody: requestBody, decodeTo: ServerCreateInviteCodeOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
