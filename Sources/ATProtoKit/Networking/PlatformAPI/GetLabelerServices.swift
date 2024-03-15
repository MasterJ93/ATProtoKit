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
    /// - Parameters:
    ///   - labelerDIDs: An array of decentralized identifiers (DIDs) of labeler services.
    ///   - isDetailed: Indicates whether the information is detailed. Optional.
    ///   - pdsURL: The URL of the Personal Data Service (PDS). Defaults to `https://bsky.social`.
    /// - Returns: A `Result`, containing either a ``LabelerGetServicesOutput`` if successful, or an `Error` if not.
    public static func getLabelerServices(labelerDIDs: [String], isDetailed: Bool? = nil, pdsURL: String = "https://bsky.social") async throws -> Result<LabelerGetServicesOutput, Error> {
        guard let requestURL = URL(string: "\(pdsURL)/xrpc/app.bsky.labeler.getServices") else {
            print("Failure")
            return .failure(URIError.invalidFormat)
        }

        var queryItems = [(String, String)]()

        queryItems += labelerDIDs.map { ("dids", $0) }

        do {
            let queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = APIClientService.createRequest(forRequest: queryURL,
                                                         andMethod: .get,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: nil,
                                                         authorizationValue: nil)
            let response = try await APIClientService.sendRequest(request, decodeTo: LabelerGetServicesOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
