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
        self.pdsURL = pdsURL
    }

    public func authenticate() async throws -> Result<UserSession, Error> {
        // Check if `pdsURL` is empty.
        if self.pdsURL == "" {
            self.pdsURL = "https://bsky.social"
        }
        
        guard let url = URL(string: "\(self.pdsURL)/xrpc/com.atproto.server.createSession") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }
        
        let request = APIClientService.createRequest(forRequest: url, andMethod: .post)

//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        print("Request: \(request.httpMethod)\n\n\(request.allHTTPHeaderFields)\n\n\n")
        let credentials = ["identifier": handle, "password": appPassword]
        
        do {

            let authResponse = try await APIClientService.sendRequest(request, jsonData: credentials, decodeTo: AuthenticationResponse.self)
//            guard let httpBody = try? JSONSerialization.data(withJSONObject: credentials) else {
//                return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error encoding credentials"]))
//            }

//            request.httpBody = httpBody
//
//            let (data, response) = try await URLSession.shared.data(for: request)
//            
//            guard let httpResponse = response as? HTTPURLResponse else {
//                throw URLError(.badServerResponse)
//            }
//            
//            if httpResponse.statusCode != 200 {
//                throw URLError(.badServerResponse)
//            }
//            
//            // Extract tokens and other data from the response.
//            let decoder = JSONDecoder()
//            let authResponse = try decoder.decode(AuthenticationResponse.self, from: data)
//            let userSession = UserSession(handle: authResponse.handle,
//                                          did: authResponse.did,
//                                          email: authResponse.email,
//                                          accessJwt: authResponse.accessJwt,
//                                          refreshJwt: authResponse.refreshJwt)
//            return .success(userSession)
            let userSession = UserSession(handle: authResponse.handle, did: authResponse.did, email: authResponse.email, accessJwt: authResponse.accessJwt,
                                          refreshJwt: authResponse.refreshJwt, pdsURL: self.pdsURL)
            return .success(userSession)
        } catch {
            print("Error: \(error)")
            return .failure(error)
        }
    }
    
//    func ensureValidSession(completion: @escaping (Result<Void, Error>) -> Void) {
//        if let session = currentSession, !session.isAccessTokenExpired() {
//            completion(.success(()))
//            return
//        }
//        
//        if let refreshJwt = currentSession?.refreshJwt {
//            refreshSession(with: refreshJwt) { [weak self] result in
//                switch result {
//                    case .success(let sessionData):
//                        // Update the current session.
//                        guard let session = self?.createSession(withAuthenticationData: sessionData) else { return }
//                        self?.currentSession = session
//                        completion(.success(()))
//                    case .failure(_):
//                        self?.reAuthenticateUser(completion: completion)
//                }
//            }
//        } else {
//            reAuthenticateUser(completion: completion)
//        }
//        
//    }
//    
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
