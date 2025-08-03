//
//  GetSubjectsAsAdmin.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-03-31.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoAdmin {

    /// Retrieves the details of subjects.
    /// 
    /// - Note: According to the AT Protocol specifications: "Get details about subjects."
    /// 
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.getSubjects`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/getSubjects.json
    /// 
    /// - Parameter subjects: An array of subjects.
    /// - Returns: An array of the subject's details.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getSubjects(_ subjects: [String]) async throws -> ToolsOzoneLexicon.Moderation.GetSubjectsOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        try await sessionConfiguration?.ensureValidToken()
        let accessToken = try await keychain.retrieveAccessToken()

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.moderation.getSubjects") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        let cappedsubjectsArray = subjects.prefix(100)
        queryItems += cappedsubjectsArray.map { ("subjects", $0) }

        let queryURL: URL

        do {
            queryURL = try apiClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = apiClientService.createRequest(
                forRequest: queryURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await apiClientService.sendRequest(
                request,
                decodeTo: ToolsOzoneLexicon.Moderation.GetSubjectsOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
