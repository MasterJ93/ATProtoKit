//
//  ComAtprotoServerUpdateEmail.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ComAtprotoLexicon.Server {

    /// A request body model for updating the user's email address.
    ///
    /// - Note: According to the AT Protocol specifications: "Update an account's email."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.updateEmail`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/updateEmail.json
    public struct UpdateEmailRequestBody: Sendable, Codable {

        /// The email associated with the user's account.
        public let email: String

        /// Indicates whether Two-Factor Authentication (via email) is enabled. Optional.
        public let isEmailAuthenticationFactorEnabled: Bool?

        /// The token that's used if the email has been confirmed. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Requires a token from com.atproto.sever.requestEmailUpdate if the account's email has
        /// been confirmed."
        public let resetToken: String?

        public init(email: String, isEmailAuthenticationFactorEnabled: Bool?, resetToken: String?) {
            self.email = email
            self.isEmailAuthenticationFactorEnabled = isEmailAuthenticationFactorEnabled
            self.resetToken = resetToken
        }
        
        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.email = try container.decode(String.self, forKey: .email)
            self.isEmailAuthenticationFactorEnabled = try container.decodeIfPresent(Bool.self, forKey: .isEmailAuthenticationFactorEnabled)
            self.resetToken = try container.decodeIfPresent(String.self, forKey: .resetToken)
        }
        
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(self.email, forKey: .email)
            try container.encodeIfPresent(self.isEmailAuthenticationFactorEnabled, forKey: .isEmailAuthenticationFactorEnabled)
            try container.encodeIfPresent(self.resetToken, forKey: .resetToken)
        }
        
        public enum CodingKeys: String, CodingKey {
            case email
            case isEmailAuthenticationFactorEnabled = "emailAuthFactor"
            case resetToken = "token"
        }
    }
}
