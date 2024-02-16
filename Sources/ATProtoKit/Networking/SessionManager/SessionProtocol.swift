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
    /// The decentralized identifier (DID) of the user's account, serving as a persistent and long-term account identifier according to the W3C standard.
    var sessionDID: String { get }
    /// The email of the user's account. Optional.
    var email: String? { get }
    /// Indicates whether the user confirmed their email. Optional.
    var isEmailConfirmed: Bool? { get }
    /// The DID document associated with the user, which contains AT Protocol-specific information. Optional.
    var didDocument: DIDDocument? { get }
}
