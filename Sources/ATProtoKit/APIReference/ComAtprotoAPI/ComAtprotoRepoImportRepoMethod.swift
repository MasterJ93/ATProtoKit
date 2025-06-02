//
//  ComAtprotoRepoImportRepoMethod.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-11.
//

import Foundation

extension ATProtoKit {

    // TODO: Find out more information about what needs to be added to "Content-Length's HTTP header.
    /// Imports repository data.
    /// 
    /// This repository data is in the form of a CAR file. For more information about CAR files in
    /// context to AT Protocol, please go to the "[CAR File Serialization][car_link]" section
    /// of the Repository page in the AT Protocol documentation.
    ///
    /// - Note: According to the AT Protocol specifications: "Import a repo in the form of a
    /// CAR file. Requires Content-Length HTTP header to be set."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.repo.importRepo`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/repo/importRepo.json
    /// [car_link]: https://atproto.com/specs/repository#car-file-serialization
    ///
    /// - Parameter repositoryData: The repository data in the form of a CAR file.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func importRepository(
        _ repositoryData: Data
    ) async throws {
        guard let requestURL = URL(string: "\(self.pdsURL)/xrpc/com.atproto.repo.importRepo") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ComAtprotoLexicon.Repository.ImportRepositoryRequestBody(
            repository: repositoryData
        )

        do {
            let request = apiClientService.createRequest(
                forRequest: requestURL,
                andMethod: .get,
                acceptValue: nil,
                contentTypeValue: "application/vnd.ipld.car",
                authorizationValue: nil
            )

            _ = try await apiClientService.sendRequest(
                request,
                withEncodingBody: requestBody
            )
        } catch {
            throw error
        }
    }
}
