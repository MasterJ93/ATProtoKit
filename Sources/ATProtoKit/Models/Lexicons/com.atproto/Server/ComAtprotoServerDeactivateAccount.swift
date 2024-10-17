//
//  ComAtprotoServerDeactivateAccount.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation

extension ComAtprotoLexicon.Server {

    /// A request body model for deactivating an account.
    ///
    /// - Note: According to the AT Protocol specifications: "Deactivates a currently
    /// active account. Stops serving of repo, and future writes to repo until reactivated.
    /// Used to finalize account migration with the old host after the account has been
    /// activated on the new host."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.deactivateAccount`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/deactivateAccount.json
    public struct DeactivateAccountRequestBody: Codable {

        /// The date and time of when the server should delete the account.
        ///
        /// - Note: According to the AT Protocol specifications: "A recommendation to server as
        /// to how long they should hold onto the deactivated account before deleting."
        @DateFormatting public var deleteAfter: Date

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.deleteAfter, forKey: .deleteAfter)
        }

        enum CodingKeys: CodingKey {
            case deleteAfter
        }
    }
}
