//
//  ImportRepository.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-11.
//

import Foundation

extension ATProtoKit {

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
    /// - Parameters:
    ///   - repositoryData: The repository data in the form of a CAR file.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `nil`.
    public func importRepository(
        _ repositoryData: Data,
        pdsURL: String? = nil
    ) async throws {
        guard let sessionURL = pdsURL != nil ? pdsURL : session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.repo.importRepo") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = RepoImportRepo(
            repository: repositoryData
        )

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .get,
                                                         acceptValue: nil,
                                                         contentTypeValue: "application/vnd.ipld.car",
                                                         authorizationValue: nil)

            try await APIClientService.sendRequest(request,
                                                   withEncodingBody: requestBody)
        } catch {
            throw error
        }
    }
}
