//
//  ToolsOzoneSafelinkRemoveRuleMethod.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-07-12.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoAdmin {

    /// Deletes an existing URL safety rule.
    ///
    /// - Note: According to the AT Protocol specifications: "Remove an existing URL safety rule."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.safelink.removeRule`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/safelink/removeRule.json
    ///
    /// - Parameters:
    ///   - url: The URL or domain related to the rule.
    ///   - pattern: The URL pattern.
    ///   - comment: A comment attached to the event. Optional.
    ///   - createdBy: The decentralized identitifer (DID) of the user account that deleted
    ///   the rule. Optional.
    /// - Returns: A string declaring the type of event.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func removeRule(
        url: URL,
        pattern: ToolsOzoneLexicon.Safelink.PatternTypeDefinition,
        comment: String? = nil,
        createdBy: String? = nil
    ) async throws -> ToolsOzoneLexicon.Safelink.EventDefinition {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        try await sessionConfiguration?.ensureValidToken()
        let accessToken = try await keychain.retrieveAccessToken()

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.safelink.removeRule") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ToolsOzoneLexicon.Safelink.RemoveRuleRequestBody(
            url: url,
            pattern: pattern,
            comment: comment,
            createdBy: createdBy
        )

        do {
            let request = apiClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: "application/json",
                contentTypeValue: "application/json",
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await apiClientService.sendRequest(
                request,
                withEncodingBody: requestBody,
                decodeTo: ToolsOzoneLexicon.Safelink.EventDefinition.self
            )

            return response
        } catch {
            throw error
        }
    }
}
