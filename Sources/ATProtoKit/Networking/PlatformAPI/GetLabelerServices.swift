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
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `nil`.
    /// - Returns: A `Result`, containing either a ``LabelerGetServicesOutput``
    /// if successful, or an `Error` if not.
    public func getLabelerServices(labelerDIDs: [String], isDetailed: Bool? = nil,
                                          pdsURL: String? = nil) async throws -> Result<LabelerGetServicesOutput, Error> {
        guard let sessionURL = pdsURL != nil ? pdsURL : session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.labeler.getServices") else {
            return .failure(ATRequestPrepareError.invalidFormat)
        }

        var queryItems = [(String, String)]()

        queryItems += labelerDIDs.map { ("dids", $0) }

        let queryURL: URL

        do {
            queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = APIClientService.createRequest(forRequest: queryURL,
                                                         andMethod: .get,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: nil,
                                                         authorizationValue: nil)
            let response = try await APIClientService.sendRequest(request, decodeTo:
                                                                  LabelerGetServicesOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
