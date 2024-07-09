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
    /// - Important: This is an administrator task and as such, regular users won't be able to
    /// access this; if they attempt to do so, an error will occur.
    ///
    /// - Note: According to the AT Protocol specifications: "Send email to a user's account
    /// email address."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.admin.sendEmail`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/sendEmail.json
    ///
    /// - Parameters:
    ///   - recipientDID: The decentralized identifier (DID) of the recipient.
    ///   - subjectLine: The subject line of the email. Optional.
    ///   - content: The content of the email.
    ///   - senderDID: The decentralized identifier (DID) of the sender.
    ///   - comment: Any additional comments viewable to other moderators and administrators.
    /// - Returns: An indication of whether the email has been sent.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func sendEmail(
        to recipientDID: String,
        withSubjectLine subjectLine: String? = nil,
        content: String,
        senderDID: String,
        comment: String? = nil
    ) async throws -> ComAtprotoLexicon.Admin.SendEmailOutput {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.admin.sendEmail") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ComAtprotoLexicon.Admin.SendEmailRequestBody(
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
                                                         authorizationValue: "Bearer \(accessToken)")
            let response = try await APIClientService.sendRequest(request,
                                                                  withEncodingBody: requestBody,
                                                                  decodeTo: ComAtprotoLexicon.Admin.SendEmailOutput.self)

            return response
        } catch {
            throw error
        }
    }
}
