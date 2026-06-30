//
//  ComAtprotoRepoDescribeRepoMethod.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-11.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Describes the repository.
    /// 
    /// - Note: According to the AT Protocol specifications: "Get information about an account
    /// and repository, including the list of collections. Does not require auth."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.repo.describeRepo`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/repo/describeRepo.json
    ///
    /// - Parameters:
    ///   - repositoryDID: The decentralized identifier (DID) or handle of the repository.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Optional. Defaults to `nil`.
    /// - Returns: Some general information about the repository that matches `repositoryDID`.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func describeRepository(
        _ repositoryDID: String,
        pdsURL: String? = nil
    ) async throws -> ComAtprotoLexicon.Repository.DescribeRepositoryOutput {
        let host: String
        if let pdsURL, !pdsURL.isEmpty {
            host = pdsURL
        } else {
            host = await resolvePDSHost(for: repositoryDID)
        }

        guard let requestURL = URL(string: "\(host)/xrpc/com.atproto.repo.describeRepo") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        queryItems.append(("repo", repositoryDID))

        let queryURL: URL

        do {
            queryURL = try apiClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = apiClientService.createRequest(
                forRequest: queryURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: nil
            )
            let response = try await apiClientService.sendRequest(
                request,
                decodeTo: ComAtprotoLexicon.Repository.DescribeRepositoryOutput.self
            )

            return response
        } catch {
            throw error
        }
    }

    /// Determines the base hostname for a repository-scoped request.
    ///
    /// Some `com.atproto.repo.*` methods are implemented by the Personal Data Server (PDS) that
    /// hosts the target repository, which may differ from the instance's own PDS. This resolves
    /// the PDS service endpoint from the target DID via ``ATBuiltInIdentityResolver``, falling back
    /// to the instance's own ``pdsURL`` (the prior behaviour, served via entryway proxying) when
    /// resolution isn't possible.
    ///
    /// Resolution is only attempted when `repository` is a DID; handles fall through to the
    /// instance's own host to preserve existing behaviour. Callers that already know the PDS URL
    /// should use it directly instead of calling this method.
    ///
    /// - Parameter repository: The decentralized identifier (DID) or handle of the target repository.
    /// - Returns: The base hostname to use for the request.
    func resolvePDSHost(for repository: String) async -> String {
        if repository.hasPrefix("did:"),
           let endpoint = try? await ATBuiltInIdentityResolver().resolvePDSEndpoint(from: repository) {
            return endpoint
        }

        return pdsURL
    }
}
