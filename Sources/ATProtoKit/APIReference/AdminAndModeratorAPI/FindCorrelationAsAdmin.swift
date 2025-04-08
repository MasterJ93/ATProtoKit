//
//  FindCorrelationAsAdmin.swift
//
//
//  Created by Christopher Jr Riley on 2024-10-24.
//

import Foundation

extension ATProtoAdmin {

    /// Searches all threat signatures between at least two user accounts.
    /// 
    /// - Note: According to the AT Protocol specifications: "Find all correlated threat
    /// signatures between 2 or more accounts."
    /// 
    /// - SeeAlso: This is based on the [`tools.ozone.signature.findCorrelation`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/signature/findCorrelation.json
    /// 
    /// - Parameter dids: An array of decentralized identifiers (DIDs).
    /// - Returns: An array of details for each signature.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func findCorrelation(by dids: [String]) async throws -> ToolsOzoneLexicon.Signature.FindCorrelationOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try keychain.retrieveAccessToken()

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.signature.findCorrelation") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        queryItems += dids.map { ("dids", $0) }

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
                decodeTo: ToolsOzoneLexicon.Signature.FindCorrelationOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
