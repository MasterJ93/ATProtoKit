//
//  AtprotoAdminGetAccountInfos.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-29.
//

import Foundation

/// A data model definition for the output of retrieving an array of user accounts.
///
/// - Note: According to the AT Protocol specifications: "Get details about some accounts."
///
/// - SeeAlso: This is based on the [`com.atproto.admin.getAccountInfos`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/getAccountInfos.json
public struct AdminGetAccountInfosOutput: Codable {
    /// An array of user account information.
    public let infos: [AdminAccountView]
}
