//
//  UpdateHandle.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-10.
//

import Foundation

extension ATProtoKit {
    /// <#Description#>
    /// - Parameter handle: <#handle description#>
    public func updateHandle(_ handle: UpdateHandleQuery) async throws {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.identity.updateHandle") else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }

        let request = APIClientService.createRequest(forRequest: requestURL, andMethod: .post, authorizationValue: "Bearer \(session.accessToken)")

        do {
            try await APIClientService.sendRequest(request, withEncodingBody: handle)
        } catch {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "\(error)"])
        }
    }
}
