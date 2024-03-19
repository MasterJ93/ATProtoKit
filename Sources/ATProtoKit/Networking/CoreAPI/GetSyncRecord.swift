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
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `nil`.
    /// - Returns: A `Result`, containing either a `Data` if successful, or an `Error` if not.
    public func getSyncRecord(_ recordQuery: RecordQuery,
                                     pdsURL: String? = nil) async throws -> Result<Data, Error> {
        guard let sessionURL = pdsURL != nil ? pdsURL : session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.sync.getRecord") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        var queryItems = [
            ("repo", recordQuery.repo),
            ("collection", recordQuery.collection),
            ("rkey", recordQuery.recordKey)
        ]

        if let cid = recordQuery.recordCID {
            queryItems.append(("cid", cid))
        }

        let queryURL: URL

        do {
            queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = APIClientService.createRequest(forRequest: queryURL,
                                                         andMethod: .get,
                                                         acceptValue: "application/vnd.ipld.car",
                                                         contentTypeValue: nil,
                                                         authorizationValue: nil)
            let response = try await APIClientService.sendRequest(request)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
