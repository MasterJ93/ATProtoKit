//
//  ToolsOzoneQueueUpdateQueue.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-13.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ToolsOzoneLexicon.Queue {

    /// A request body model for updating queue properties.
    ///
    /// - Note: According to the AT Protocol specifications: "Update queue properties."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.queue.updateQueue`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/queue/updateQueue.json
    public struct UpdateQueueRequestBody: Sendable, Codable {

        /// The ID of the queue to update.
        ///
        /// - Note: According to the AT Protocol specifications: "ID of the queue to update"
        public let queueID: Int

        /// A new display name for the queue. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "New display name for the queue"
        public let name: String?

        /// Whether the queue is enabled. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Enable or disable the queue"
        public let isEnabled: Bool?

        /// A description of the queue. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Optional description of the queue"
        public let description: String?

        /// Recommended policy keys for actioning reports in this queue. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Policy keys to recommend when
        /// actioning reports in this queue"
        public let recommendedPolicies: [String]?

        public init(queueID: Int, name: String? = nil, isEnabled: Bool? = nil,
                    description: String? = nil, recommendedPolicies: [String]? = nil) {
            self.queueID = queueID
            self.name = name
            self.isEnabled = isEnabled
            self.description = description
            self.recommendedPolicies = recommendedPolicies
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.queueID = try container.decode(Int.self, forKey: .queueID)
            self.name = try container.decodeIfPresent(String.self, forKey: .name)
            self.isEnabled = try container.decodeIfPresent(Bool.self, forKey: .isEnabled)
            self.description = try container.decodeIfPresent(String.self, forKey: .description)
            self.recommendedPolicies = try container.decodeIfPresent([String].self, forKey: .recommendedPolicies)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.queueID, forKey: .queueID)
            try container.encodeIfPresent(self.name, forKey: .name)
            try container.encodeIfPresent(self.isEnabled, forKey: .isEnabled)
            try container.encodeIfPresent(self.description, forKey: .description)
            try container.encodeIfPresent(self.recommendedPolicies, forKey: .recommendedPolicies)
        }

        enum CodingKeys: String, CodingKey {
            case queueID = "queueId"
            case name
            case isEnabled = "enabled"
            case description
            case recommendedPolicies
        }
    }

    /// An output model for updating queue properties.
    ///
    /// - Note: According to the AT Protocol specifications: "Update queue properties."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.queue.updateQueue`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/queue/updateQueue.json
    public struct UpdateQueueOutput: Sendable, Codable {

        /// The updated queue.
        public let queue: QueueViewDefinition
    }
}
