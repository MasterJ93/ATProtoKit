//
//  ClientIDMetadata.swift
//
//
//  Created by Christopher Jr Riley on 2025-01-14.
//

import Foundation


public struct ClientIDMetadata: OAuthClientMetadataProtocol {

    /// The ID of the client.
    ///
    /// - Note: According to the AT Protocol specifications: "The `client_id`. Must exactly match
    /// the full URL used to fetch the client metadata file itself"
    public let clientID: String

    /// An OpenID/OIDC field for determining the type of application is a native or
    /// web application. Optional. Defaults to `.web`.
    ///
    /// - Note: According to the AT Protocol specifications: "Must be one of `web` or `native`,
    /// with `web` as the default if not specified. Note that this is field specified by
    /// OpenID/OIDC, which we are borrowing. Used by the Authorization Server to enforce the
    /// relevant 'best current practices'"
    public var applicationType: OAuthApplicationType? = .web

    /// An array of grant types the client can use in an Authorization Server interactions.
    ///
    /// - Note: According to the AT Protocol specifications: "`authorization_code` must always
    /// be included. `refresh_token` is optional, but must be included if the client will make
    /// token refresh requests."
    public let grantTypes: [OAuthGrantTypes]

    /// An array of values representing for what's being requested by the client.
    ///
    /// - Note: According to the AT Protocol specifications: "All scope values which might be
    /// requested by this client are declared here. The `atproto` scope is required, so must be
    /// included here. See "Scopes" section."
    public let scopes: [OAuthScopes]

    /// The type of response the client is expecting from the authorization server.
    ///
    /// - Note: According to the AT Protocol specifications: "`code` must be included."
    public let responseTypes: [String]

    /// An array of URIs used to redirect users back to the application.
    ///
    /// - Note: According to the AT Protocol specifications: "At least one redirect URI
    /// is required. See Authorization Request Fields section for rules about redirect URIs, which
    /// also apply here."
    public let requestURIs: [String]

    /// The authentication method that the client uses to authenticate itself to the
    /// Authorization Server. Optional.
    ///
    /// - Note: According to the AT Protocol specifications: "Confidential clients must set this
    /// to `private_key_jwt`."
    public let tokenEndpointAuthenticationMethod: [String]?

    /// The authentication signing algorithm used by the Authorization Server. Optional.
    ///
    /// - Note: According to the AT Protocol specifications: "`none` is never allowed here.
    /// The current recommended and most-supported algorithm is `ES256`, but this may evolve
    /// over time. Authorization Servers will compare this against their supported algorithms."
    public let tokenEndpointAuthenticationSigningAlgorithm: [String]?

    /// Indicates whether the access tokens are bound to DPoP.
    ///
    /// - Note: According to the AT Protocol specifications: "DPoP is mandatory for all clients,
    /// so this must be present and `true`"
    ///
    /// - Warning: This should never be changed and most always be set to `true`.
    public let areTokensBoundToDPoP: Bool

    /// An array of JSON Web Keys (JWKs). Optional.
    ///
    /// - Note: According to the AT Protocol specifications: "Confidential clients must supply at
    /// least one public key in JWK format for use with JWT client authentication. Either this
    /// field or the `jwks_uri` field must be provided for confidential clients, but not both."
    public let jsonWebKeys: [String]?

    /// The URI of the JSON Web Key. Optional.
    ///
    /// - Note: According to the AT Protocol specifications: "URL pointing to a JWKS JSON object.
    /// See `jwks` above for details."
    public let jsonWebKeysURI: String?

    /// The client's name. Optional.
    ///
    /// - Note: According to the AT Protocol specifications: "Human-readable name of the client"
    public let clientName: String?

    /// The client's URI. Optional.
    ///
    /// - Note: According to the AT Protocol specifications: "Not to be confused with `client_id`,
    /// this is a homepage URL for the client. If provided, the `client_uri` must have the same
    /// hostname as `client_id`."
    public let clientURI: String?

    /// The URI of the client's logo for the client. Optional.
    ///
    /// - Note: According to the AT Protocol specifications: "URL to client logo. Only `https:` URIs
    /// are allowed."
    public let logoURI: String?

    /// The URI of the client's Terms of Service. Optional.
    ///
    /// - Note: According to the AT Protocol specifications: "URL to human-readable
    /// terms of service (ToS) for the client. Only `https:` URIs are allowed."
    public let termsOfServiceURI: String?

    /// The URI of the client's Privacy Policy. Optional.
    ///
    /// - Note: According to the AT Protocol specifications: "URL to human-readable privacy policy
    /// for the client. Only `https:` URIs are allowed."
    public let privacyPolicyURI: String?

    init(
        clientID: String,
        applicationType: OAuthApplicationType? = .web,
        grantTypes: [OAuthGrantTypes],
        scopes: [OAuthScopes],
        responseTypes: [String],
        requestURIs: [String],
        tokenEndpointAuthenticationMethod: [String]? = nil,
        tokenEndpointAuthenticationSigningAlgorithm: [String]? = nil,
        jsonWebKeys: [String]? = nil,
        jsonWebKeysURI: String? = nil,
        clientName: String? = nil,
        clientURI: String? = nil,
        logoURI: String? = nil,
        termsOfServiceURI: String? = nil,
        privacyPolicyURI: String? = nil
    ) {
        self.clientID = clientID
        self.applicationType = applicationType
        self.grantTypes = grantTypes
        self.scopes = scopes
        self.responseTypes = responseTypes
        self.requestURIs = requestURIs
        self.tokenEndpointAuthenticationMethod = tokenEndpointAuthenticationMethod
        self.tokenEndpointAuthenticationSigningAlgorithm = tokenEndpointAuthenticationSigningAlgorithm
        self.areTokensBoundToDPoP = true
        self.jsonWebKeys = jsonWebKeys
        self.jsonWebKeysURI = jsonWebKeysURI
        self.clientName = clientName
        self.clientURI = clientURI
        self.logoURI = logoURI
        self.termsOfServiceURI = termsOfServiceURI
        self.privacyPolicyURI = privacyPolicyURI
    }

    enum CodingKeys: String, CodingKey {
        case clientID = "client_id"
        case applicationType = "application_type"
        case grantTypes = "grant_types"
        case scopes = "scope"
        case responseTypes = "response_types"
        case requestURIs = "redirect_uris"
        case tokenEndpointAuthenticationMethod = "token_endpoint_auth_method"
        case tokenEndpointAuthenticationSigningAlgorithm = "token_endpoint_auth_signing_alg"
        case areTokensBoundToDPoP = "dpop_bound_access_tokens"
        case jsonWebKeys = "jwks"
        case jsonWebKeysURI = "jwks_uri"
        case clientName = "client_name"
        case clientURI = "client_uri"
        case logoURI = "logo_uri"
        case termsOfServiceURI = "tos_uri"
        case privacyPolicyURI = "policy_uri"
    }
}
