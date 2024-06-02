//
//  ComAtprotoServerListAppPasswords.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation

extension ComAtprotoLexicon.Server {

    /// An output model for listing App Passwords.
    ///
    /// - Note: According to the AT Protocol specifications: "List all App Passwords."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.listAppPasswords`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/listAppPasswords.json
    public struct ListAppPasswordsOutput: Codable {

        /// An array of App Passwords.
        public let passwords: [AppPassword]

        /// An App Password.
        ///
        /// - SeeAlso: This is based on the [`com.atproto.server.listAppPasswords`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/listAppPasswords.json
        public struct AppPassword: Codable {

            /// The name associated with the App Password.
            public let name: String

            /// The date and date the App Password was created.
            @DateFormatting public var createdAt: Date

            /// Indicates whether this App Password can be used to access sensitive content from
            /// the user account.
            public let isPrivileged: Bool?

            public init(name: String, createdAt: Date, isPrivileged: Bool?) {
                self.name = name
                self._createdAt = DateFormatting(wrappedValue: createdAt)
                self.isPrivileged = isPrivileged
            }

            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                self.name = try container.decode(String.self, forKey: .name)
                self.createdAt = try container.decode(DateFormatting.self, forKey: .createdAt).wrappedValue
                self.isPrivileged = try container.decodeIfPresent(Bool.self, forKey: .isPrivileged)
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)

                try container.encode(self.name, forKey: .name)
                try container.encode(self._createdAt, forKey: .createdAt)
                try container.encodeIfPresent(self.isPrivileged, forKey: .isPrivileged)
            }

            enum CodingKeys: String, CodingKey {
                case name
                case createdAt
                case isPrivileged = "privileged"
            }
        }
    }
}
