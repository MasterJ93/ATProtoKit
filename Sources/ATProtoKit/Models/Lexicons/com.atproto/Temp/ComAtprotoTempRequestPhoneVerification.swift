//
//  ComAtprotoTempRequestPhoneVerification.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation

extension ComAtprotoLexicon.Temp {

    /// A request body model for requesting a text code from a phone number.
    ///
    /// - Important: The lexicon associated with this model may be removed at any time. This may
    /// not work.
    ///
    /// - Note: According to the AT Protocol specifications: "Request a verification code to be
    /// sent to the supplied phone number."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.temp.requestPhoneVerification`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/temp/requestPhoneVerification.json
    public struct RequestPhoneVerificationRequestBody: Sendable, Codable {

        /// The user's mobile phone number.
        public let phoneNumber: String
    }
}
