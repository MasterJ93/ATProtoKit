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

        /// The set of report reason codes that this service is authorized to review and take
        /// action on.
        ///
        /// - Note: According to the AT Protocol specifications: "The set of report reason 'codes'
        /// which are in-scope for this service to review and action. These usually align to
        /// policy categories. If not defined (distinct from empty array), all reason types
        /// are allowed."
        public let reasonTypes: ComAtprotoLexicon.Moderation.ReasonTypeDefinition?

        /// The types of subjects this service accepts reports on.
        ///
        /// - Note: According to the AT Protocol specifications: "The set of subject types
        /// (account, record, etc) this service accepts reports on."
        public let subjectTypes: ComAtprotoLexicon.Moderation.SubjectTypeDefinition?

        /// An array of Namespaced Identifiers (NSIDs) for records that can be reported to
        /// this service.
        ///
        /// - Note: According to the AT Protocol specifications: "Set of record types
        /// (collection NSIDs) which can be reported to this service. If not defined
        /// (distinct from empty array), default is any record type."
        public let subjectCollections: [String]?

        public init(policies: LabelerPolicies, labels: [ComAtprotoLexicon.Label.SelfLabelDefinition], createdAt: Date,
                    reasonTypes: ComAtprotoLexicon.Moderation.ReasonTypeDefinition?, subjectTypes: ComAtprotoLexicon.Moderation.SubjectTypeDefinition?,
                    subjectCollections: [String]?) {
            self.policies = policies
            self.labels = labels
            self.createdAt = createdAt
            self.reasonTypes = reasonTypes
            self.subjectTypes = subjectTypes
            self.subjectCollections = subjectCollections
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.policies = try container.decode(LabelerPolicies.self, forKey: .policies)
            self.labels = try container.decode([ComAtprotoLexicon.Label.SelfLabelDefinition].self, forKey: .labels)
            self.createdAt = try container.decodeDate(forKey: .createdAt)
            self.reasonTypes = try container.decodeIfPresent(ComAtprotoLexicon.Moderation.ReasonTypeDefinition.self, forKey: .reasonTypes)
            self.subjectTypes = try container.decodeIfPresent(ComAtprotoLexicon.Moderation.SubjectTypeDefinition.self, forKey: .subjectTypes)
            self.subjectCollections = try container.decodeIfPresent([String].self, forKey: .subjectCollections)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.policies, forKey: .policies)
            try container.encode(self.labels, forKey: .labels)
            try container.encodeDate(self.createdAt, forKey: .createdAt)
            try container.encodeIfPresent(self.reasonTypes, forKey: .reasonTypes)
            try container.encodeIfPresent(self.subjectTypes, forKey: .subjectTypes)
            try container.encodeIfPresent(self.subjectCollections, forKey: .subjectCollections)
        }

        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case policies
            case labels
            case createdAt
            case reasonTypes
            case subjectTypes
            case subjectCollections
        }
    }
}
