//
//  UserSession.swift
//  
//
//  Created by Christopher Jr Riley on 2024-01-05.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Represents an authenticated user session within the AT Protocol.
///
/// This class encapsulates the details of a user's session, including their
/// decentralized identifier (DID), authentication tokens, and optional user information such
/// as email. It also references the user's DID document, which contains crucial
/// AT Protocol-specific information.
///
/// This is based loosely based on the [`com.atproto.server.createSession`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/createSession.json
public struct UserSession: Sendable, Codable {

    /// The user's handle within the AT Protocol.
    public let handle: String

    /// The decentralized identifier (DID), serving as a persistent and long-term account
    /// identifier according to the W3C standard.
    public let sessionDID: String

    /// The user's email address. Optional.
    public let email: String?

    /// Indicates whether the user's email address has been confirmed. Optional.
    public let isEmailConfirmed: Bool?

    /// Indicates whether Two-Factor Authentication (via email) is enabled. Optional.
    public let isEmailAuthenticationFactorEnabled: Bool?

    /// The DID document associated with the user, which contains AT Protocol-specific
    /// information. Optional.
    public let didDocument: DIDDocument?

    /// Indicates whether the user account is active. Optional.
    public let isActive: Bool?

    /// Indicates the possible reason for why the user account is inactive. Optional.
    public let status: UserAccountStatus?

    /// The user account's endpoint used for sending authentication requests.
    public let serviceEndpoint: URL

    /// The URL of the Personal Data Server (PDS) associated with the user. Optional.
    ///
    /// - Note: This is not included when initalizing `UserSession`. Instead, it's added
    /// after the successful initalizing.
    public var pdsURL: String?

    /// Initializes a new user session with the specified details.
    public init(handle: String, sessionDID: String, email: String? = nil, isEmailConfirmed: Bool? = nil, isEmailAuthenticationFactorEnabled: Bool?,
                didDocument: DIDDocument? = nil, isActive: Bool?, status: UserAccountStatus?, serviceEndpoint: URL, pdsURL: String? = nil) {
        self.handle = handle
        self.sessionDID = sessionDID
        self.email = email
        self.isEmailConfirmed = isEmailConfirmed
        self.isEmailAuthenticationFactorEnabled = isEmailAuthenticationFactorEnabled
        self.didDocument = didDocument
        self.isActive = isActive
        self.status = status
        self.serviceEndpoint = serviceEndpoint
        self.pdsURL = pdsURL
    }

    enum CodingKeys: String, CodingKey {
        case handle
        case sessionDID = "did"
        case email
        case isEmailConfirmed = "emailConfirmed"
        case isEmailAuthenticationFactorEnabled = "emailAuthFactor"
        case didDocument = "didDoc"
        case isActive = "active"
        case status
        case serviceEndpoint
        case pdsURL
    }
}


/// Represents a DID document in the AT Protocol, containing crucial information fo
/// AT Protocol functionality.
///
/// The DID document includes the decentralized identifier (DID), verification methods, and
/// service endpoints necessary for interacting with the AT Protocol ecosystem, such as
/// authentication and data storage locations.
public struct DIDDocument: Sendable, Codable {

    /// An array of context URLs for the DID document, providing additional semantics for
    /// the properties.
    public let context: [String]

    /// The unique identifier of the DID document.
    public let id: String

    /// An array of URIs under which this decentralized identifier (DID) is also known, including
    /// the primary handle URI. Optional.
    public let alsoKnownAs: [String]?

    /// An array of methods for verifying digital signatures, including the public signing key
    /// for the account.
    public let verificationMethod: [VerificationMethod]

    /// An array of service endpoints related to the decentralized identifier (DID), including the
    /// Personal Data Server's (PDS) location.
    public let service: [ATService]

    /// Checks if the ``service`` property array contains items, and if so, sees if `#atproto_pds`
    /// is in the ``ATService/id`` property.
    ///
    /// - Returns: An ``ATService`` item.
    ///
    /// - Throws: ``DIDDocumentError`` if ``service`` is empty or if none of the items
    /// contain `#atproto_pds`.
    public func checkServiceForATProto() throws -> ATService {
        let services = self.service

        guard services.count > 0 else {
            throw DIDDocumentError.emptyArray
        }

        for service in services {
            if service.id == "#atproto_pds" {
                return service
            }
        }

        throw DIDDocumentError.noATProtoPDSValue
    }

