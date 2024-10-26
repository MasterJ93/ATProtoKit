//
//  SessionResponse.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-05.
//

import Foundation

/// Represents a concrete implementation of `SessionProtocol`, which contains all session-related
/// data returned from a successful session response within the AT Protocol.
public struct SessionResponse: SessionProtocol, Sendable {

    /// The handle of the user's account.
    public var handle: String
    /// The decentralized identifier (DID) of the user's account, serving as a persistent and
    /// long-term account identifier according to the W3C standard.
    public var sessionDID: String

    /// The email of the user's account. Optional.
    public var email: String?

    /// Indicates whether the user confirmed their email. Optional.
    public var isEmailConfirmed: Bool?

    /// Indicates whether Two-Factor Authentication (via email) is enabled. Optional.
    public var isEmailAuthenticationFactorEnabled: Bool?

    /// The DID document associated with the user, which contains AT Protocol-specific
    /// information. Optional.
    public var didDocument: DIDDocument?


    /// Indicates whether the user account is active. Optional.
    public var isActive: Bool?

    /// Indicates the possible reason for why the user account is inactive. Optional.
    public var status: UserAccountStatus?

    enum CodingKeys: String, CodingKey {
        case handle
        case sessionDID = "did"
        case email
        case isEmailConfirmed = "emailConfirmed"
        case didDocument = "didDoc"
        case isActive = "active"
    }
}
