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
    
    public func authenticate(completion: @escaping (Result<UserSession, Error>) -> Void) {
        // Check if `pdsURL` is empty.
        if self.pdsURL == "" {
            self.pdsURL = "https://bsky.social"
        }
        
        guard let url = URL(string: "\(self.pdsURL)/xrpc/com.atproto.server.createSession") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let credentials = ["identifier": handle, "password": appPassword]
        guard let httpBody = try? JSONSerialization.data(withJSONObject: credentials) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error encoding credentials"])))
            return
        }
        
        request.httpBody = httpBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle the network response.
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "No data received"])))
                return
            }
            
            do {
                // Extract tokens and other data from the response.
                let decoder = JSONDecoder()
                let authResponse = try decoder.decode(AuthenticationResponse.self, from: data)
                let userSession = UserSession(handle: authResponse.handle,
                                              did: authResponse.did,
                                              email: authResponse.email,
                                              accessJwt: authResponse.accessJwt,
                                              refreshJwt: authResponse.refreshJwt)
                completion(.success(userSession))
            } catch {
                completion(.failure(error))
                print("Error: \(error)")
            }
        }.resume()
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
