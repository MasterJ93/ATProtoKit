//
//  ToolsOzoneQueueUnassignModerator.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-13.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ToolsOzoneLexicon.Queue {

    /// A request body model for removing a moderator's assignment from a queue.
    ///
    /// - Note: According to the AT Protocol specifications: "Remove a user's assignment
    /// from a queue."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.queue.unassignModerator`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/queue/unassignModerator.json
    public struct UnassignModeratorRequestBody: Sendable, Codable {

        /// The ID of the queue to unassign the user from.
        ///
        /// - Note: According to the AT Protocol specifications: "The ID of the queue to unassign
        /// the user from."
        public let queueID: Int

        /// The decentralized identifier (DID) of the moderator to unassign.
        ///
        /// - Note: According to the AT Protocol specifications: "DID to be unassigned."
        public let did: String

        public init(queueID: Int, did: String) {
            self.queueID = queueID
            self.did = did
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.queueID = try container.decode(Int.self, forKey: .queueID)
            self.did = try container.decode(String.self, forKey: .did)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.queueID, forKey: .queueID)
            try container.encode(self.did, forKey: .did)
        }

        enum CodingKeys: String, CodingKey {
            case queueID = "queueId"
            case did
        }
    }
}
