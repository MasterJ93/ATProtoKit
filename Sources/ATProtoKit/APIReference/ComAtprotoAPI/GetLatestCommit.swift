//
//  GetLatestCommit.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-12.
//

import Foundation

extension ATProtoKit {

    /// Gets a repository's latest commit CID.
    /// 
    /// - Note: According to the AT Protocol specifications: "Get the current commit CID &
    /// revision of the specified repo. Does not require auth."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.sync.getLatestCommit`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/sync/getLatestCommit.json
    ///
    /// - Parameter repositoryDID: The decentralized identifier (DID) of the repository.
    /// - Returns: The commit CID and revision of the repository.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getLatestCommit(
        from repositoryDID: String
    ) async throws -> ComAtprotoLexicon.Sync.GetLatestCommitOutput {
        guard let requestURL = URL(string: "https://bsky.network/xrpc/com.atproto.sync.getLatestCommit") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let queryItems = [
            ("did", repositoryDID)
        ]

        let queryURL: URL

        do {
            queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = await APIClientService.createRequest(
                forRequest: queryURL,
                andMethod: .get,
                acceptValue: "application/vnd.ipld.car",
                contentTypeValue: nil,
                authorizationValue: nil
            )
            let response = try await APIClientService.shared.sendRequest(
                request,
                decodeTo: ComAtprotoLexicon.Sync.GetLatestCommitOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
