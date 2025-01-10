//
//  AppBskyLabelerService.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension AppBskyLexicon.Labeler {

    /// A record model for a labeler service.
    ///
    /// - Note: According to the AT Protocol specifications: "A declaration of the existence of
    /// labeler service."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.labeler.service`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/labeler/service.json
    public struct ServiceRecord: ATRecordProtocol, Sendable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public static let type: String = "app.bsky.labeler.service"

        /// The policies the labeler service adheres to.
        public let policies: LabelerPolicies

        /// An array of labels the labeler uses. Optional.
        public let labels: [ComAtprotoLexicon.Label.SelfLabelDefinition]?

        /// The date and time the labeler service was created.
        public let createdAt: Date

        public init(policies: LabelerPolicies, labels: [ComAtprotoLexicon.Label.SelfLabelDefinition], createdAt: Date) {
            self.policies = policies
            self.labels = labels
            self.createdAt = createdAt
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.policies = try container.decode(LabelerPolicies.self, forKey: .policies)
            self.labels = try container.decode([ComAtprotoLexicon.Label.SelfLabelDefinition].self, forKey: .labels)
            self.createdAt = try container.decodeDate(forKey: .createdAt)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.policies, forKey: .policies)
            try container.encode(self.labels, forKey: .labels)
            try container.encodeDate(self.createdAt, forKey: .createdAt)
        }

        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case policies
            case labels
            case createdAt
        }
    }
}
