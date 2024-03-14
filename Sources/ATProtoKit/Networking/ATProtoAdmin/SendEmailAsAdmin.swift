//
//  SendEmailAsAdmin.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-02.
//

import Foundation

extension ATProtoAdmin {
    /// Sends an email to the user's email address as an administrator.
    /// 
    /// - Important: This is an administrator task and as such, regular users won't be able to access this; if they attempt to do so, an error will occur.
    ///
    /// - Parameters:
    ///   - recipientDID: The decentralized identifier (DID) of the recipient.
    ///   - subjectLine: The subject line of the email. Optional.
    ///   - content: The content of the email.
    ///   - senderDID: The decentralized identifier (DID) of the sender.
    ///   - comment: Any additional comments viewable to other moderators and administrators.
    /// - Returns: A `Result`, containing either an ``AdminSendEmailOutput`` if successful, or an `Error` if not.
    public func sendEmail(to recipientDID: String, withSubjectLine subjectLine: String?, content: String, senderDID: String, comment: String?) async throws -> Result<AdminSendEmailOutput, Error> {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.admin.sendEmail") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        let requestBody = AdminSendEmail(
            recipientDID: recipientDID,
            content: content,
            subject: subjectLine,
            senderDID: senderDID,
            comment: comment
        )

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .post,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: "application/json",
                                                         authorizationValue: "Bearer \(session.accessToken)")
            let response = try await APIClientService.sendRequest(request, withEncodingBody: requestBody, decodeTo: AdminSendEmailOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
