//
//  ComAtprotoRepoDefs.swift
//
//
//  Created by Christopher Jr Riley on 2024-09-19.
//

import Foundation

extension ComAtprotoLexicon.Repository {

    /// A definition model for a commit meta.
    ///
    /// - SeeAlso: This is based on the [`com.atproto.repo.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/repo/defs.json
    public struct CommitMetaDefinition: Codable {

        /// The CID of the commit.
        public let commitCID: String

        /// The revision of the commit.
        public let commitRevision: String

        enum CodingKeys: String, CodingKey {
            case commitCID = "cid"
            case commitRevision = "rev"
        }
    }
}
