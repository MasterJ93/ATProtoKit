//
//  ComAtprotoServerCreateAppPassword.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation

extension ComAtprotoLexicon.Server {

    /// A request body model for creating an App Password.
    ///
    /// - Note: According to the AT Protocol specifications: "Create an App Password."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.createAppPassword`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/createAppPassword.json
    public struct CreateAppPasswordRequestBody: Sendable, Codable {

        /// The name given to the App Password to help distingush it from others.
        ///
        /// - Note: According to the AT Protocol specifications: "A short name for the
        /// App Password, to help distinguish them."
        public let name: String

        /// Indicates whether this App Password can be used to access sensitive content from
        /// the user account.
        ///
        /// - Note: According to the AT Protocol specifications: "If an app password has
        /// 'privileged' access to possibly sensitive account state. Meant for use with
        /// trusted clients."
        public let isPrivileged: Bool?

        enum CodingKeys: String, CodingKey {
            case name
            case isPrivileged = "privileged"
        }
    }

    /// An output model for creating an App Password.
    ///
    /// - Note: According to the AT Protocol specifications: "Create an App Password."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.createAppPassword`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/createAppPassword.json
    public struct CreateAppPasswordOutput: Sendable, Codable {

        /// The name given to the App Password to help distingush it from others.
        ///
        /// - Note: According to the AT Protocol specifications: "A short name for the
        /// App Password, to help distinguish them."
        public let name: String

        /// The password itself.
        public let password: String

        /// The date and time the App Password was created.
        public let createdAt: Date

        /// Indicates whether the App Password is privileged. Optional.
        public let isPrivileged: Bool?

        public init(name: String, password: String, createdAt: Date, isPrivileged: Bool?) {
            self.name = name
            self.password = password
            self.createdAt = createdAt
            self.isPrivileged = isPrivileged
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.name = try container.decode(String.self, forKey: .name)
            self.password = try container.decode(String.self, forKey: .password)
            self.createdAt = try container.decodeDate(forKey: .createdAt)
            self.isPrivileged = try container.decodeIfPresent(Bool.self, forKey: .isPrivileged)
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.name, forKey: .name)
            try container.encode(self.password, forKey: .password)
            try container.encodeDate(self.createdAt, forKey: .createdAt)
            try container.encodeIfPresent(self.isPrivileged, forKey: .isPrivileged)
        }

        enum CodingKeys: String, CodingKey {
            case name
            case password
            case createdAt
            case isPrivileged = "privileged"
        }
    }
}
