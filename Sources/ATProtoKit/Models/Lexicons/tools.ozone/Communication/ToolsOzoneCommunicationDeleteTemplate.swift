//
//  ToolsOzoneCommunicationDeleteTemplate.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation

extension ToolsOzoneLexicon.Communication {

    /// The main data model definition for deleting a communication template as an administrator.
    ///
    /// - Note: According to the AT Protocol specifications: "Delete a communication template."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.communication.deleteTemplate`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/communication/deleteTemplate.json
    public struct DeleteTemplateRequestBody: Codable {

        /// The ID of the communication template.
        public let id: String
    }
}
