//
//  GetRecordAsAdmin.swift
//  
//
//  Created by Christopher Jr Riley on 2024-03-01.
//

import Foundation

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
    ///   - recordURI: The URI of the record.
    ///   - recordCID: The CID hash of the record. Optional.
    /// - Returns: A detailed view of a record.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getRecord(
        _ recordURI: String,
        recordCID: String? = nil
    ) async throws -> ToolsOzoneLexicon.Moderation.RecordViewDetailDefinition {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.moderation.getRecord") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [("uri", recordURI)]

        if let recordCID {
            queryItems.append(("cid", recordCID))
        }

        let queryURL: URL

        do {
            queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = APIClientService.createRequest(
                forRequest: queryURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await APIClientService.shared.sendRequest(
                request,
                decodeTo: ToolsOzoneLexicon.Moderation.RecordViewDetailDefinition.self
            )

            return response
        } catch {
            throw error
        }
    }
}
