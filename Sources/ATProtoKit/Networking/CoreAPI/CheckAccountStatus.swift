//
//  CheckAccountStatus.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-23.
//

import Foundation

extension ATProtoKit {
    /// Checks the status of the user's account.
    /// - Returns: A `Result`, containing either ``ServerCheckAccountStatusOutput`` if successful, or an `Error` if not.
    public func checkAccountStatus() async throws -> Result<ServerCheckAccountStatusOutput, Error> {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.server.checkAccountStatus") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        do {
            let request = APIClientService.createRequest(forRequest: requestURL, andMethod: .get, contentTypeValue: nil)
            let response = try await APIClientService.sendRequest(request, decodeTo: ServerCheckAccountStatusOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
