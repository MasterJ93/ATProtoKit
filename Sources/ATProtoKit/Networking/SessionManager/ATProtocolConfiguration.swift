//
//  ATProtocolConfiguration.swift
//  
//
//  Created by Christopher Jr Riley on 2024-01-06.
//

import Foundation

public class ATProtocolConfiguration: ProtocolConfiguration {
    public private(set) var handle: String
    public private(set) var appPassword: String
    public private(set) var pdsURL: String
    
    public init(handle: String, appPassword: String, pdsURL: String = "https://bsky.social") {
        self.handle = handle
        self.appPassword = appPassword
        self.pdsURL = !pdsURL.isEmpty ? pdsURL : "https://bsky.social"
    }

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

    public static func getSession(byAccessToken accessJWT: String, pdsURL: String = "https://bsky.social") async throws -> Result<SessionResponse, Error> {
        guard let requestURL = URL(string: "\(pdsURL)/xrpc/com.atproto.server.getSession") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        let request = APIClientService.createRequest(forRequest: requestURL, andMethod: .get, authorizationValue: "Bearer \(accessJWT)")

        do {
            let response = try await APIClientService.sendRequest(request, decodeTo: SessionResponse.self)
            return .success(response)
        } catch {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "Error: \(error)"]))
        }
    }
//    private func reAuthenticateUser(completion: @escaping (Result<Void, Error>) -> Void) {
//        // Use stored credentials or prompt the user for credentials to re-authenticate.
//        self.loginToBluesky(with: <#T##String#>, appPassword: <#T##String#>, pdsURL: <#T##String#>) { result in
//            <#code#>
//        }
//        // and create a new session
//    }
//    
//    public func refreshSession(with refreshToken: String, pdsURL: String = "https://bsky.social", completion: @escaping (Result<AuthenticationResponse, Error>) -> Void) {
//        <#code#>
//    }
}
