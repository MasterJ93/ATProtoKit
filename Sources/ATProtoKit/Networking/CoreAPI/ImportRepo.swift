//
//  ImportRepo.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-11.
//

import Foundation

extension ATProtoKit {
    /// Imports repository data.
    /// 
    /// This repository data is in the form of a CAR file. For more information about CAR files in context to AT Protocol, please go to the "[CAR File Serialization][car_link]" section of the Repository page in the AT Protocol documentation.
    /// 
    /// - Parameters:
    ///   - repositoryData: The repository data in the form of a CAR file.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `https://bsky.social`.
    ///
    /// [car_link]: https://atproto.com/specs/repository#car-file-serialization
    public static func importRepo(_ repositoryData: Data, pdsURL: String = "https://bsky.social") async throws {
        guard let requestURL = URL(string: "\(pdsURL)/xrpc/com.atproto.repo.importRepo") else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
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
            try await APIClientService.sendRequest(request, withEncodingBody: requestBody)
        } catch {
            throw error
        }
    }
}
