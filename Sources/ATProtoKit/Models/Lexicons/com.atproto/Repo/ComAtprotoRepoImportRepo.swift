//
//  ComAtprotoRepoImportRepo.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation

extension ComAtprotoLexicon.Repository {

    /// A request body model for importing a CAR file.
    ///
    /// - Note: According to the AT Protocol specifications: "Import a repo in the form of a
    /// CAR file. Requires Content-Length HTTP header to be set."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.repo.importRepo`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/repo/importRepo.json
    public struct ImportRepositoryRequestBody: Sendable, Codable {

        /// The repository data in the form of a CAR file.
        public let repository: Data
    }
}
