//
//  ToolsOzoneCommunicationUpdateTemplate.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation

extension ToolsOzoneLexicon.Communication {

    /// A request body model for updating a communication template.
    ///
    /// - Note: According to the AT Protocol specifications: "Administrative action to update an
    /// existing communication template. Allows passing partial fields to patch specific
    /// fields only."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.communication.updateTemplate`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/communication/updateTemplate.json
    public struct UpdateTemplateRequestBody: Sendable, Codable {

        /// The ID of the communication template.
        public let id: String

        /// The name of the communication template. Optional.
        public let name: String?

        /// The language of the message.
        ///
        /// - Note: According to the AT Protocol specifications: "Message language."
        public let language: Locale?

        /// The content of the communication template. Optional.
        ///
        /// This may contain Markdown placeholders and variable placeholders.
        public let contentMarkdown: String?

        /// The subject line of the message itself. Optional.
        public let subject: String?

        /// The decentralized identifier (DID) of the user who updated the
        /// communication template. Optional.
        public let updatedBy: String?

        /// Indicates whether the communication template is disabled. Optional.
        public let isDisabled: Bool?

        public init(id: String, name: String?, language: Locale?, contentMarkdown: String?, subject: String?, updatedBy: String?, isDisabled: Bool?) {
            self.id = id
            self.name = name
            self.language = language
            self.contentMarkdown = contentMarkdown
            self.subject = subject
            self.updatedBy = updatedBy
            self.isDisabled = isDisabled
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.id = try container.decode(String.self, forKey: .id)
            self.name = try container.decodeIfPresent(String.self, forKey: .name)
            self.language = try container.decodeLocaleIfPresent(forKey: .language)
            self.contentMarkdown = try container.decodeIfPresent(String.self, forKey: .contentMarkdown)
            self.subject = try container.decodeIfPresent(String.self, forKey: .subject)
            self.updatedBy = try container.decodeIfPresent(String.self, forKey: .updatedBy)
            self.isDisabled = try container.decodeIfPresent(Bool.self, forKey: .isDisabled)
        }

        enum CodingKeys: String, CodingKey {
            case id
            case name
            case language = "lang"
            case contentMarkdown
            case subject
            case updatedBy
            case isDisabled = "disabled"
        }
    }
}
