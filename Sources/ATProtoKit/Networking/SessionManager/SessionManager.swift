//
//  SessionManager.swift
//  
//
//  Created by Christopher Jr Riley on 2024-01-05.
//

import Foundation

public class SessionManager: SessionManagerProtocol {
    
    public var currentSession: SessionProtocol?
    
    public init() {
        //        self.currentSession = currentSession
    }
    
    func authenticateUser(with handle: String, and appPassword: String, pdsURL: String, completion: @escaping (Result<AuthenticationResponse, Error>) -> Void) {
        guard let url = URL(string: "\(pdsURL)/xrpc/com.atproto.server.createSession") else {
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
            // Handle the network response
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "No data received"])))
                return
            }
            
            do {
                // Extract tokens and other data from the response
                let decoder = JSONDecoder()
                let authResponse = try decoder.decode(AuthenticationResponse.self, from: data)
                print("Decoding successful.")
                completion(.success(authResponse))
            } catch {
                completion(.failure(error))
                print("Error: \(error)")
            }
        }.resume()
    }
    
    func createSession(withAuthenticationData data: AuthenticationResponse) -> UserSession {
        return UserSession(handle: data.handle, did: data.did, email: data.email, accessJwt: data.accessJwt, refreshJwt: data.refreshJwt)
    }
    
    
    public func loginToBluesky(with handle: String, appPassword: String, pdsURL: String = "https://bsky.social", completion: @escaping (Result<UserSession, Error>) -> Void) {
        // Perform the login process
        authenticateUser(with: handle, and: appPassword, pdsURL: pdsURL) { [weak self] result in
            switch result {
                case .success(let authResponse):
                    // On success, create a UserSession and set it as the currentSession
                    guard let session = self?.createSession(withAuthenticationData: authResponse) else { return }
                    self?.currentSession = session
                    completion(.success(session))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    public func refreshAccessToken(completion: @escaping (Result<Void, Error>) -> Void) {
        <#code#>
    }
}
