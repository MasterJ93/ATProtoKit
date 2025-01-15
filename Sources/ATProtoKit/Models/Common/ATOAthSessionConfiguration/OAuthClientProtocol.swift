//
//  OAuthClientProtocol.swift
//
//
//  Created by Christopher Jr Riley on 2025-01-15.
//

import Foundation

public protocol OAuthClientMetadataProtocol: Codable, Sendable {

    /// The ID of the client.
    ///
    /// - Important: When implementing this, set the value of this in `CodingKeys`
    /// to `client_id`.
    var clientID: String { get }

    /// The client's name. Optional.
    ///
    /// - Important: When implementing this, set the value of this in `CodingKeys`
    /// to `client_name`.
    var clientName: String? { get }

    /// An array of values representing for what's being requested by the client.
    ///
    /// - Important: When implementing this, set the value of this in `CodingKeys`
    /// to `scope`.
    var scopes: [OAuthScopes] { get }

    /// The type of response the client is expecting from the authorization server.
    ///
    /// - Important: When implementing this, set the value of this in `CodingKeys`
    /// to `response_types`.
    var responseTypes: [String] { get }

    /// An array of grant types the client can use in an Authorization Server interactions.
    ///
    /// - Important: When implementing this, set the value of this in `CodingKeys`
    /// to `grant_types`.
    var grantTypes: [OAuthGrantTypes] { get }

    /// The authentication method that the client uses to authenticate itself to the
    /// Authorization Server. Optional.
    ///
    /// - Important: When implementing this, set the value of this in `CodingKeys`
    /// to `token_endpoint_auth_method`.
    var tokenEndpointAuthenticationMethod: [String]? { get }

    /// An OpenID/OIDC field for determining the type of application is a native or
    /// web application. Optional. Defaults to `.web`.
    ///
    /// - Important: When implementing this, set the value of this in `CodingKeys`
    /// to `application_type`.
    var applicationType: OAuthApplicationType? { get }

    /// Indicates whether the access tokens are bound to DPoP.
    ///
    /// - Important: When implementing this, set the value of this in `CodingKeys`
    /// to `dpop_bound_access_tokens`. In addition, the property must be `true`.
    var areTokensBoundToDPoP: Bool { get }
}

extension OAuthClientMetadataProtocol {

    var areTokensBoundToDPoP: Bool {
        return true
    }
}

public enum OAuthApplicationType: String, Codable {

    /// Indicates the application type is a web application.
    case web

    /// Indicates the application type is a native application.
    case native
}

public enum OAuthGrantTypes: String, Codable {

    ///
    case authorizationCode = "authorization_code"

    ///
    case refreshToken = "refresh_token"
}

public enum OAuthScopes: String, Codable {

    /// Signifies the client is using the `atproto` profile of OAuth.
    ///
    /// - Warning: This is required to be used in order to access the
    /// Personal Data Server (PDS).
    case atproto = "atproto"

    /// The generic scope that allows for most uses of the user account.
    ///
    /// This includes CRUD operations of records, uploading blobs, read/write permissions of
    /// personal preferences, API endpoints and service proxying for most Lexicon endpoints,
    /// and generating service authenication tokens,
    case transitionGeneric = "transition:generic"

    /// The scope that allows for access to the Bluesky DM functions
    /// (the `chat.bsky.*` lexicon methods.).
    case transitionChatBsky = "transition:chat.bsky"
    }
