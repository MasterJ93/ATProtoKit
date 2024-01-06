//
//  SessionProtocol.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-05.
//

import Foundation

public protocol SessionProtocol {
    var handle: String { get }
    var did: String { get }
    var email: String { get }
    var accessJwt: String { get }
    var refreshJwt: String { get }
    var pdsURL: String { get }
    
    func isAccessTokenExpired() -> Bool
}
