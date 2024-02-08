//
//  SessionResponse.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-05.
//

import Foundation

public struct SessionResponse: SessionProtocol {
    public var handle: String
    public var atDID: String
    public var email: String?
    public var emailConfirmed: Bool?
    public var didDocument: DIDDocument?

    enum CodingKeys: String, CodingKey {
        case handle
        case atDID = "did"
        case email
        case emailConfirmed
        case didDocument = "didDoc"
    }
}
