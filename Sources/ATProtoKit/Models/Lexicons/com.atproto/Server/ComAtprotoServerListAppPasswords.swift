//
//  ComAtprotoServerListAppPasswords.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation

extension ComAtprotoLexicon.Server {

    /// A data model definition of the of listing App Passwords.
    ///
    /// - Note: According to the AT Protocol specifications: "List all App Passwords."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.listAppPasswords`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/listAppPasswords.json
    public struct ListAppPasswordsOutput: Codable {

        /// An array of App Passwords.
        public let passwords: [AppPassword]
    }

    /// A data model definition of App Password information.
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.listAppPasswords`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/listAppPasswords.json
    public struct AppPassword: Codable {

        /// The name associated with the App Password.
        public let name: String

        /// The date and date the App Password was created.
        @DateFormatting public var createdAt: Date

        public init(name: String, createdAt: Date) {
            self.name = name
            self._createdAt = DateFormatting(wrappedValue: createdAt)
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.name = try container.decode(String.self, forKey: .name)
            self.createdAt = try container.decode(DateFormatting.self, forKey: .createdAt).wrappedValue
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.name, forKey: .name)
            try container.encode(self._createdAt, forKey: .createdAt)
        }

        enum CodingKeys: CodingKey {
            case name
            case createdAt
        }
    }
}
