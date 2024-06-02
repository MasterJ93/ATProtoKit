//
//  ToolsOzoneCommunicationCreateTemplate.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation

extension ToolsOzoneLexicon.Communication {

    /// A request body model for creating a communication template.
    ///
    /// - Note: According to the AT Protocol specifications: "Administrative action to create a
    /// new, re-usable communication (email for now) template."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.communication.createTemplate`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/communication/createTemplate.json
    public struct CreateTemplateRequestBody: Codable {

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

        /// The decentralized identifier (DID) of the creator of the
        /// communication template. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "DID of the user who is creating
        /// the template."
        public let createdBy: String?
    }
}
