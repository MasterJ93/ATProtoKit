//
//  RequestAccountDelete.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-25.
//

import Foundation

extension ATProtoKit {
    /// Requests the server to delete the user's account via email.
    ///
    /// - Warning: Doing this will permanently delete the user's account. Use caution when using this.
    public func requestAccountDeletion() async throws {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.server.requestAccountDelete") else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "Invalid URL"])
        }

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .post,
                                                         acceptValue: nil,
                                                         contentTypeValue: nil,
                                                         authorizationValue: "Bearer \(session.accessToken)")

            _ = try await APIClientService.sendRequest(request)
        } catch {
            throw error
        }
    }
}
