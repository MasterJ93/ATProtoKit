//
//  AppBskyContactVerifyPhone.swift
//  ATProtoKit
//
//  Created by KC-2001MS on 2026-08-02.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Contact {

    /// A request body model for verifying a phone number.
    ///
    /// - Note: According to the AT Protocol specifications: "Verifies control over a phone number
    /// with a code received via SMS and starts a contact import session.
    /// Requires authentication."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.contact.verifyPhone`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/contact/verifyPhone.json
    public struct VerifyPhoneRequestBody: Sendable, Codable {

        /// The phone number to verify.
        ///
        /// - Note: According to the AT Protocol specifications: "Should be the same as the one
        /// passed to `app.bsky.contact.startPhoneVerification`."
        public let phone: String

        /// The code received via SMS from `app.bsky.contact.startPhoneVerification`.
        public let code: String

        public init(phone: String, code: String) {
            self.phone = phone
            self.code = code
        }
    }

    /// An output model for verifying a phone number.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.contact.verifyPhone`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/contact/verifyPhone.json
    public struct VerifyPhoneOutput: Sendable, Codable {

        /// A JWT to be used in a call to `app.bsky.contact.importContacts`.
        ///
        /// - Note: According to the AT Protocol specifications: "It is only valid for a
        /// single call."
        public let token: String
    }
}
