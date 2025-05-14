//
//  AppBskyGraphVerification.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-05-14.
//

import Foundation

extension AppBskyLexicon.Graph {

    /// A record model for a verification record.
    ///
    /// - Note: According to the AT Protocol specifications: "Record declaring a verification relationship
    /// between two accounts. Verifications are only considered valid by an app if issued by an account the
    /// app considers trusted."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.graph.verification`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/verification.json
    public struct VerificationRecord: Sendable, Codable {

        /// The decentralized identifier (DID) of the user account being verified.
        ///
        /// - Note: According to the AT Protocol specifications: "DID of the subject the verification
        /// applies to."
        public let subject: String

        /// The handle of the user account being verified.
        ///
        /// - Note: According to the AT Protocol specifications: "Handle of the subject the verification
        /// applies to at the moment of verifying, which might not be the same at the time of viewing.
        /// The verification is only valid if the current handle matches the one at the time of verifying."
        public let handle: String

        /// The display name of the user account being verified.
        ///
        /// - Note: According to the AT Protocol specifications: "Display name of the subject the
        /// verification applies to at the moment of verifying, which might not be the same at the time
        /// of viewing. The verification is only valid if the current displayName matches the one at the
        /// time of verifying."
        public let displayName: String

        /// The date and time of when the user account was verified.
        ///
        /// - Note: According to the AT Protocol specifications: "Date of when the verification
        /// was created."
        public let createdAt: Date
    }
}
