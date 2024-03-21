//
//  ListCommunicationTemplatesAsAdmin.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-01.
//

import Foundation

extension ATProtoAdmin {
    /// Retrieves a list of communication templates.
    /// 
    /// - Important: This is a moderator task and as such, regular users won't be able to access this; if they attempt to do so, an error will occur.
    /// 
    /// - Note: According to the AT Protocol specifications: "Get list of all communication templates."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.communication.listTemplates`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/communication/listTemplates.json
    ///
    /// - Returns: A `Result`, containing either an ``AdminListCommunicationTemplatesOutput`` if successful, or an `Error` if not.
    public func listCommunicationTemplates() async throws -> Result<AdminListCommunicationTemplatesOutput, Error> {
        guard session != nil,
              let accessToken = session?.accessToken else {
            return .failure(ATRequestPrepareError.missingActiveSession)
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.communication.listTemplates") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .get,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: nil,
                                                         authorizationValue: "Bearer \(accessToken)")
            let response = try await APIClientService.sendRequest(request,
                                                                  decodeTo: AdminListCommunicationTemplatesOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
