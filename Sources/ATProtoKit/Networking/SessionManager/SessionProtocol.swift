//
//  SessionProtocol.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-05.
//

import Foundation

public protocol SessionProtocol {
    var handle: String { get }
    var did: String? { get set }
    var email: String? { get set }
    var accessJwt: String? { get set }
    var refreshJwt: String? { get set }
    
    func isAccessTokenExpired() -> Bool
}
