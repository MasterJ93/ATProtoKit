//
//  CreateCommunicationTemplateAsAdmin.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-27.
//

import Foundation

extension ATProtoAdmin {
    /// Creates a communication template for administrators and moderators.
    ///
    /// - Important: This is a moderator task and as such, regular users won't be able to access
    /// this; if they attempt to do so, an error will occur.
    ///
    /// - Note: According to the AT Protocol specifications: "Administrative action to create a
    /// new, re-usable communication (email for now) template."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.communication.createTemplate`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/communication/createTemplate.json
    ///
    /// - Parameters:
    ///   - name: The name of the template.
    ///   - contentMarkdown: A Markdown-formatted content of the communitcation template.
    ///   - subject: The subject line of the communication template.
    ///   - createdBy: The decentralized identifier (DID) of the creator of the
    ///   communication template. Optional.
    /// - Returns: A `Result`, containing either ``OzoneCommunicationTemplateView``
    /// if successful, or an `Error` if not.
    public func createCommunicationTemplate(named name: String, contentMarkdown: String, subject: String,
                                            createdBy: String?) async throws -> Result<OzoneCommunicationTemplateView, Error> {
        guard session != nil,
              let accessToken = session?.accessToken else {
            return .failure(ATRequestPrepareError.missingActiveSession)
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.communication.createTemplate") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        let requestBody = CommunicationCreateTemplate(
            name: name,
            contentMarkdown: contentMarkdown,
            subject: subject,
            createdBy: createdBy
        )

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .post,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: "application/json",
                                                         authorizationValue: "Bearer \(accessToken)")
            let response = try await APIClientService.sendRequest(request,
                                                                  withEncodingBody: requestBody,
                                                                  decodeTo: OzoneCommunicationTemplateView.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
