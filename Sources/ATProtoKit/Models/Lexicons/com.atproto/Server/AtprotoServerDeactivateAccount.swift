//
//  AtprotoServerDeactivateAccount.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-24.
//

import Foundation

/// The main data model definition for deactivating an account.
///
/// - Note: According to the AT Protocol specifications: "Deactivates a currently active account. Stops serving of repo, and future writes to repo until reactivated. Used to finalize account migration with the old host
/// after the account has been activated on the new host."
///
/// - SeeAlso: This is based on the [`com.atproto.server.deactivateAccount`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/deactivateAccount.json
public struct ServerDeactivateAccount: Codable {
    /// The date and time of when the server should delete the account.
    ///
    /// - Note: According to the AT Protocol specifications: "A recommendation to server as to how long they should hold onto the deactivated account before deleting."
    @DateFormatting public var deleteAfter: Date

    public init(deleteAfter: Date) {
        self._deleteAfter = DateFormatting(wrappedValue: deleteAfter)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.deleteAfter = try container.decode(DateFormatting.self, forKey: .deleteAfter).wrappedValue
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.deleteAfter, forKey: .deleteAfter)
    }

    enum CodingKeys: CodingKey {
        case deleteAfter
    }
}
