//
//  ComAtprotoServerDefs.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation

extension ComAtprotoLexicon.Server {

    /// A definition model for a server invite code.
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/defs.json
    public struct InviteCodeDefinition: Codable {

        /// The actual invite code.
        public let code: String

        /// The number of codes available.
        public let available: Int

        /// Indicates whether the invite code is disabled.
        public let isDisabled: Bool

        /// The user who holds the invite codes.
        public let forAccount: String

        /// The name of the user who currently holds the account.
        public let createdBy: String

        /// The date and time the invite codes were created.
        @DateFormatting public var createdAt: Date

        /// An array of the invite code uses.
        public let uses: [ComAtprotoLexicon.Server.InviteCodeUseDefinition]

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.code, forKey: .code)
            try container.encode(self.available, forKey: .available)
            try container.encode(self.isDisabled, forKey: .isDisabled)
            try container.encode(self.forAccount, forKey: .forAccount)
            try container.encode(self.createdBy, forKey: .createdBy)
            try container.encode(self._createdAt, forKey: .createdAt)
            try container.encode(self.uses, forKey: .uses)
        }

        enum CodingKeys: String, CodingKey {
            case code
            case available
            case isDisabled = "disabled"
            case forAccount
            case createdBy
            case createdAt
            case uses
        }
    }

    /// A definition model for the invite code's use.
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/defs.json
    public struct InviteCodeUseDefinition: Codable {

        /// Who used the invite code.
        public let usedBy: String

        /// The date and time the service code was used.
        @DateFormatting public var usedAt: Date
    }
}
