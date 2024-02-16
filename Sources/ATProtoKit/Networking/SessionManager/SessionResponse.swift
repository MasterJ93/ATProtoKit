//
//  SessionResponse.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-05.
//

import Foundation

/// Represents a concrete implementation of `SessionProtocol`, which contains all session-related data returned from a successful
/// session response within the AT Protocol.
public struct SessionResponse: SessionProtocol {
    /// The handle of the user's account.
    public var handle: String
    /// The decentralized identifier (DID) of the user's account, serving as a persistent and long-term account identifier according to
    /// the W3C standard.
    public var sessionDID: String
    /// The email of the user's account. Optional.
    public var email: String?
    /// Indicates whether the user confirmed their email. Optional.
    public var isEmailConfirmed: Bool?
    /// The DID document associated with the user, which contains AT Protocol-specific information. Optional.
    public var didDocument: DIDDocument?

    enum CodingKeys: String, CodingKey {
        case handle
        case sessionDID = "did"
        case email
        case isEmailConfirmed = "emailConfirmed"
        case didDocument = "didDoc"
    }
}
