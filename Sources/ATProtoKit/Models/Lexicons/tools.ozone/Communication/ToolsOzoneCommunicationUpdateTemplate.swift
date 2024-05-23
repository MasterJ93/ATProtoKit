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
    public struct UpdateTemplateRequestBody: Codable {

        /// The ID of the communication template.
        public let id: String

        /// The name of the communication template. Optional.
        public let name: String?

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

        enum CodingKeys: String, CodingKey {
            case id
            case name
            case contentMarkdown
            case subject
            case updatedBy
            case isDisabled = "disabled"
        }
    }
}
