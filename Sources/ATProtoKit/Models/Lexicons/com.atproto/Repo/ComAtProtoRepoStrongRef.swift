//
//  ComAtProtoRepoStrongRef.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation

extension ComAtprotoLexicon.Repository {

    /// A main data model definition for a strong reference.
    ///
    /// - Note: According to the AT Protocol specifications: "A URI with a
    /// content-hash fingerprint."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.repo.strongRef`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/repo/strongRef.json
    public struct StrongReference: Sendable, Codable {

        /// The URI for the record.
        public let recordURI: String

        /// The CID hash for the record.
        public let recordCID: String

        public init(recordURI: String, cidHash: String) {
            self.recordURI = recordURI
            self.recordCID = cidHash
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.recordURI = try container.decode(String.self, forKey: .recordURI)
            self.recordCID = try container.decode(String.self, forKey: .recordCID)
        }

        enum CodingKeys: String, CodingKey {
            case recordURI = "uri"
            case recordCID = "cid"
        }
    }
}
