//
//  ProtocolConfiguration.swift
//  
//
//  Created by Christopher Jr Riley on 2024-01-06.
//

import Foundation

public protocol ProtocolConfiguration {
    var handle: String { get }
    var appPassword: String { get }
    var pdsURL: String { get }
    func authenticate(completion: @escaping (Result<UserSession, Error>) -> Void)
}
