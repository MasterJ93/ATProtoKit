//
//  ATProtocolConfiguration.swift
//  
//
//  Created by Christopher Jr Riley on 2024-01-06.
//

import Foundation

/// Manages authentication and session operations for the a user account in the ATProtocol.
public class ATProtocolConfiguration: ProtocolConfiguration {
    /// The user's handle identifier in their account.
    public private(set) var handle: String
    /// The app password of the user's account.
    public private(set) var appPassword: String
    /// The URL of the Personal Data Server (PDS).
    public private(set) var pdsURL: String
    
    /// Initializes a new instance of `ATProtocolConfiguration`.
    /// - Parameters:
    ///   - handle: The user's handle identifier in their account.
    ///   - appPassword: The app password of the user's account.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `https://bsky.social`.
    public init(handle: String, appPassword: String, pdsURL: String = "https://bsky.social") {
        self.handle = handle
        self.appPassword = appPassword
        self.pdsURL = !pdsURL.isEmpty ? pdsURL : "https://bsky.social"
    }
    
    /// Attempts to authenticate the user into the server.
    /// - Returns: A `Result` containing ``UserSession`` on success or an `Error` on failure.
    public func authenticate() async throws -> Result<UserSession, Error> {
        guard let requestURL = URL(string: "\(self.pdsURL)/xrpc/com.atproto.server.createSession") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        let request = APIClientService.createRequest(forRequest: requestURL, andMethod: .post)

        let credentials = SessionCredentials(identifier: handle, password: appPassword)

        do {
            let userSession = try await APIClientService.sendRequest(request, withEncodingBody: credentials, decodeTo: UserSession.self)
            userSession.pdsURL = self.pdsURL

            return .success(userSession)
        } catch {
            print("Error: \(error)")
            return .failure(error)
        }
    }
    
    /// Fetches an existing session using an access token.
    /// - Parameters:
    ///   - accessToken: The access token for the session.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `https://bsky.social`.
    /// - Returns: Returns: A `Result` containing ``SessionResponse`` on success or an `Error` on failure.
    public static func getSession(byAccessToken accessToken: String, pdsURL: String = "https://bsky.social") async throws -> Result<SessionResponse, Error> {
        guard let requestURL = URL(string: "\(pdsURL)/xrpc/com.atproto.server.getSession") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        let request = APIClientService.createRequest(forRequest: requestURL, andMethod: .get, authorizationValue: "Bearer \(accessToken)")

        do {
            let response = try await APIClientService.sendRequest(request, decodeTo: SessionResponse.self)
            return .success(response)
        } catch {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "Error: \(error)"]))
        }
    }

    /// Refreshes the user's session using a refresh token.
    /// - Parameters:
    ///   - refreshToken: The refresh token for the session.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `https://bsky.social`.
    public func refreshSession(_ refreshToken: String, pdsURL: String = "https://bsky.social") async throws -> Result<UserSession, Error> {
        guard let requestURL = URL(string: "\(self.pdsURL)/xrpc/com.atproto.server.refreshSession") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        let request = APIClientService.createRequest(forRequest: requestURL, andMethod: .post, authorizationValue: "Bearer \(refreshToken)")

        do {
            let response = try await APIClientService.sendRequest(request, decodeTo: UserSession.self)
            response.pdsURL = self.pdsURL
            return .success(response)
        } catch {
            return .failure(error)
        }
    }
    
    /// Refreshes the user's session using a refresh token.
    /// - Parameters:
    ///   - accessToken: The access token for the session.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `https://bsky.social`.
    public static func deleteSession(_ accessToken: String, pdsURL: String = "https://bsky.social") async throws {
        guard let requestURL = URL(string: "\(pdsURL)/xrpc/com.atproto.server.deleteSession") else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }

        let request = APIClientService.createRequest(forRequest: requestURL, andMethod: .post, authorizationValue: "Bearer \(accessToken)")

        do {
            try await APIClientService.sendRequest(request)
        } catch {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid Request"])
        }
    }
//    private func reAuthenticateUser(completion: @escaping (Result<Void, Error>) -> Void) {
//        // Use stored credentials or prompt the user for credentials to re-authenticate.
//        self.loginToBluesky(with: <#T##String#>, appPassword: <#T##String#>, pdsURL: <#T##String#>) { result in
//            <#code#>
//        }
//        // and create a new session
//    }
}
