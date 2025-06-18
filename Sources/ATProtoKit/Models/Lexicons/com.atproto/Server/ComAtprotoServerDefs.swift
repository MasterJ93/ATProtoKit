//
//  ComAtprotoServerDefs.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ComAtprotoLexicon.Server {

    /// A definition model for a server invite code.
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/defs.json
    public struct InviteCodeDefinition: Sendable, Codable {

        /// The actual invite code.
        public let code: String

        /// The number of codes available.
        public let availableCodes: Int

        /// Indicates whether the invite code is disabled.
        public let isDisabled: Bool

        /// The user who holds the invite codes.
        public let forAccount: String

        /// The name of the user who currently holds the account.
        public let createdBy: String

        /// The date and time the invite codes were created.
        public let createdAt: Date

        /// An array of the invite code uses.
        public let uses: [ComAtprotoLexicon.Server.InviteCodeUseDefinition]

        public init(code: String, availableCodes: Int, isDisabled: Bool, forAccount: String, createdBy: String, createdAt: Date,
                    uses: [ComAtprotoLexicon.Server.InviteCodeUseDefinition]) {
            self.code = code
            self.availableCodes = availableCodes
            self.isDisabled = isDisabled
            self.forAccount = forAccount
            self.createdBy = createdBy
            self.createdAt = createdAt
            self.uses = uses
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.code = try container.decode(String.self, forKey: .code)
            self.availableCodes = try container.decode(Int.self, forKey: .availableCodes)
            self.isDisabled = try container.decode(Bool.self, forKey: .isDisabled)
            self.forAccount = try container.decode(String.self, forKey: .forAccount)
            self.createdBy = try container.decode(String.self, forKey: .createdBy)
            self.createdAt = try container.decodeDate(forKey: .createdAt)
            self.uses = try container.decode([ComAtprotoLexicon.Server.InviteCodeUseDefinition].self, forKey: .uses)
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.code, forKey: .code)
            try container.encode(self.availableCodes, forKey: .availableCodes)
            try container.encode(self.isDisabled, forKey: .isDisabled)
            try container.encode(self.forAccount, forKey: .forAccount)
            try container.encode(self.createdBy, forKey: .createdBy)
            try container.encodeDate(self.createdAt, forKey: .createdAt)
            try container.encode(self.uses, forKey: .uses)
        }

        enum CodingKeys: String, CodingKey {
            case code
            case availableCodes = "available"
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
    public struct InviteCodeUseDefinition: Sendable, Codable {

        /// Who used the invite code.
        public let usedBy: String

        /// The date and time the service code was used.
        public let usedAt: Date

        public init(usedBy: String, usedAt: Date) {
            self.usedBy = usedBy
            self.usedAt = usedAt
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.usedBy = try container.decode(String.self, forKey: .usedBy)
            self.usedAt = try container.decodeDate(forKey: .usedAt)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.usedBy, forKey: .usedBy)
            try container.encodeDate(self.usedAt, forKey: .usedAt)
        }

        enum CodingKeys: CodingKey {
            case usedBy
            case usedAt
        }
    }
}
