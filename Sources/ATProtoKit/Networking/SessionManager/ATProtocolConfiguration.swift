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
        
        guard let url = URL(string: "\(self.pdsURL)/xrpc/com.atproto.server.createSession") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }
        
        let request = APIClientService.createRequest(forRequest: url, andMethod: .post)

        let credentials = SessionCredentials(identifier: handle, password: appPassword)

        do {
            let authResponse = try await APIClientService.sendRequest(request, withEncodingBody: credentials, decodeTo: AuthenticationResponse.self)

            let userSession = UserSession(handle: authResponse.handle,
                                          atDID: authResponse.atDID,
                                          email: authResponse.email,
                                          emailConfirmed: authResponse.emailConfirmed,
                                          accessJwt: authResponse.accessJwt,
                                          refreshJwt: authResponse.refreshJwt,
                                          didDocument: authResponse.didDocument,
                                          pdsURL: self.pdsURL)
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
