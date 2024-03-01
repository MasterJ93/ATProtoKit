//
//  DeleteCommunicationTemplateAsAdmin.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-28.
//

import Foundation

extension ATProtoKit {
    /// Deletes a communication template as an administrator.
    /// 
    /// - Important: This is an administrator task and as such, regular users won't be able to access this; if they attempt to do so, an error will occur.
    ///
    public func deleteCommunicationTemplateAsAdmin(_ id: String) async throws {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.admin.deleteCommunicationTemplate") else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }

        let requestBody = AdminDeleteCommunicationTemplate(id: id)

        do {
            let request = APIClientService.createRequest(forRequest: requestURL, andMethod: .post, acceptValue: nil, contentTypeValue: "application/json", authorizationValue: "Bearer \(session.accessToken)")

            try await APIClientService.sendRequest(request, withEncodingBody: requestBody)
        } catch {
            throw error
        }
    }
}
