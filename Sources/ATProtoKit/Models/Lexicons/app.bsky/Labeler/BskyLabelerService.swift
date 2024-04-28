//
//  BskyLabelerService.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-14.
//

import Foundation

/// The main data model definition for a labeler service record.
///
/// - Note: According to the AT Protocol specifications: "A declaration of the existence of labeler service."
///
/// - SeeAlso: This is based on the [`app.bsky.labeler.service`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/labeler/service.json
public struct LabelerService: ATRecordProtocol {
    /// The identifier of the lexicon.
    ///
    /// - Warning: The value must not change.
    public private(set) var type: String = "app.bsky.labeler.service"
    /// The policies the labeler service adheres to.
    public let policies: LabelerPolicies
    /// An array of labels the labeler uses. Optional.
    public let labels: [SelfLabels]?
    /// The date and time the labeler service was created.
    @DateFormatting public var createdAt: Date

    public init(policies: LabelerPolicies, labels: [SelfLabels], createdAt: Date) {
        self.policies = policies
        self.labels = labels
        self._createdAt = DateFormatting(wrappedValue: createdAt)
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.policies = try container.decode(LabelerPolicies.self, forKey: .policies)
        self.labels = try container.decode([SelfLabels].self, forKey: .labels)
        self.createdAt = try container.decode(DateFormatting.self, forKey: .createdAt).wrappedValue
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.type, forKey: .type)
        try container.encode(self.policies, forKey: .policies)
        try container.encode(self.labels, forKey: .labels)
        try container.encode(self._createdAt, forKey: .createdAt)
    }

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case policies
        case labels
        case createdAt
    }
}
