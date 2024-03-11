//
//  ApplyWrites.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-11.
//

import Foundation

extension ATProtoKit {
    /// Applies creation, updates, and deletion transactions into the repository in batches.
    /// 
    /// - Parameters:
    ///   - repositoryDID: The decentralized identifier (DID) or handle of the repository.
    ///   - shouldValidate: Indicates whether the operation should be validated. Optional. Defaults to `true`.
    ///   - writes: The write operation itself.
    ///   - swapCommit: Swaps out an operation based on the CID. Optional.
    public func applyWrites(_ repositoryDID: String, shouldValidate: Bool? = true, writes: [ApplyWritesUnion], swapCommit: String?) async throws {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.repo.applyWrites") else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }

        let requestBody = RepoApplyWrites(
            repositoryDID: repositoryDID,
            shouldValidate: shouldValidate,
            writes: writes,
            swapCommit: swapCommit
        )

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .post,
                                                         acceptValue: nil,
                                                         contentTypeValue: "application/json",
                                                         authorizationValue: "Bearer \(session.accessToken)")

            let response = try await APIClientService.sendRequest(request, withEncodingBody: requestBody)
        } catch {
            throw error
        }
    }
}
