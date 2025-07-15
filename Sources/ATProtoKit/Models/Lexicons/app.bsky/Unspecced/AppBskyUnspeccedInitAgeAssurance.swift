//
//  AppBskyUnspeccedInitAgeAssurance.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-07-15.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Unspecced {

    /// A request body model for starting the age assurance process for the user account.
    ///
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    ///
    /// - Note: According to the AT Protocol specifications: "Initiate age assurance for an account. This is
    /// a one-time action that will start the process of verifying the user's age."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.initAgeAssurance`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/unspecced/initAgeAssurance.json
    public struct InitAgeAssuranceRequestBody: Sendable, Codable {

        /// The email address used to begin the age assurance process.
        ///
        /// - Note: According to the AT Protocol specifications: "The user's email address to receive
        /// assurance instructions."
        public let email: String

        /// The preferred language of the user account for the age assurance process.
        ///
        /// - Note: According to the AT Protocol specifications: "The user's preferred language for
        /// communication during the assurance process."
        public let language: Locale

        /// The user account's current location during the start of the age assurance process.
        ///
        /// - Note: According to the AT Protocol specifications: "An ISO 3166-1 alpha-2 code of the
        /// user's location."
        public let countryCode: Locale
    }
}
