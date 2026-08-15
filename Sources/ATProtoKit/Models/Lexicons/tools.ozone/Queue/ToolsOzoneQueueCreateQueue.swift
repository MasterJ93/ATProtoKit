//
//  ToolsOzoneQueueCreateQueue.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-13.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ToolsOzoneLexicon.Queue {

    /// A request body model for creating a new moderation queue.
    ///
    /// - Note: According to the AT Protocol specifications: "Create a new moderation queue. A queue
    /// can have optional matching criteria that ozone's queue router will use to match reports. A
    /// queue with no criteria must have reports assigned to it manually via (1) `modTool.meta.queueId`
    /// in `tools.ozone.moderation.emitEvent` or (2) `tools.ozone.report.reassignQueue`."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.queue.createQueue`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/queue/createQueue.json
    public struct CreateQueueRequestBody: Sendable, Codable {

        /// The display name for the queue.
        ///
        /// - Note: According to the AT Protocol specifications: "Display name for the queue
        /// (must be unique)"
        public let name: String

        /// Subject types this queue accepts. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Subject types this queue accepts"
        public let subjectTypes: [String]?

        /// Collection name for record subjects. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Collection name for record subjects.
        /// Required if subjectTypes includes 'record'."
        public let collection: String?

        /// Report reason types for this queue. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Report reason types
        /// (fully qualified NSIDs)"
        public let reportTypes: [String]?

        /// A description of the queue. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Optional description of the queue"
        public let description: String?

        /// Recommended policy keys for actioning reports in this queue. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Policy keys to recommend when
        /// actioning reports in this queue"
        public let recommendedPolicies: [String]?

        public init(name: String, subjectTypes: [String]? = nil, collection: String? = nil,
                    reportTypes: [String]? = nil, description: String? = nil,
                    recommendedPolicies: [String]? = nil) {
            self.name = name
            self.subjectTypes = subjectTypes
            self.collection = collection
            self.reportTypes = reportTypes
            self.description = description
            self.recommendedPolicies = recommendedPolicies
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.name = try container.decode(String.self, forKey: .name)
            self.subjectTypes = try container.decodeIfPresent([String].self, forKey: .subjectTypes)
            self.collection = try container.decodeIfPresent(String.self, forKey: .collection)
            self.reportTypes = try container.decodeIfPresent([String].self, forKey: .reportTypes)
            self.description = try container.decodeIfPresent(String.self, forKey: .description)
            self.recommendedPolicies = try container.decodeIfPresent([String].self, forKey: .recommendedPolicies)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.name, forKey: .name)
            try container.encodeIfPresent(self.subjectTypes, forKey: .subjectTypes)
            try container.encodeIfPresent(self.collection, forKey: .collection)
            if let reportTypes, reportTypes.count > 0 {
                try container.truncatedEncode(reportTypes, forKey: .reportTypes, upToArrayLength: 25)
            }
            try container.encodeIfPresent(self.description, forKey: .description)
            try container.encodeIfPresent(self.recommendedPolicies, forKey: .recommendedPolicies)
        }

        enum CodingKeys: CodingKey {
            case name
            case subjectTypes
            case collection
            case reportTypes
            case description
            case recommendedPolicies
        }
    }

    /// An output model for creating a new moderation queue.
    ///
    /// - Note: According to the AT Protocol specifications: "Create a new moderation queue."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.queue.createQueue`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/queue/createQueue.json
    public struct CreateQueueOutput: Sendable, Codable {

        /// The newly created queue.
        public let queue: QueueViewDefinition
    }
}
