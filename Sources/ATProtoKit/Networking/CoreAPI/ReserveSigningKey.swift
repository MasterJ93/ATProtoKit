//
//  ReserveSigningKey.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-25.
//

import Foundation

extension ATProtoKit {
    /// Reserves a signing key for the respository.
    /// 
    /// - Parameters:
    ///   - repositoryDID: The decentalized identifier (DID) of the repository.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `https://bsky.social`.
    /// - Returns: A `Result`, containing either a ``ServerReserveSigningKeyOutput`` if successful, or an `Error` if not.
    public static func reserveSigningKey(_ repositoryDID: String, pdsURL: String = "https://bsky.social") async throws -> Result<ServerReserveSigningKeyOutput, Error> {
        let finalPDSURL = determinePDSURL(accessToken: nil, customPDSURL: pdsURL)
        guard let requestURL = URL(string: "\(finalPDSURL)/xrpc/com.atproto.server.reserveSigningKey") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "Invalid URL"]))
        }

        let requestBody = ServerReserveSigningKey(repositoryDID: repositoryDID)

        do {
            let request = APIClientService.createRequest(forRequest: requestURL, andMethod: .post, acceptValue: "application/json", contentTypeValue: "application/json", authorizationValue: nil)
            let response = try await APIClientService.sendRequest(request, withEncodingBody: requestBody, decodeTo: ServerReserveSigningKeyOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
