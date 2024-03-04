//
//  DescribeServer.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-25.
//

import Foundation

extension ATProtoKit {
    /// Describes the server instance in the AT Protocol.
    /// 
    /// - Parameter pdsURL: The URL for the Personal Data Server (PDS). Defaults to `https://bsky.social`.
    /// - Returns: A `Result`, containing either a ``ServerDescribeServerOutput`` if successful, or an `Error` if not.
    public static func describeServer(_ pdsURL: String = "https://bsky.social") async throws -> Result<ServerDescribeServerOutput, Error> {
        guard let requestURL = URL(string: "\(pdsURL)/xrpc/com.atproto.server.describeServer") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .get,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: nil,
                                                         authorizationValue: nil)
            let response = try await APIClientService.sendRequest(request, decodeTo: ServerDescribeServerOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
