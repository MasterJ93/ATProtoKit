//
//  SessionProtocol.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-05.
//

import Foundation

/// Defines the basic requirements for a user session within the AT Protocol.
public protocol SessionProtocol: Codable {

    /// The handle of the user's account.
    var handle: String { get }

    /// The decentralized identifier (DID) of the user's account, serving as a persistent and
    /// long-term account identifier according to the W3C standard.
    ///
    /// - Note: In `CodingKeys` be sure to conform it to `String` and set the value of this
    /// property as "did."
    var sessionDID: String { get }

    /// The email of the user's account. Optional.
    var email: String? { get }

    /// Indicates whether the user confirmed their email. Optional.
    ///
    /// - Note: In `CodingKeys` be sure to conform it to `String` and set the value of this
    /// property as "emailConfirmed."
    var isEmailConfirmed: Bool? { get }

    /// Indicates whether Two-Factor Authentication (via email) is enabled. Optional.
    ///
    /// - Note: In `CodingKeys` be sure to conform it to `String` and set the value of this
    /// property as "emailAuthFactor."
    var isEmailAuthenticationFactorEnabled: Bool? { get }

    /// The DID document associated with the user, which contains AT Protocol-specific
    /// information. Optional.
    ///
    /// - Note: In `CodingKeys` be sure to conform it to `String` and set the value of this
    /// property as "didDoc."
    var didDocument: DIDDocument? { get }

    /// Indicates whether the user account is active. Optional.
    ///
    /// - Note: In `CodingKeys` be sure to conform it to `String` and set the value of this
    /// property as "active."
    var isActive: Bool? { get }

    /// Indicates the possible reason for why the user account is inactive. Optional.
    var status: UserAccountStatus? { get }
}
