//
//  AddValuesAsAdmin.swift
//
//  Created by Christopher Jr Riley on 2024-10-19.
//

import Foundation

extension ATProtoAdmin {

    /// Adds values to a specific set as an administrator.
    ///
    /// - Note: According to the AT Protocol specifications: "Add values to a specific set.
    /// Attempting to add values to a set that does not exist will result in an error."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.set.addValues`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/set/addValues.json
    ///
    public func addValues(
        setName: String,
        values: [String]
    ) async throws {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.set.addValues") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ToolsOzoneLexicon.Set.AddValuesRequestBody(
            name: setName,
            values: values
        )

        do {
            let request = APIClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: "application/json",
                contentTypeValue: "application/json",
                authorizationValue: "Bearer \(accessToken)"
            )

            _ = try await APIClientService.shared.sendRequest(
                request,
                withEncodingBody: requestBody
            )
        } catch {
            throw error
        }
    }
}
