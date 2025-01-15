//
//  AuthorizationRequest.swift
//
//
//  Created by Christopher Jr Riley on 2025-01-15.
//

import Foundation

public struct OAuthAuthorizationRequest: Codable, Sendable {

    /// The ID of the client.
    ///
    /// - Note: According to the AT Protocol specifications: "identifies the client software. See "Clients" section above for details."
    public let clientID: String

    /// The type of response the client is expecting from the Authorization Server.
    ///
    /// - Note: According to the AT Protocol specifications: "Must be `code`"
    public let responseType: String

    /// The code challenge created for the PKCE.
    ///
    /// - Note: According to the AT Protocol specifications: "The PKCE challenge value.
    /// See "PKCE" section."
    public let pkceCodeChallenge: String

    /// The method used for the code challenge.
    ///
    /// - Note: According to the AT Protocol specifications: "Which code challenge method is used,
    /// for example `S256`. See "PKCE" section."
    public let codeChallengeMethod: String

    /// A random token used for autheorization request validations.
    ///
    /// - Note: According to the AT Protocol specifications: "Random token used to verify the
    /// authorization request against the response. See below."
    public let state: String

    /// The URI used to redirect users back to the application.
    ///
    /// - Note: According to the AT Protocol specifications: "Must match against URIs declared in
    /// client metadata and have a format consistent with the `application_type` declared in the
    /// client metadata. See below."
    public let redirectURI: String

    /// An array of values representing for what's being requested by the client.
    ///
    /// - Note: According to the AT Protocol specifications: "Must be a subset of the scopes
    /// declared in client metadata. Must include `atproto`. See "Scopes" section."
    public let scopes: [String]

    /// The type used to describe the clent authentication mechanism. Optional.
    ///
    /// - Note: According to the AT Protocol specifications: "Used by confidential clients to
    /// describe the client authentication mechanism. See "Confidential Client" section."
    public let clientAssertionType: String?

    /// A signed JSON Web Token (JWT) used by a client to authenticate itself to an
    /// Authorization Server, replacing or supplementing traditional credentials like
    /// client secrets.
    ///
    /// - Note: According to the AT Protocol specifications: "Only used for confidential clients,
    /// for client authentication. See "Confidential Client" section."
    public let clientAssertion: String?

    /// The decentralized identifier (DID) or handle of the user account. Optional.
    ///
    /// - Note: According to the AT Protocol specifications: "Account identifier to be used
    /// for login. See "Authorization Interface" section."
    public let loginHint: String?
}
