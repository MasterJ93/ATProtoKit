//
//  GetLabelerServices.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-14.
//

import Foundation

extension ATProtoKit {

    /// Gets information about various labeler services.
    /// 
    /// - Note: According to the AT Protocol specifications: "Get information about a list of
    /// labeler services."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.labeler.getServices`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/labeler/getServices.json
    ///
    /// - Parameters:
    ///   - labelerDIDs: An array of decentralized identifiers (DIDs) of labeler services.
    ///   - isDetailed: Indicates whether the information is detailed. Optional.
    /// - Returns: An array of labeler views.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getLabelerServices(
        labelerDIDs: [String],
        isDetailed: Bool? = nil
    ) async throws -> AppBskyLexicon.Labeler.GetServicesOutput {
        guard self.pdsURL != "" else {
            throw ATRequestPrepareError.emptyPDSURL
        }

        guard let requestURL = URL(string: "\(self.pdsURL)/xrpc/app.bsky.labeler.getServices") else {
            throw ATRequestPrepareError.invalidFormat
        }

        var queryItems = [(String, String)]()

        queryItems += labelerDIDs.map { ("dids", $0) }

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
                authorizationValue: nil
            )
            let response = try await APIClientService.shared.sendRequest(
                request, decodeTo:
                AppBskyLexicon.Labeler.GetServicesOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
