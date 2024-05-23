//
//  ComAtprotoModerationCreateReport.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation

extension ComAtprotoLexicon.Moderation {

    /// A request body model for creating a report.
    ///
    /// - Note: According to the AT Protocol specifications: "Submit a moderation report regarding
    /// an atproto account or record. Implemented by moderation services (with PDS proxying), and
    /// requires auth."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.moderation.createReport`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/moderation/createReport.json
    public struct CreateReportRequestBody: Codable {

        /// The reason for the report.
        ///
        /// - Note: According to the AT Protocol specifications: "Indicates the broad category of
        /// violation the report is for."
        public let reasonType: ModerationReasonType

        /// Any clarifying comments accompanying the report. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Additional context about the
        /// content and violation."
        public let reason: String?

        /// The subject reference.
        ///
        /// - Important: The item associated with this property is undocumented in the AT Protocol specifications. The documentation here is based on:\
        ///   \* **For items with some inferable context from property names or references**: its best interpretation, though not with full certainty.\
        ///   \* **For items without enough context for even an educated guess**: a direct acknowledgment of their undocumented status.\
        ///   \
        ///   Clarifications from Bluesky are needed in order to fully understand this item.
        public let subject: RepositoryReferencesUnion
    }

    /// An output model for creating a report.
    ///
    /// - SeeAlso: This is based on the [`com.atproto.moderation.createReport`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/moderation/createReport.json
    public struct CreateReportOutput: Codable {

        /// The ID of the report.
        public let id: Int

        /// The reason for the report.
        public let reasonType: ModerationReasonType

        /// The reason for the report. Optional.
        public let reason: String?

        /// The subject reference.
        ///
        /// - Important: The item associated with this property is undocumented in the AT Protocol specifications. The documentation here is based on:\
        ///   \* **For items with some inferable context from property names or references**: its best interpretation, though not with full certainty.\
        ///   \* **For items without enough context for even an educated guess**: a direct acknowledgment of their undocumented status.\
        ///   \
        ///   Clarifications from Bluesky are needed in order to fully understand this item.
        public let subject: RepositoryReferencesUnion

        /// The decentralized identifier (DID) of the user who created the report.
        public let reportedBy: String

        /// The date and time the report was created.
        @DateFormatting public var createdAt: Date

        public init(id: Int, reasonType: ModerationReasonType, reason: String?, subject: RepositoryReferencesUnion, reportedBy: String, createdAt: Date) {
            self.id = id
            self.reasonType = reasonType
            self.reason = reason
            self.subject = subject
            self.reportedBy = reportedBy
            self._createdAt = DateFormatting(wrappedValue: createdAt)
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.id = try container.decode(Int.self, forKey: .id)
            self.reasonType = try container.decode(ModerationReasonType.self, forKey: .reasonType)
            self.reason = try container.decodeIfPresent(String.self, forKey: .reason)
            self.subject = try container.decode(RepositoryReferencesUnion.self, forKey: .subject)
            self.reportedBy = try container.decode(String.self, forKey: .reportedBy)
            self.createdAt = try container.decode(DateFormatting.self, forKey: .createdAt).wrappedValue
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.id, forKey: .id)
            try container.encode(self.reasonType, forKey: .reasonType)

            // Truncate `reason` to 20,000 characters before encoding
            // `maxGraphemes`'s limit is 2,000, but `String.count` should respect that limit implictly
            try truncatedEncodeIfPresent(self.reason, withContainer: &container, forKey: .reason, upToLength: 20_000)
            try container.encode(self.subject, forKey: .subject)
            try container.encode(self.reportedBy, forKey: .reportedBy)
            try container.encode(self._createdAt, forKey: .createdAt)
        }

        public enum CodingKeys: CodingKey {
            case id
            case reasonType
            case reason
            case subject
            case reportedBy
            case createdAt
        }
    }
}
