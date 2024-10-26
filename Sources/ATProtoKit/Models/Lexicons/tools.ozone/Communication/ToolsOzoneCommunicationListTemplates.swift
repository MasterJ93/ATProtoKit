//
//  ToolsOzoneCommunicationListTemplates.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation

extension ToolsOzoneLexicon.Communication {

    /// An output model for retrieves a list of communication templates.
    ///
    /// - Note: According to the AT Protocol specifications: "Get list of all
    /// communication templates."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.communication.listTemplates`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/communication/listTemplates.json
    public struct ListTemplatesOutput: Sendable, Codable {

        /// An array of communication templates.
        public let communicationTemplates: [TemplateViewDefinition]
    }
}
