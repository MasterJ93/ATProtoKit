//
//  ComAtprotoSyncGetHostStatus.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-05-17.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ComAtprotoLexicon.Sync {

    /// An output model for describing a specified upstream host, as used by the server.
    ///
    /// - Note: According to the AT Protocol specifications: "Returns information about a specified upstream
    /// host, as consumed by the server. Implemented by relays."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.sync.getHostStatus`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/sync/getHostStatus.json
    public struct GetHostStatusOutput: Sendable, Codable {

        /// The hostname of the host.
        public let hostname: String

        /// The repository stream event sequence number in the relay. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Recent repo stream event sequence number.
        /// May be delayed from actual stream processing (eg, persisted cursor not in-memory cursor)."
        public let sequence: Int?

        /// The number of user accounts related to the upstream host. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Number of accounts on the server which are
        /// associated with the upstream host. Note that the upstream may actually have more accounts."
        public let accountCount: Int?

        /// The status of the host. Optional.
        public let status: ComAtprotoLexicon.Sync.HostStatusDefinition?

        enum CodingKeys: String, CodingKey {
            case hostname
            case sequence = "seq"
            case accountCount
            case status
        }
    }
}
