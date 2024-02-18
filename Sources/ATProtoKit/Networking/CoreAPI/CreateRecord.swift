//
//  CreateRecord.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-10.
//

import Foundation

extension ATProtoKit {
    /// Creates a record attached to a user's account.
    /// - Parameters:
    ///   - collection: The NSID of the record.
    ///   - requestBody: The request body that contains the information needed to create the specific type of record.
    ///   - createdAt: The date and time the record was created. Defaults to the date and time this method was called.
    /// - Returns: A `Result`, containing either a ``StrongReference`` if successful, and an `Error` if not.
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
