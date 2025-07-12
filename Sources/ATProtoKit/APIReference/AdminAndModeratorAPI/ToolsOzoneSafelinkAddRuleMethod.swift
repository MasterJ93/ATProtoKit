//
//  ToolsOzoneSafelinkAddRuleMethod.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-07-11.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoAdmin {

    /// Adds a safety rule for a URL.
    ///
    /// - Note: According to the AT Protocol specifications: "Add a new URL safety rule."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.safelink.addRule`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/safelink/addRule.json
    ///
    /// - Parameters:
    ///   - url: The URL or domain the rule applies to.
    ///   - urlPattern: A string declaring the pattern of the URL.
    ///   - action: A string declaring the action taken to the URL.
    ///   - reason: A string declaring the reason for the action against the URL.
    ///   - comment: A comment attached to the event. Optional.
    ///   - createdBy: The decentralized identifier (DID) of the user account that created this event.
    /// - Returns: The successfully-created URL safety rule.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func addRule(
        url: URL,
        urlPattern: ToolsOzoneLexicon.Safelink.PatternTypeDefinition,
        action: ToolsOzoneLexicon.Safelink.ActionTypeDefinition,
        reason: ToolsOzoneLexicon.Safelink.ReasonTypeDefinition,
        comment: String? = nil,
        createdBy: String
    ) async throws -> ToolsOzoneLexicon.Safelink.URLRuleDefinition {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.safelink.addRule") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ToolsOzoneLexicon.Safelink.AddRuleRequestBody(
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
                decodeTo: ToolsOzoneLexicon.Safelink.URLRuleDefinition.self
            )

            return response
        } catch {
            throw error
        }
    }
}
