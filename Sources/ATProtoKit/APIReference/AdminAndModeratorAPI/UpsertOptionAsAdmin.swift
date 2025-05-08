//
//  UpsertOptionAsAdmin.swift
//
//
//  Created by Christopher Jr Riley on 2025-01-01.
//

import Foundation

extension ATProtoAdmin {

    /// Creates or updates a setting option.
    /// 
    /// - Note: According to the AT Protocol specifications: "Create or update setting option."
    /// 
    /// - SeeAlso: This is based on the [`tools.ozone.setting.upsertOption`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/setting/upsertOption.json
    /// 
    /// - Parameters:
    ///   - key: The key of the option.
    ///   - scope: The scope of the option. Defaults to `.instance`.
    ///   - value: The option's value.
    ///   - description: The option's description. Optional. Current maximum is 
    ///   - managerRole: The manager role of the option. Optional.
    /// - Returns: The newly upserted option.
    public func upsertOption(
        by key: String,
        scope: ToolsOzoneLexicon.Setting.UpsertOption.Scope = .instance,
        value: UnknownType,
        description: String? = nil,
        managerRole: ToolsOzoneLexicon.Team.MemberDefinition.Role?
    ) async throws -> ToolsOzoneLexicon.Setting.UpsertOptionOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.setting.upsertOption") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ToolsOzoneLexicon.Setting.UpsertOptionRequestBody(
            key: key,
            scope: scope,
            value: value,
            description: description,
            managerRole: managerRole
        )

        do {
            let request = await APIClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: "application/json",
                contentTypeValue: "application/json",
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await APIClientService.shared.sendRequest(
                request,
                withEncodingBody: requestBody,
                decodeTo: ToolsOzoneLexicon.Setting.UpsertOptionOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
