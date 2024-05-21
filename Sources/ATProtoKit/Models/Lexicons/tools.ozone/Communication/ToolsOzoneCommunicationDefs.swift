//
//  ToolsOzoneCommunicationDefs.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation

extension ToolsOzoneLexicon.Communication {

    /// A data model definition for a communication template.
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.communication.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/communication/defs.json
    public struct TemplateViewDefinition: Codable {

        /// The ID of the communication template.
        public let id: Int

        /// The name of the communication template.
        ///
        /// - Note: According to the AT Protocol specifications: "Name of the template."
        public let name: String

        /// The subject of the message. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Subject of the message, used
        /// in emails."
        public var subject: String?

        /// The content of the communication template. Optional.
        ///
        /// This may contain Markdown placeholders and variable placeholders.
        ///
        /// - Note: According to the AT Protocol specifications: "Content of the template, can
        /// contain markdown and variable placeholders."
        public let contentMarkdown: String

        /// Indicates whether the communication template has been disabled.
        public let isDisabled: Bool

        /// The decentralized identifier (DID) of the user who last updated the
        /// communication template.
        ///
        /// - Note: According to the AT Protocol specifications: "DID of the user who last updated
        /// the template."
        public let lastUpdatedBy: String

        /// The date and time the communication template was created.
        @DateFormatting public var createdAt: Date

        /// The date and time the communication template was updated.
        @DateFormatting public var updatedAt: Date

        public init(id: Int, name: String, subject: String? = nil, contentMarkdown: String, isDisabled: Bool, lastUpdatedBy: String,
                    createdAt: Date, updatedAt: Date) {
            self.id = id
            self.name = name
            self.subject = subject
            self.contentMarkdown = contentMarkdown
            self.isDisabled = isDisabled
            self.lastUpdatedBy = lastUpdatedBy
            self._createdAt = DateFormatting(wrappedValue: createdAt)
            self._updatedAt = DateFormatting(wrappedValue: updatedAt)
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.id = try container.decode(Int.self, forKey: .id)
            self.name = try container.decode(String.self, forKey: .name)
            self.subject = try container.decodeIfPresent(String.self, forKey: .subject)
            self.contentMarkdown = try container.decode(String.self, forKey: .contentMarkdown)
            self.isDisabled = try container.decode(Bool.self, forKey: .isDisabled)
            self.lastUpdatedBy = try container.decode(String.self, forKey: .lastUpdatedBy)
            self.createdAt = try container.decode(DateFormatting.self, forKey: .createdAt).wrappedValue
            self.updatedAt = try container.decode(DateFormatting.self, forKey: .updatedAt).wrappedValue
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.id, forKey: .id)
            try container.encode(self.name, forKey: .name)
            try container.encodeIfPresent(self.subject, forKey: .subject)
            try container.encode(self.contentMarkdown, forKey: .contentMarkdown)
            try container.encode(self.isDisabled, forKey: .isDisabled)
            try container.encode(self.lastUpdatedBy, forKey: .lastUpdatedBy)
            try container.encode(self._createdAt, forKey: .createdAt)
            try container.encode(self._updatedAt, forKey: .updatedAt)
        }

        enum CodingKeys: String, CodingKey {
            case id
            case name
            case subject
            case contentMarkdown
            case isDisabled = "disabled"
            case lastUpdatedBy
            case createdAt
            case updatedAt
        }
    }
}
