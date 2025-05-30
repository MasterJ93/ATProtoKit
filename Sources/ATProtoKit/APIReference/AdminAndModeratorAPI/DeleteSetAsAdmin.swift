//
//  DeleteSetAsAdmin.swift
//
//
//  Created by Christopher Jr Riley on 2024-10-24.
//

import Foundation

extension ATProtoAdmin {

    /// Deletes a set as a moderator.
    /// 
    /// - Note: According to the AT Protocol specifications: "Delete an entire set. Attempting to
    /// delete a set that does not exist will result in an error."
    /// 
    /// - SeeAlso: This is based on the [`tools.ozone.set.deleteSet`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/set/deleteSet.json
    ///
    /// - Parameter name: The name of the set to delete.
    /// - Returns: There is no output for this method.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func deleteSet(named name: String) async throws -> ToolsOzoneLexicon.Set.DeleteSetOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.set.deleteSet") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ToolsOzoneLexicon.Set.DeleteSetRequestBody(
            name: name
        )

        do {
            let request = apiClientService.createRequest(
                forRequest: requestURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: "Bearer \(accessToken)"
            )

            let response = try await apiClientService.sendRequest(
                request,
                withEncodingBody: requestBody,
                decodeTo: ToolsOzoneLexicon.Set.DeleteSetOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
