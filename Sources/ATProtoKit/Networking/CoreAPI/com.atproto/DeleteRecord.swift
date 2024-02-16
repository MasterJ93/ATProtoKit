//
//  File.swift
//  
//
//  Created by Christopher Jr Riley on 2024-02-10.
//

import Foundation

extension ATProtoKit {
    /// <#Description#>
    /// - Parameters:
    ///   - requestBody: <#requestBody description#>
    ///   - createdAt: <#createdAt description#>
    public func deleteRecord<T: Encodable>(requestBody: T, createdAt: Date = Date.now) async throws {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.repo.createRecord") else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }

        let request = APIClientService.createRequest(forRequest: requestURL, andMethod: .post, authorizationValue: "Bearer \(session.accessToken)")

        do {
            try await APIClientService.sendRequest(request, withEncodingBody: requestBody)
        } catch {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "\(error)"])
        }
    }
}
