//
//  AtprotoAdminListCommunicationTemplates.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-01.
//

import Foundation

/// The main data model definition for listing the communication templates.
///
/// - Note: According to the AT Protocol specifications: "Get list of all communication templates."
///
/// - SeeAlso: This is based on the [`com.atproto.admin.listCommunicationTemplates`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/listCommunicationTemplates.json
public struct AdminListCommunicationTemplatesOutput: Codable {
    /// An array of communication templates.
    public let communicationTemplates: [OzoneCommunicationTemplateView]
}
