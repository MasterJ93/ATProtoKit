//
//  GetBlob.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-10.
//

import Foundation

extension ATProtoKit {
    /// Retrieves a blob from a given record.
    ///
    /// - Parameter blobQuery: An object containing the `accountDID` and `cidHash` of the blob.
    /// - Returns: A `Result` containing `Data` on success or `Error` on failure.
    public static func getBlob(from blobQuery: BlobQuery, pdsURL: String? = "https://bsky.social") async -> Result<Data, Error> {
        guard let sessionURL = pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.sync.getBlob") else {
            print("Failure")
            return .failure(URIError.invalidFormat)
        }

        do {
            let queryItems = [
                ("did", blobQuery.accountDID),
                ("cid", blobQuery.cidHash)
            ]

            let queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = APIClientService.createRequest(forRequest: queryURL,
                                                         andMethod: .get,
                                                         acceptValue: "'*/*'",
                                                         contentTypeValue: nil,
                                                         authorizationValue: nil)
            let response = try await APIClientService.sendRequest(request)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
