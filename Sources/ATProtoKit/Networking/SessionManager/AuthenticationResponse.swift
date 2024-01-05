//
//  AuthenticationResponse.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-05.
//

import Foundation

public struct AuthenticationResponse: Codable {
    var handle: String
    var accessJwt: String
    var refreshJwt: String
    var did: String
    var email: String
}
