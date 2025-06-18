//
//  UpsertSetAsAdmin.swift
//
//
//  Created by Christopher Jr Riley on 2024-10-24.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoAdmin {

    /// Creates or updates set metadata.
    /// 
    /// - Note: According to the AT Protocol specifications: "Create or update set metadata."
    /// 
    /// - SeeAlso: This is based on the [`tools.ozone.set.upsertSet`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/set/upsertSet.json
    /// 
    /// - Parameters:
    ///   - name: The name of the set.
    ///   - description: The new description of the set.
    /// - Returns: The view of the set.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func upsertSet(
        named name: String,
        description: String
    ) async throws -> ToolsOzoneLexicon.Set.SetViewDefinition {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.set.upsertSet") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ToolsOzoneLexicon.Set.SetDefinition(
            name: name,
            description: description
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
                decodeTo: ToolsOzoneLexicon.Set.SetViewDefinition.self
            )

            return response
        } catch {
            throw error
        }
    }
}


