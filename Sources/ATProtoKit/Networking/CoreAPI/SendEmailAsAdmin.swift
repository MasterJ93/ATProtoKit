//
//  SendEmailAsAdmin.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-02.
//

import Foundation

extension ATProtoKit {
    /// Sends an email to the user's email address as an administrator.
    /// 
    /// - Parameters:
    ///   - recipientDID: The decentralized identifier (DID) of the recipient.
    ///   - content: The content of the email.
    ///   - subject: The subject line of the email. Optional.
    ///   - senderDID: The decentralized identifier (DID) of the sender.
    ///   - comment: Any additional comments viewable to other moderators and administrators.
    /// - Returns: A `Result`, containing either an ``AdminSendEmailOutput`` if successful, or an `Error` if not.
    public func sendEmailAsAdmin(_ recipientDID: String, content: String, subject: String?, senderDID: String, comment: String?) async throws -> Result<AdminSendEmailOutput, Error> {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.admin.queryModerationEvents") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        let requestBody = AdminSendEmail(
            recipientDID: recipientDID,
            content: content,
            subject: subject,
            senderDID: senderDID,
            comment: comment
        )

        do {
            let request = APIClientService.createRequest(forRequest: requestURL, andMethod: .post, acceptValue: "application/json", contentTypeValue: "application/json", authorizationValue: "Bearer \(session.accessToken)")
            let response = try await APIClientService.sendRequest(request, withEncodingBody: requestBody, decodeTo: AdminSendEmailOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
