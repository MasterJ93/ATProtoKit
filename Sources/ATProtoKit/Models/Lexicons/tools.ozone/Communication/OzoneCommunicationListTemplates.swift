//
//  OzoneCommunicationListTemplates.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-01.
//

import Foundation

/// The output definition for retrieves a list of communication templates.
///
/// - Note: According to the AT Protocol specifications: "Get list of all communication templates."
///
/// - SeeAlso: This is based on the [`tools.ozone.communication.listTemplates`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/communication/listTemplates.json
public struct CommunicationListTemplatesOutput: Codable {
    /// An array of communication templates.
    public let communicationTemplates: [OzoneCommunicationTemplateView]
}
