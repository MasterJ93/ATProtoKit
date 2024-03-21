//
//  AtprotoTempRequestPhoneVerification.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-17.
//

import Foundation

/// The main data model definition for requesting a text code from a phone number.
///
/// - Important: The lexicon associated with this model may be removed at any time. This may not work.
///
/// - Note: According to the AT Protocol specifications: "Request a verification code to be sent to the supplied phone number."
///
/// - SeeAlso: This is based on the [`com.atproto.temp.requestPhoneVerification`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/temp/requestPhoneVerification.json
public struct TempRequestPhoneVerification: Codable {
    /// The user's mobile phone number.
    public let phoneNumber: String
}
