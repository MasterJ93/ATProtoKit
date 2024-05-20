//
//  ComAtprotoAdminSendEmail.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation

extension ComAtprotoLexicon.Admin {

    /// The main data model definition for sending an email to a user.
    ///
    /// - Note: According to the AT Protocol specifications: "Send email to a user's account
    /// email address."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.admin.sendEmail`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/sendEmail.json
    public struct SendEmailRequestBody: Codable {

        /// The decentralized identifier (DID) of the recipient.
        public let recipientDID: String

        /// The content of the email.
        public let content: String

        /// The subject line of the email. Optional.
        public let subject: String?

        /// The decentralized identifier (DID) of the sender.
        public let senderDID: String

        /// Any additional comments viewable to other moderators and administrators.
        public let comment: String?

        enum CodingKeys: String, CodingKey {
            case recipientDID = "recipientDid"
            case content
            case subject
            case senderDID = "senderDid"
            case comment
        }
    }

    /// A data model definition for the output of sending an email to a user.
    ///
    /// - Note: According to the AT Protocol specifications: "Send email to a user's account
    /// email address."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.admin.sendEmail`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/sendEmail.json
    public struct SendEmailOutput: Codable {

        /// Indicates whether the email has been sent.
        public let isSent: Bool

        enum CodingKeys: String, CodingKey {
            case isSent = "sent"
        }
    }
}
