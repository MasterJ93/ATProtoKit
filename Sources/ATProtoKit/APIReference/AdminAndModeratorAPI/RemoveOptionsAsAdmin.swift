//
//  RemoveOptionsAsAdmin.swift
//
//
//  Created by Christopher Jr Riley on 2025-01-01.
//

import Foundation

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
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.setting.removeOptions") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ToolsOzoneLexicon.Setting.RemoveOptionsRequestBody(
            keys: keys,
            scope: scope
        )

        do {
            let request = APIClientService.createRequest(
                forRequest: requestURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
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
