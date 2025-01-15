//
//  LocalhostClientIDMetadata.swift
//
//
//  Created by Christopher Jr Riley on 2025-01-15.
//

import Foundation

public struct LocalhostClientIDMetadata: OAuthClientMetadataProtocol {

    /// A URI used to redirect users back to the application.
    public let requestURI: String

    /// An array of values representing for what's being requested by the client.
    public let scopes: [OAuthScopes]

    /// The ID of the client.
    public let clientID: String

    /// The name of the client. Optional.
    public let clientName: String?

    /// The type of response the client is expecting from the authorization server.
    public let responseTypes: [String]

    /// An array of grant types the client can use in an Authorization Server interactions.
    public let grantTypes: [OAuthGrantTypes]

    /// The authentication method that the client uses to authenticate itself to the
    /// Authorization Server. Optional.
    public let tokenEndpointAuthenticationMethod: [String]?

    /// An OpenID/OIDC field for determining the type of application is a native or
    /// web application. Optional. Defaults to `.web`.
    public let applicationType: OAuthApplicationType?

    /// Indicates whether the access tokens are bound to DPoP.
    public let areTokensBoundToDPoP: Bool

    public init(
        requestURI: String,
        scopes: [OAuthScopes],
        clientID: String,
        clientName: String? = nil,
        responseTypes: [String]
    ) {
        self.requestURI = requestURI
        self.scopes = scopes
        self.clientID = clientID
        self.clientName = clientName
        self.responseTypes = responseTypes
        self.grantTypes = [.authorizationCode, .refreshToken]
        self.tokenEndpointAuthenticationMethod = ["none"]
        self.applicationType = .native
        self.areTokensBoundToDPoP = true
    }

    enum CodingKeys: String, CodingKey {
        case requestURI = "redirect_uri"
        case scopes = "scope"
        case clientID = "client_id"
        case clientName = "client_name"
        case responseTypes = "response_types"
        case grantTypes = "grant_types"
        case tokenEndpointAuthenticationMethod = "token_endpoint_auth_method"
        case applicationType = "application_type"
        case areTokensBoundToDPoP = "dpop_bound_access_tokens"
    }
}
