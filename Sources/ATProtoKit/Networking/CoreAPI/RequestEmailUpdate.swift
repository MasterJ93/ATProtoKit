//
//  RequestEmailUpdate.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-26.
//

import Foundation

extension ATProtoKit {
    /// Requests a token to be emailed to the user in order to update their email address.
    /// 
    /// - Returns: A `Result`, containing either a ``RequestEmailUpdateOutput`` if successful, or an `Error` if not.
    public func requestEmailUpdate() async throws -> Result<RequestEmailUpdateOutput, Error> {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/om.atproto.server.requestEmailUpdate") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "Invalid URL"]))
        }

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .post,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: nil,
                                                         authorizationValue: "Bearer \(session.accessToken)")
            let response = try await APIClientService.sendRequest(request, decodeTo: RequestEmailUpdateOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
