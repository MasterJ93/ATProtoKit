//
//  AuthenticationResponse.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-05.
//

import Foundation

public struct AuthenticationResponse: Codable {
    var handle: String
    var atDID: String
    var email: String?
    var emailConfirmed: Bool?
    var accessJwt: String
    var refreshJwt: String
    var didDocument: DIDDocument?

    enum CodingKeys: String, CodingKey {
        case handle
        case atDID = "did"
        case email
        case emailConfirmed
        case accessJwt
        case refreshJwt
        case didDocument = "didDoc"
    }
}
