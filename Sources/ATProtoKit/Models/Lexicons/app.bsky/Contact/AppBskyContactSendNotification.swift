//
//  AppBskyContactSendNotification.swift
//  ATProtoKit
//
//  Created by KC-2001MS on 2026-08-02.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Contact {

    /// A request body model for sending a contact import notification.
    ///
    /// - Note: According to the AT Protocol specifications: "System endpoint to send notifications
    /// related to contact imports. Requires role authentication."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.contact.sendNotification`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/contact/sendNotification.json
    public struct SendNotificationRequestBody: Sendable, Codable {

        /// The decentralized identifier (DID) of the sender.
        public let fromDID: String

        /// The decentralized identifier (DID) of the recipient.
        public let toDID: String

        public init(fromDID: String, toDID: String) {
            self.fromDID = fromDID
            self.toDID = toDID
        }

        enum CodingKeys: String, CodingKey {
            case fromDID = "from"
            case toDID = "to"
        }
    }
}
