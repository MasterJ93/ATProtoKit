//
//  UserSession.swift
//  
//
//  Created by Christopher Jr Riley on 2024-01-05.
//

import Foundation
import Logging

/// Represents an authenticated user session within the AT Protocol.
///
/// This class encapsulates the details of a user's session, including their
/// decentralized identifier (DID), authentication tokens, and optional user information such
/// as email. It also references the user's DID document, which contains crucial
/// AT Protocol-specific information.
public struct UserSession: SessionProtocol {

    /// The user's handle within the AT Protocol.
    public private(set) var handle: String

    /// The decentralized identifier (DID), serving as a persistent and long-term account
    /// identifier according to the W3C standard.
    public private(set) var sessionDID: String

    /// The user's email address. Optional.
    public private(set) var email: String?

    /// Indicates whether the user's email address has been confirmed. Optional.
    public private(set) var isEmailConfirmed: Bool?

    /// Indicates whether Two-Factor Authentication (via email) is enabled. Optional.
    public private(set) var isEmailAuthenticationFactorEnabled: Bool?

    /// The access token used for API requests that requests authentication.
    public private(set) var accessToken: String

    /// The refresh token used to generate a new access token.
    public private(set) var refreshToken: String

    /// The DID document associated with the user, which contains AT Protocol-specific
    /// information. Optional.
    public private(set) var didDocument: DIDDocument?
    
    /// Indicates whether the user account is active. Optional.
    public var isActive: Bool?

    /// Indicates the possible reason for why the user account is inactive. Optional.
    public var status: UserAccountStatus?


    /// The URL of the Personal Data Server (PDS) associated with the user. Optional.
    ///
    /// - Note: This is not included when initalizing `UserSession`. Instead, it's added
    /// after the successful initalizing.
    public var pdsURL: String?

    /// Specifies the logger that will be used for emitting log messages. Optional.
    public var logger: Logger?

    /// The number of times a request can be attempted before it's considered a failure.
    ///
    /// By default, ATProtoKit will retry a request attempt for 1 second.
    public var maxRetryCount: Int?

    /// The length of time to wait before attempting to retry a request.
    ///
    /// By default, ATProtoKit will wait for 1 second before attempting to retry a request.
    /// ATProtoKit will change the number exponentally in order to help prevent overloading
    /// the server.
    public var retryTimeDelay: TimeInterval?

    /// Initializes a new user session with the specified details.
    public init(handle: String, sessionDID: String, email: String? = nil, isEmailConfirmed: Bool? = nil, isEmailAuthenticationFactorEnabled: Bool?,
                accessToken: String, refreshToken: String, didDocument: DIDDocument? = nil, isActive: Bool?, status: UserAccountStatus?,
                pdsURL: String? = nil, logger: Logger? = nil, maxRetryCount: Int? = 3, retryTimeDelay: TimeInterval? = 1.0) {
        self.handle = handle
        self.sessionDID = sessionDID
        self.email = email
        self.isEmailConfirmed = isEmailConfirmed
        self.isEmailAuthenticationFactorEnabled = isEmailAuthenticationFactorEnabled
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.didDocument = didDocument
        self.isActive = isActive
        self.status = status
        self.pdsURL = pdsURL
        self.logger = logger
        self.maxRetryCount = maxRetryCount
        self.retryTimeDelay = retryTimeDelay
    }

    enum CodingKeys: String, CodingKey {
        case handle
        case sessionDID = "did"
        case email
        case isEmailConfirmed = "emailConfirmed"
        case isEmailAuthenticationFactorEnabled = "emailAuthFactor"
        case accessToken = "accessJwt"
        case refreshToken = "refreshJwt"
        case didDocument = "didDoc"
        case isActive = "active"
        case status
        case pdsURL
    }
}


/// Represents a DID document in the AT Protocol, containing crucial information fo
/// AT Protocol functionality.
///
/// The DID document includes the decentralized identifier (DID), verification methods, and
/// service endpoints necessary for interacting with the AT Protocol ecosystem, such as
/// authentication and data storage locations.
public struct DIDDocument: Codable {

    /// An array of context URLs for the DID document, providing additional semantics for
    /// the properties.
    public var context: [String]

    /// The unique identifier of the DID document.
    public var id: String

    /// An array of URIs under which this decentralized identifier (DID) is also known, including
    /// the primary handle URI. Optional.
    public var alsoKnownAs: [String]?

    /// An array of methods for verifying digital signatures, including the public signing key
    /// for the account.
    public var verificationMethod: [VerificationMethod]

    /// An array of service endpoints related to the decentralized identifier (DID), including the
    /// Personal Data Server's (PDS) location.
    public var service: [ATService]

    enum CodingKeys: String, CodingKey {
        case context = "@context"
        case id
        case alsoKnownAs
        case verificationMethod
        case service
    }
}

/// Describes a method for verifying digital signatures in the AT Protocol, including the public
/// signing key.
public struct VerificationMethod: Codable {

    /// The unique identifier of the verification method.
    public var id: String

    /// The type of verification method that indicates the cryptographic curve used.
    public var type: String

    /// The controller of the verification method, which matches the
    /// decentralized identifier (DID).
    public var controller: String

    /// The public key, in multibase encoding; used for verifying digital signatures.
    public var publicKeyMultibase: String
}

/// Represents a service endpoint in a DID document, such as the
/// Personal Data Server's (PDS) location.
public struct ATService: Codable {

    /// The unique identifier of the service.
    public var id: String

    /// The type of service (matching `AtprotoPersonalDataServer`) for use in identifying
    /// the Personal Data Server (PDS).
    public var type: String

    /// The endpoint URL for the service, specifying the location of the service.
    public var serviceEndpoint: URL
}

/// Indicates the status of the user account if it's inactivate.
///
/// - Note: According to the AT Protocol specifications: "If active=false, this optional field
/// indicates a possible reason for why the account is not active. If active=false and no status
/// is supplied, then the host makes no claim for why the repository is no longer being hosted."
public enum UserAccountStatus: String, Codable {

    /// Indicates the user account is inactive due to a takedown.
    case takedown

    /// Indicates the user account is inactivate due to a suspension.
    case suspended

    /// Indicates the user account is inactivate due to a deactivation.
    case deactivated
}
