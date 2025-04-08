//
//  UpdateCommunicationTemplateAsAdmin.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-03.
//

import Foundation

extension ATProtoAdmin {

    /// Updates a communication template.
    /// 
    /// - Important: This is a moderator task and as such, regular users won't be able to access
    /// this; if they attempt to do so, an error will occur.
    ///
    /// - Note: According to the AT Protocol specifications: "Administrative action to update an
    /// existing communication template. Allows passing partial fields to patch specific fields only."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.communication.updateTemplate`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/communication/updateTemplate.json
    ///
    /// - Parameters:
    ///   - id: The ID of the communication template.
    ///   - name: The name of the communication template. Optional.
    ///   - language: The language of the message. Optional.
    ///   - contentMarkdown: The content of the communication template. Optional.
    ///   - subject: The subject line of the message itself. Optional.
    ///   - updatedBy: The decentralized identifier (DID) of the user who updated the
    ///   communication template. Optional.
    ///   - isDisabled: Indicates whether the communication template is disabled. Optional.
    /// - Returns: The recently-updated communication template.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func updateCommunicationTemplate(
        _ id: String,
        name: String? = nil,
        language: Locale?,
        contentMarkdown: String? = nil,
        subject: String? = nil,
        updatedBy: String? = nil,
        isDisabled: Bool? = nil
    ) async throws -> ToolsOzoneLexicon.Communication.TemplateViewDefinition {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.communication.updateTemplate") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ToolsOzoneLexicon.Communication.UpdateTemplateRequestBody(
            id: id,
            name: name,
            language: language,
            contentMarkdown: contentMarkdown,
            subject: subject,
            updatedBy: updatedBy,
            isDisabled: isDisabled
        )

        do {
            let request = APIClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: "application/json",
                contentTypeValue: "application/json",
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await APIClientService.shared.sendRequest(
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
