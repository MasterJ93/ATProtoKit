//
//  AppBskyContactStartPhoneVerification.swift
//  ATProtoKit
//
//  Created by KC-2001MS on 2026-08-02.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Contact {

    /// A request body model for starting a phone verification flow.
    ///
    /// - Note: According to the AT Protocol specifications: "Starts a phone verification flow.
    /// The phone passed will receive a code via SMS that should be passed to
    /// `app.bsky.contact.verifyPhone`. Requires authentication."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.contact.startPhoneVerification`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/contact/startPhoneVerification.json
    public struct StartPhoneVerificationRequestBody: Sendable, Codable {

        /// The phone number to receive the SMS verification code.
        public let phone: String

        public init(phone: String) {
            self.phone = phone
        }
    }
}
