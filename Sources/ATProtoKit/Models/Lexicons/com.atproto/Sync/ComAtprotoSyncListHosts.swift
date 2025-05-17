//
//  ComAtprotoSyncListHosts.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-05-17.
//

import Foundation

extension ComAtprotoLexicon.Sync {

    /// The main data model definition for listing the upstream hosts, such as a Personal Data Server (PDS)
    /// or Relay) that this service uses.
    ///
    /// - Note: According to the AT Protocol specifications: "Enumerates upstream hosts (eg, PDS or
    /// relay instances) that this service consumes from. Implemented by relays."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.sync.listHosts`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/sync/listHosts.json
    public struct ListHosts: Sendable, Codable {

        /// The upstream host.
        public struct Host: Sendable, Codable {

            /// The hostname of the host.
            ///
            /// - Note: According to the AT Protocol specifications: "hostname of server; not a URL
            /// (no scheme)."
            public let hostname: String

            /// The repository stream event sequence number in the relay. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "Recent repo stream event sequence number. May be
            /// delayed from actual stream processing (eg, persisted cursor not in-memory cursor)."
            public let sequence: Int?

            /// The number of user accounts related to the upstream host. Optional.
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

    /// An output model for listing the upstream hosts, such as a Personal Data Server (PDS) or Relay) that
    /// this service uses.
    ///
    /// - Note: According to the AT Protocol specifications: "Enumerates upstream hosts (eg, PDS or
    /// relay instances) that this service consumes from. Implemented by relays."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.sync.listHosts`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/sync/listHosts.json
    public struct ListHostsOutput: Sendable, Codable {

        /// An array of hosts.
        public let hosts: [ListHosts.Host]
    }
}
