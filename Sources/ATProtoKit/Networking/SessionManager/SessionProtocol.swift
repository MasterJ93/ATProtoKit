//
//  SessionProtocol.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-05.
//

import Foundation

public protocol SessionProtocol: Codable {
    var handle: String { get }
    var atDID: String { get }
    var email: String? { get }
    var emailConfirmed: Bool? { get }
    var accessJwt: String { get }
    var refreshJwt: String { get }
    var didDocument: DIDDocument? { get }

    var pdsURL: String? { get }
    
    func isAccessTokenExpired() -> Bool
}
