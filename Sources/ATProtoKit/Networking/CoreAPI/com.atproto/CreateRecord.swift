//
//  CreateRecord.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-10.
//

import Foundation

extension ATProtoKit {
    /// <#Description#>
    /// - Parameters:
    ///   - collection: <#collection description#>
    ///   - requestBody: <#requestBody description#>
    ///   - createdAt: <#createdAt description#>
    /// - Returns: <#description#>
    public func createRecord<T: Encodable>(collection: String, requestBody: T, createdAt: Date = Date.now) async -> Result<StrongReference, Error> {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.repo.createRecord") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }
        
        let request = APIClientService.createRequest(forRequest: requestURL, andMethod: .post, authorizationValue: "Bearer \(session.accessToken)")
        
        do {
            let result = try await APIClientService.sendRequest(request, withEncodingBody: requestBody, decodeTo: StrongReference.self)
            return .success(result)
        } catch {
            return .failure(error)
        }
    }
}
