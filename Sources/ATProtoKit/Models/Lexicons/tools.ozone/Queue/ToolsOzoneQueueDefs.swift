//
//  ToolsOzoneQueueDefs.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-13.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ToolsOzoneLexicon.Queue {

    /// A definition model for a moderation queue view.
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.queue.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/queue/defs.json
    public struct QueueViewDefinition: Sendable, Codable {

        /// The ID of the queue.
        ///
        /// - Note: According to the AT Protocol specifications: "Queue ID"
        public let id: Int

        /// The display name of the queue.
        ///
        /// - Note: According to the AT Protocol specifications: "Display name of the queue"
        public let name: String

        /// The subject types this queue accepts. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Subject types this queue accepts."
        public let subjectTypes: [String]?

        /// The collection name for record subjects. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Collection name for record subjects
        /// (e.g., 'app.bsky.feed.post')"
        public let collection: String?

        /// Report reason types this queue accepts. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Report reason types this queue
        /// accepts (fully qualified NSIDs)"
        public let reportTypes: [String]?

        /// A description of the queue. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Optional description of the queue"
        public let description: String?

        /// Recommended policy keys for actioning reports in this queue. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Policy keys recommended when
        /// actioning reports in this queue"
        public let recommendedPolicies: [String]?

        /// The decentralized identifier (DID) of the moderator who created this queue.
        ///
        /// - Note: According to the AT Protocol specifications: "DID of moderator who created
        /// this queue"
        public let createdBy: String

        /// The date and time the queue was created.
        public let createdAt: Date

        /// The date and time the queue was last updated.
        public let updatedAt: Date

        /// Whether this queue is currently active.
        ///
        /// - Note: According to the AT Protocol specifications: "Whether this queue is currently active"
        public let isEnabled: Bool

        /// The date and time the queue was deleted, if applicable. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "When the queue was deleted,
        /// if applicable"
        public let deletedAt: Date?

        /// Statistics about this queue.
        ///
        /// - Note: According to the AT Protocol specifications: "Statistics about this queue"
        public let stats: QueueStatisticsDefinition

        public init(id: Int, name: String, subjectTypes: [String]? = nil, collection: String? = nil,
                    reportTypes: [String]? = nil, description: String? = nil,
                    recommendedPolicies: [String]? = nil, createdBy: String, createdAt: Date,
                    updatedAt: Date, isEnabled: Bool, deletedAt: Date? = nil,
                    stats: QueueStatisticsDefinition) {
            self.id = id
            self.name = name
            self.subjectTypes = subjectTypes
            self.collection = collection
            self.reportTypes = reportTypes
            self.description = description
            self.recommendedPolicies = recommendedPolicies
            self.createdBy = createdBy
            self.createdAt = createdAt
            self.updatedAt = updatedAt
            self.isEnabled = isEnabled
            self.deletedAt = deletedAt
            self.stats = stats
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.id = try container.decode(Int.self, forKey: .id)
            self.name = try container.decode(String.self, forKey: .name)
            self.subjectTypes = try container.decodeIfPresent([String].self, forKey: .subjectTypes)
            self.collection = try container.decodeIfPresent(String.self, forKey: .collection)
            self.reportTypes = try container.decodeIfPresent([String].self, forKey: .reportTypes)
            self.description = try container.decodeIfPresent(String.self, forKey: .description)
            self.recommendedPolicies = try container.decodeIfPresent([String].self, forKey: .recommendedPolicies)
            self.createdBy = try container.decode(String.self, forKey: .createdBy)
            self.createdAt = try container.decodeDate(forKey: .createdAt)
            self.updatedAt = try container.decodeDate(forKey: .updatedAt)
            self.isEnabled = try container.decode(Bool.self, forKey: .isEnabled)
            self.deletedAt = try container.decodeDateIfPresent(forKey: .deletedAt)
            self.stats = try container.decode(QueueStatisticsDefinition.self, forKey: .stats)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.id, forKey: .id)
            try container.encode(self.name, forKey: .name)
            try container.encodeIfPresent(self.subjectTypes, forKey: .subjectTypes)
            try container.encodeIfPresent(self.collection, forKey: .collection)
            try container.encodeIfPresent(self.reportTypes, forKey: .reportTypes)
            try container.encodeIfPresent(self.description, forKey: .description)
            try container.encodeIfPresent(self.recommendedPolicies, forKey: .recommendedPolicies)
            try container.encode(self.createdBy, forKey: .createdBy)
            try container.encodeDate(self.createdAt, forKey: .createdAt)
            try container.encodeDate(self.updatedAt, forKey: .updatedAt)
            try container.encode(self.isEnabled, forKey: .isEnabled)
            try container.encodeDateIfPresent(self.deletedAt, forKey: .deletedAt)
            try container.encode(self.stats, forKey: .stats)
        }

        enum CodingKeys: String, CodingKey {
            case id
            case name
            case subjectTypes
            case collection
            case reportTypes
            case description
            case recommendedPolicies
            case createdBy
            case createdAt
            case updatedAt
            case isEnabled = "enabled"
            case deletedAt
            case stats
        }
    }

    /// A definition model for queue statistics.
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.queue.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/queue/defs.json
    public struct QueueStatisticsDefinition: Sendable, Codable {

        /// The number of reports in 'open' status. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Number of reports in 'open' status"
        public let pendingCount: Int?

        /// The number of reports in 'closed' status. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Number of reports in 'closed' status"
        public let actionedCount: Int?

        /// The number of reports in 'escalated' status. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Number of reports in 'escalated' status"
        public let escalatedCount: Int?

        /// Reports received in this queue in the last 24 hours. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Reports received in this queue
        /// in the last 24 hours."
        public let inboundCount: Int?

        /// Percentage of reports actioned, rounded to nearest integer. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Percentage of reports actioned
        /// (actionedCount / inboundCount * 100), rounded to nearest integer. Absent when
        /// inboundCount is 0."
        public let actionRate: Int?

        /// Average handling time in seconds. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Average time in seconds from report
        /// creation to close, for reports closed in this period."
        public let avgHandlingTimeSec: Int?

        /// When these statistics were last computed. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "When these statistics were
        /// last computed"
        public let lastUpdated: Date?

        public init(pendingCount: Int? = nil, actionedCount: Int? = nil,
                    escalatedCount: Int? = nil, inboundCount: Int? = nil,
                    actionRate: Int? = nil, avgHandlingTimeSec: Int? = nil,
                    lastUpdated: Date? = nil) {
            self.pendingCount = pendingCount
            self.actionedCount = actionedCount
            self.escalatedCount = escalatedCount
            self.inboundCount = inboundCount
            self.actionRate = actionRate
            self.avgHandlingTimeSec = avgHandlingTimeSec
            self.lastUpdated = lastUpdated
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.pendingCount = try container.decodeIfPresent(Int.self, forKey: .pendingCount)
            self.actionedCount = try container.decodeIfPresent(Int.self, forKey: .actionedCount)
            self.escalatedCount = try container.decodeIfPresent(Int.self, forKey: .escalatedCount)
            self.inboundCount = try container.decodeIfPresent(Int.self, forKey: .inboundCount)
            self.actionRate = try container.decodeIfPresent(Int.self, forKey: .actionRate)
            self.avgHandlingTimeSec = try container.decodeIfPresent(Int.self, forKey: .avgHandlingTimeSec)
            self.lastUpdated = try container.decodeDateIfPresent(forKey: .lastUpdated)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encodeIfPresent(self.pendingCount, forKey: .pendingCount)
            try container.encodeIfPresent(self.actionedCount, forKey: .actionedCount)
            try container.encodeIfPresent(self.escalatedCount, forKey: .escalatedCount)
            try container.encodeIfPresent(self.inboundCount, forKey: .inboundCount)
            try container.encodeIfPresent(self.actionRate, forKey: .actionRate)
            try container.encodeIfPresent(self.avgHandlingTimeSec, forKey: .avgHandlingTimeSec)
            try container.encodeDateIfPresent(self.lastUpdated, forKey: .lastUpdated)
        }

        enum CodingKeys: CodingKey {
            case pendingCount
            case actionedCount
            case escalatedCount
            case inboundCount
            case actionRate
            case avgHandlingTimeSec
            case lastUpdated
        }
    }

    /// A definition model for a queue moderator assignment view.
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.queue.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/queue/defs.json
    public struct QueueAssignmentViewDefinition: Sendable, Codable {

        /// The ID of the assignment.
        public let id: Int

        /// The decentralized identifier (DID) of the assigned moderator.
        public let did: String

        /// The full member record of the assigned moderator. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "The moderator assigned to
        /// this queue"
        public let moderator: ToolsOzoneLexicon.Team.MemberDefinition?

        /// The queue this assignment belongs to.
        public let queue: QueueViewDefinition

        /// The date and time the assignment starts.
        public let startAt: Date

        /// The date and time the assignment ends. Optional.
        public let endAt: Date?

        public init(id: Int, did: String, moderator: ToolsOzoneLexicon.Team.MemberDefinition? = nil,
                    queue: QueueViewDefinition, startAt: Date, endAt: Date? = nil) {
            self.id = id
            self.did = did
            self.moderator = moderator
            self.queue = queue
            self.startAt = startAt
            self.endAt = endAt
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.id = try container.decode(Int.self, forKey: .id)
            self.did = try container.decode(String.self, forKey: .did)
            self.moderator = try container.decodeIfPresent(ToolsOzoneLexicon.Team.MemberDefinition.self, forKey: .moderator)
            self.queue = try container.decode(QueueViewDefinition.self, forKey: .queue)
            self.startAt = try container.decodeDate(forKey: .startAt)
            self.endAt = try container.decodeDateIfPresent(forKey: .endAt)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.id, forKey: .id)
            try container.encode(self.did, forKey: .did)
            try container.encodeIfPresent(self.moderator, forKey: .moderator)
            try container.encode(self.queue, forKey: .queue)
            try container.encodeDate(self.startAt, forKey: .startAt)
            try container.encodeDateIfPresent(self.endAt, forKey: .endAt)
        }

        enum CodingKeys: CodingKey {
            case id
            case did
            case moderator
            case queue
            case startAt
            case endAt
        }
    }
}
