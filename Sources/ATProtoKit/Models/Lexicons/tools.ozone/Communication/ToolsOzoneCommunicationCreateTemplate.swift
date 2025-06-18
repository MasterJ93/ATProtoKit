//
//  ToolsOzoneCommunicationCreateTemplate.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ToolsOzoneLexicon.Communication {

    /// A request body model for creating a communication template.
    ///
    /// - Note: According to the AT Protocol specifications: "Administrative action to create a
    /// new, re-usable communication (email for now) template."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.communication.createTemplate`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/communication/createTemplate.json
    public struct CreateTemplateRequestBody: Sendable, Codable {

        /// The name of the template.
        ///
        /// - Note: According to the AT Protocol specifications: "Name of the template."
        public let name: String

        /// A Markdown-formatted content of the communitcation template.
        ///
        /// - Note: According to the AT Protocol specifications: "Content of the template, markdown
        /// supported, can contain variable placeholders."
        public let contentMarkdown: String

        /// The subject line of the communication template.
        ///
        /// - Note: According to the AT Protocol specifications: "Subject of the message, used
        /// in emails."
        public let subject: String

        /// The language of the message.
        ///
        /// - Note: According to the AT Protocol specifications: "Message language."
        public let language: Locale?

        /// The decentralized identifier (DID) of the creator of the
        /// communication template. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "DID of the user who is creating
        /// the template."
        public let createdBy: String?

        public init(name: String, contentMarkdown: String, subject: String, language: Locale?, createdBy: String?) {
            self.name = name
            self.contentMarkdown = contentMarkdown
            self.subject = subject
            self.language = language
            self.createdBy = createdBy
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.name = try container.decode(String.self, forKey: .name)
            self.contentMarkdown = try container.decode(String.self, forKey: .contentMarkdown)
            self.subject = try container.decode(String.self, forKey: .subject)
            self.language = try container.decodeLocaleIfPresent(forKey: .language)
            self.createdBy = try container.decodeIfPresent(String.self, forKey: .createdBy)
        }

        enum CodingKeys: String, CodingKey {
            case name
            case contentMarkdown
            case subject
            case language = "lang"
            case createdBy
        }
    }
}
