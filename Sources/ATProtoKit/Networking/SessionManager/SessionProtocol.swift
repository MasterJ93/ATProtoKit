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
    var didDocument: DIDDocument? { get }
}
