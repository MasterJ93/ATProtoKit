//
//  ComAtprotoServerConfirmEmail.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ComAtprotoLexicon.Server {

    /// A request body model for confirming emails.
    ///
    /// - Note: According to the AT Protocol specifications: "Confirm an email using a token
    /// from com.atproto.server.requestEmailConfirmation."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.confirmEmail`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/confirmEmail.json
    public struct ConfirmEmailRequestBody: Sendable, Codable {

        /// The email of the user.
        public let email: String

        /// The token given to the user via email.
        public let token: String
        
        public init(email: String, token: String) {
            self.email = email
            self.token = token
        }
        
        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.email = try container.decode(String.self, forKey: .email)
            self.token = try container.decode(String.self, forKey: .token)
        }
        
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(self.email, forKey: .email)
            try container.encode(self.token, forKey: .token)
        }
       
        enum CodingKeys: CodingKey {
            case email
            case token
        }
    }
}
