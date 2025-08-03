//
//  CreateCommunicationTemplateAsAdmin.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-27.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

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
    ///   - language: The language of the message. Optional.
    ///   - createdBy: The decentralized identifier (DID) of the creator of the
    ///   communication template. Optional.
    /// - Returns: A communication template.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func createCommunicationTemplate(
        named name: String,
        contentMarkdown: String,
        subject: String,
        language: Locale,
        createdBy: String? = nil
    ) async throws -> ToolsOzoneLexicon.Communication.TemplateViewDefinition {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        try await sessionConfiguration?.ensureValidToken()
        let accessToken = try await keychain.retrieveAccessToken()

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.communication.createTemplate") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ToolsOzoneLexicon.Communication.CreateTemplateRequestBody(
            name: name,
            contentMarkdown: contentMarkdown,
            subject: subject,
            language: language,
            createdBy: createdBy
        )

        do {
            let request = apiClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: "application/json",
                contentTypeValue: "application/json",
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await apiClientService.sendRequest(
                request,
                withEncodingBody: requestBody,
                decodeTo: ToolsOzoneLexicon.Communication.TemplateViewDefinition.self
            )

            return response
        } catch {
            throw error
        }
    }
}
