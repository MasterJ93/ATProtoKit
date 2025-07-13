//
//  ToolsOzoneSafelinkUpdateRuleMethod.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-07-12.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoAdmin {

    /// Updates an existing URL safety rule.
    ///
    /// - Note: According to the AT Protocol specifications: "Update an existing URL safety rule."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.safelink.updateRule`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/safelink/updateRule.json
    ///
    /// - Parameters:
    ///   - url: The URL or domain attached to the event.
    ///   - urlPattern: The URL pattern.
    ///   - action: The action taken to the URL.
    ///   - reason: The reason for the action against the URL.
    ///   - comment: A comment attached to the event. Optional.
    ///   - createdBy: The decentralized identifier (DID) of the user account that updated this event.
    ///   Optional.
    /// - Returns: A string declaring the type of event.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func updateRule(
        for url: URL,
        urlPattern: ToolsOzoneLexicon.Safelink.PatternTypeDefinition,
        action: ToolsOzoneLexicon.Safelink.ActionTypeDefinition,
        reason: ToolsOzoneLexicon.Safelink.ReasonTypeDefinition,
        comment: String? = nil,
        createdBy: String? = nil
    ) async throws -> ToolsOzoneLexicon.Safelink.EventDefinition {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.safelink.updateRule") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ToolsOzoneLexicon.Safelink.UpdateRuleRequestBody(
            url: url,
            urlPattern: urlPattern,
            action: action,
            reason: reason,
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
