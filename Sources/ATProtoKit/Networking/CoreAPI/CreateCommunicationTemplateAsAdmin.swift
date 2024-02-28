//
//  CreateCommunicationTemplateAsAdmin.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-27.
//

import Foundation

extension ATProtoKit {
    /// Creates a communication template for administrators.
    /// 
    /// - Important: This is an administrator task and as such, regular users won't be able to access this; if they attempt to do so, an error will occur.
    /// 
    /// - Parameters:
    ///   - name: The name of the template.
    ///   - contentMarkdown: A Markdown-formatted content of the communitcation template.
    ///   - subject: The subject line of the communication template.
    ///   - createdBy: The decentralized identifier (DID) of the creator of the communication template. Optional.
    /// - Returns: A `Result`, containing either ``AdminCommunicationTemplateView`` if successful, or an `Error` if not.
    public func createCommunicationTemplateAsAdmin(named name: String, contentMarkdown: String, subject: String, createdBy: String?) async throws -> Result<AdminCommunicationTemplateView, Error> {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.admin.createCommunicationTemplate") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        let requestBody = AdminCreateCommunicationTemplate(
            name: name,
            contentMarkdown: contentMarkdown,
            subject: subject,
            createdBy: createdBy
        )

        do {
            let request = APIClientService.createRequest(forRequest: requestURL, andMethod: .post, acceptValue: "application/json", contentTypeValue: "application/json", authorizationValue: "Bearer \(session.accessToken)")
            let response = try await APIClientService.sendRequest(request, withEncodingBody: requestBody, decodeTo: AdminCommunicationTemplateView.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
