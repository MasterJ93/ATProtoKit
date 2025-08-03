//
//  GetRecordAsAdmin.swift
//  
//
//  Created by Christopher Jr Riley on 2024-03-01.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoAdmin {

    /// Gets details about a record as an administrator pr moderator.
    /// 
    /// - Important: This is a moderator task and as such, regular users won't be able to access
    /// this; if they attempt to do so, an error will occur.
    ///
    /// - Note: According to the AT Protocol specifications: "Get details about a record."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.getRecord`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/getRecord.json
    ///
    /// - Parameters:
    ///   - uri: The URI of the record.
    ///   - cid: The CID hash of the record. Optional.
    /// - Returns: A detailed view of a record.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getRecord(
        uri: String,
        cid: String? = nil
    ) async throws -> ToolsOzoneLexicon.Moderation.RecordViewDetailDefinition {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        try await sessionConfiguration?.ensureValidToken()
        let accessToken = try await keychain.retrieveAccessToken()

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.moderation.getRecord") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [("uri", uri)]

        if let cid {
            queryItems.append(("cid", cid))
        }

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
                decodeTo: ToolsOzoneLexicon.Moderation.RecordViewDetailDefinition.self
            )

            return response
        } catch {
            throw error
        }
    }
}
