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
    /// - Important: This is an administrator task and as such, regular users won't be able to access this; if they attempt to do so, an error will occur.
    /// 
    /// - Returns: A `Result`, containing either an ``AdminListCommunicationTemplatesOutput`` if successful, or an `Error` if not.
    public func listCommunicationTemplatesAsAdmin() async throws -> Result<AdminListCommunicationTemplatesOutput, Error> {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.admin.listCommunicationTemplates") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .get,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: nil,
                                                         authorizationValue: "Bearer \(session.accessToken)")
            let response = try await APIClientService.sendRequest(request, decodeTo: AdminListCommunicationTemplatesOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
