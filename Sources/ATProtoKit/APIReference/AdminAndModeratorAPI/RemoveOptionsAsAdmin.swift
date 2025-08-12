//
//  RemoveOptionsAsAdmin.swift
//
//
//  Created by Christopher Jr Riley on 2025-01-01.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoAdmin {

    /// Deletes a setting options by their keys.
    ///
    /// - Note: According to the AT Protocol specifications: "Delete settings by key."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.setting.removeOptions`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/setting/removeOptions.json
    ///
    public func removeOption(
        by keys: [String],
        scope: ToolsOzoneLexicon.Setting.RemoveOptions.Scope
    ) async throws {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        try await sessionConfiguration?.ensureValidToken()
        let accessToken = try await keychain.retrieveAccessToken()

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.setting.removeOptions") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ToolsOzoneLexicon.Setting.RemoveOptionsRequestBody(
            keys: keys,
            scope: scope
        )

        do {
            let request = apiClientService.createRequest(
                forRequest: requestURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: "Bearer \(accessToken)"
            )

            _ = try await apiClientService.sendRequest(
                request,
                withEncodingBody: requestBody
            )
        } catch {
            throw error
        }
    }
}
