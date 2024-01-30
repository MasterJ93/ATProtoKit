//
//  UserSession.swift
//  
//
//  Created by Christopher Jr Riley on 2024-01-05.
//

import Foundation

public class UserSession: SessionProtocol {
    public private(set) var handle: String
    public private(set) var did: String
    public private(set) var email: String
    public private(set) var accessJwt: String
    public private(set) var refreshJwt: String
    public private(set) var pdsURL: String?
    
    
    init(handle: String, did: String, email: String, accessJwt: String, refreshJwt: String, pdsURL: String = "https://bsky.social") {
        self.handle = handle
        self.did = did
        self.email = email
        self.accessJwt = accessJwt
        self.refreshJwt = refreshJwt
        self.pdsURL = pdsURL
    }
    
    public func isAccessTokenExpired() -> Bool {
        // Implement logic to check if the accessJwt is expired
        // This could involve decoding the JWT and checking its expiry timestamp
        return false
    }
}
