//
//  AtprotoRepoImportRepo.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-11.
//

import Foundation

/// The main data model definition for importing a CAR file.
///
/// - Note: According to the AT Protocol specifications: "Import a repo in the form of a CAR file. Requires Content-Length HTTP header to be set."
///
/// - SeeAlso: This is based on the [`com.atproto.repo.importRepo`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/repo/importRepo.json
public struct RepoImportRepo: Codable {
    /// The repository data in the form of a CAR file.
    public let repository: Data
}
