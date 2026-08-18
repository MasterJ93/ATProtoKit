//
//  ToolsOzoneQueueDeleteQueue.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-13.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ToolsOzoneLexicon.Queue {

    /// A request body model for deleting a moderation queue.
    ///
    /// - Note: According to the AT Protocol specifications: "Delete a moderation queue.
    /// Optionally migrate reports to another queue."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.queue.deleteQueue`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/queue/deleteQueue.json
    public struct DeleteQueueRequestBody: Sendable, Codable {

        /// The ID of the queue to delete.
        ///
        /// - Note: According to the AT Protocol specifications: "ID of the queue to delete"
        public let queueID: Int

        /// The ID of the queue to migrate reports to. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Optional: migrate all reports to
        /// this queue. If not specified, reports will be set to unassigned (-1)."
        public let migrateToQueueID: Int?

        public init(queueID: Int, migrateToQueueID: Int? = nil) {
            self.queueID = queueID
            self.migrateToQueueID = migrateToQueueID
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.queueID = try container.decode(Int.self, forKey: .queueID)
            self.migrateToQueueID = try container.decodeIfPresent(Int.self, forKey: .migrateToQueueID)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.queueID, forKey: .queueID)
            try container.encodeIfPresent(self.migrateToQueueID, forKey: .migrateToQueueID)
        }

        enum CodingKeys: String, CodingKey {
            case queueID = "queueId"
            case migrateToQueueID = "migrateToQueueId"
        }
    }

    /// An output model for deleting a moderation queue.
    ///
    /// - Note: According to the AT Protocol specifications: "Delete a moderation queue."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.queue.deleteQueue`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/queue/deleteQueue.json
    public struct DeleteQueueOutput: Sendable, Codable {

        /// Whether the queue was deleted.
        public let isDeleted: Bool

        /// The number of reports migrated. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Number of reports that were
        /// migrated (if migration occurred)"
        public let reportsMigrated: Int?

        enum CodingKeys: String, CodingKey {
            case isDeleted = "deleted"
            case reportsMigrated
        }
    }
}
