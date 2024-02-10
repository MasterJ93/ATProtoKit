//
//  GetRecord.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-08.
//

import Foundation

extension ATProtoKit {
    public static func getRecord(from recordQuery: RecordQuery, pdsURL: String = "https://bsky.social") async throws -> Result<RecordOutput, Error> {
        guard let requestURL = URL(string: "\(pdsURL)/xrpc/com.atproto.repo.getRecord") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        do {
            let queryURL = try await APIClientService.setQueryItems(
                for: requestURL,
                with:[("repo", recordQuery.repo),
                      ("collection", recordQuery.collection),
                      ("rkey", recordQuery.recordKey)
                ]
            )

            print("\n===\nqueryURL: \(queryURL)")
            let request = APIClientService.createRequest(forRequest: queryURL, andMethod: .get, authorizationValue: nil)

            let response = try await APIClientService.sendRequest(request, decodeTo: RecordOutput.self)
            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