    enum CodingKeys: String, CodingKey {
        case context = "@context"
        case id
        case alsoKnownAs
        case verificationMethod
        case service
    }

    /// Errors relating to the DID Document.
    public enum DIDDocumentError: ATProtoError {

        /// The ``DIDDocument/service`` array is empty.
        case emptyArray

        /// None of the items in the ``DIDDocument/service`` array contains a `#atproto_pds`
        /// value in the ``ATService/id`` property.
        case noATProtoPDSValue
    }
}

/// Describes a method for verifying digital signatures in the AT Protocol, including the public
/// signing key.
public struct VerificationMethod: Sendable, Codable {

    /// The unique identifier of the verification method.
    public let id: String

    /// The type of verification method that indicates the cryptographic curve used.
    public let type: String

    /// The controller of the verification method, which matches the
    /// decentralized identifier (DID).
    public let controller: String

    /// The public key, in multibase encoding; used for verifying digital signatures.
    public let publicKeyMultibase: String
}

/// Represents a service endpoint in a DID document, such as the
/// Personal Data Server's (PDS) location.
public struct ATService: Sendable, Codable {

    /// The unique identifier of the service.
    public let id: String

    /// The type of service (matching `AtprotoPersonalDataServer`) for use in identifying
    /// the Personal Data Server (PDS).
    public let type: String

    /// The endpoint URL for the service, specifying the location of the service.
    public let serviceEndpoint: URL
}

/// Indicates the status of the user account if it's inactivate.
///
/// - Note: According to the AT Protocol specifications: "If active=false, this optional field
/// indicates a possible reason for why the account is not active. If active=false and no status
/// is supplied, then the host makes no claim for why the repository is no longer being hosted."
public enum UserAccountStatus: String, Sendable, Codable {

    /// Indicates the user account is inactive due to a takedown.
    case takedown

    /// Indicates the user account is inactivate due to a suspension.
    case suspended

    /// Indicates the user account is inactivate due to a deactivation.
    case deactivated

    /// Creates an instance of ``UserAccountStatus`` from a
    /// ``ComAtprotoLexicon/Server/GetSession/UserAccountStatus`` object.
    ///
    /// This initializer maps the cases of
    /// ``ComAtprotoLexicon/Server/GetSession/UserAccountStatus`` to their applicable
    /// ``UserAccountStatus`` cases.
    ///
    /// ```swift
    /// let getSessionStatus = ComAtprotoLexicon.Server.GetSession.UserAccountStatus.suspended
    /// let status = UserAccountStatus(from: getSessionStatus)
    /// print(status) // UserAccountStatus.suspended
    /// ```
    ///
    /// - Parameter status: A ``ComAtprotoLexicon/Server/GetSession/UserAccountStatus`` value.
    public init?(from status: ComAtprotoLexicon.Server.GetSession.UserAccountStatus?) {
        switch status {
            case .suspended:
                self = .suspended
            case .takedown:
                self = .takedown
            case .deactivated:
                self = .deactivated
            default:
                return nil
        }
    }

    /// Creates an instance of ``UserAccountStatus`` from a
    /// ``ComAtprotoLexicon/Server/RefreshSession/UserAccountStatus`` object.
    ///
    /// This initializer maps the cases of
    /// ``ComAtprotoLexicon/Server/RefreshSession/UserAccountStatus`` to their applicable
    /// ``UserAccountStatus`` cases.
    ///
    /// ```swift
    /// let refreshSessionStatus = ComAtprotoLexicon.Server.RefreshSession.UserAccountStatus.suspended
    /// let status = UserAccountStatus(from: refreshSessionStatus)
    /// print(status) // UserAccountStatus.suspended
    /// ```
    ///
    /// - Parameter status: A ``ComAtprotoLexicon/Server/RefreshSession/UserAccountStatus`` value.
    public init?(from status: ComAtprotoLexicon.Server.RefreshSession.UserAccountStatus?) {
        switch status {
            case .suspended:
                self = .suspended
            case .takedown:
                self = .takedown
            case .deactivated:
                self = .deactivated
            default:
                return nil
        }
    }
}
