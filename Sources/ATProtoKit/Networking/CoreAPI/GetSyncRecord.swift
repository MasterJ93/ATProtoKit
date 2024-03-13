//
//  GetSyncRecord.swift
//  
//
//  Created by Christopher Jr Riley on 2024-02-18.
//

import Foundation

extension ATProtoKit {
    /// Gets a record as a .car format.
    ///
    /// - Parameters:
    ///   - recordQuery: The information required to get a record.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `https://bsky.social`.
    /// - Returns: A `Result`, containing either a `Data` if successful, or an `Error` if not.
    public static func getSyncRecord(_ recordQuery: RecordQuery, pdsURL: String = "https://bsky.social") async throws -> Result<Data, Error> {
        guard let requestURL = URL(string: "\(pdsURL)/xrpc/com.atproto.sync.getRecord") else {
            return .failure(URIError.invalidFormat)
        }

        do {
            var queryItems = [
                ("repo", recordQuery.repo),
                ("collection", recordQuery.collection),
                ("rkey", recordQuery.recordKey)
            ]

            if let cid = recordQuery.recordCID {
                queryItems.append(("cid", cid))
            }

            let queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = APIClientService.createRequest(forRequest: queryURL,
                                                         andMethod: .get,
                                                         authorizationValue: nil)
            let response = try await APIClientService.sendRequest(request)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
