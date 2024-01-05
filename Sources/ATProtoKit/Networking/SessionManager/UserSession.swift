//
//  UserSession.swift
//  
//
//  Created by Christopher Jr Riley on 2024-01-05.
//

import Foundation

public class UserSession: SessionProtocol {
    public let handle: String
    public var did: String?
    public var email: String?
    public var accessJwt: String?
    public var refreshJwt: String?
    
    
    init(handle: String, did: String?, email: String?, accessJwt: String?, refreshJwt: String?) {
        self.handle = handle
        self.did = did
        self.email = email
        self.accessJwt = accessJwt
        self.refreshJwt = refreshJwt
    }
    
    public func isAccessTokenExpired() -> Bool {
        // Implement logic to check if the accessJwt is expired
        // This could involve decoding the JWT and checking its expiry timestamp
        return false
    }
}
