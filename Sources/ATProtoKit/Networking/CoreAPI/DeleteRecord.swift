//
//  DeleteRecord.swift
//  
//
//  Created by Christopher Jr Riley on 2024-02-10.
//

import Foundation

extension ATProtoKit {
    /// Deletes a record.
    ///
    /// - Note: According to the AT Protocol specifications: "Delete a repository record, or ensure it doesn't exist. Requires auth, implemented by PDS."
    /// 
    /// - Parameters:
    ///   - requestBody: The request body that contains the specific record that needs to be deleted.
    public func deleteRecord<T: Encodable>(requestBody: T) async throws {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.repo.deleteRecord") else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .post,
                                                         authorizationValue: "Bearer \(session.accessToken)")

            try await APIClientService.sendRequest(request, withEncodingBody: requestBody)
        } catch {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "\(error)"])
        }
    }
}
