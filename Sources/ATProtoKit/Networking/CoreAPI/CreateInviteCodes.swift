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
    /// - Parameters:
    ///   - codeCount: The number of invite codes to be created. Defaults to 1.
    ///   - forAccounts: An array of decentralized identifiers (DIDs) that can use the invite codes.
    /// - Returns: A `Result`, containing either a ``ServerCreateInviteCodesOutput`` if successful, or an `Error` if not.
    public func createInviteCodes(_ codeCount: Int = 1, for accounts: [String]) async throws -> Result<ServerCreateInviteCodesOutput, Error> {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.server.createInviteCodes") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        // Make sure the number isn't lower than one.
        let requestBody = ServerCreateInviteCodes(
            useCount: codeCount > 0 ? codeCount : 1,
            forAccounts: accounts
        )

        do {
            let request = APIClientService.createRequest(forRequest: requestURL, andMethod: .post, acceptValue: "application/json", contentTypeValue: "application/json", authorizationValue: "Bearer \(session.accessToken)")
            let response = try await APIClientService.sendRequest(request, withEncodingBody: requestBody, decodeTo: ServerCreateInviteCodesOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
