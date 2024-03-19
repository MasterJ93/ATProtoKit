//
//  DeleteCommunicationTemplateAsAdmin.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-28.
//

import Foundation

extension ATProtoAdmin {
    /// Deletes a communication template as an administrator or moderator.
    ///
    /// - Important: This is a moderator task and as such, regular users won't be able to access this; if they attempt to do so, an error will occur.
    /// 
    /// - Note: According to the AT Protocol specifications: "Delete a communication template."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.communication.deleteTemplate`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/communication/deleteTemplate.json
    ///
    /// - Parameter id: The ID of the communication template.
    public func deleteCommunicationTemplate(by id: String) async throws {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.communication.deleteTemplate") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = AdminDeleteCommunicationTemplate(
            id: id
        )

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .post,
                                                         acceptValue: nil,
                                                         contentTypeValue: "application/json",
                                                         authorizationValue: "Bearer \(accessToken)")

            try await APIClientService.sendRequest(request,
                                                   withEncodingBody: requestBody)
        } catch {
            throw error
        }
    }
}
