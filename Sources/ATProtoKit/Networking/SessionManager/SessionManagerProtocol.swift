//
//  SessionManagerProtocol.swift
//  
//
//  Created by Christopher Jr Riley on 2024-01-05.
//

import Foundation

public protocol SessionManagerProtocol {
    var currentSession: SessionProtocol? { get set }
    func loginToBluesky(with handle: String, appPassword: String, pdsURL: String, completion: @escaping (Result<UserSession, Error>) -> Void)
    func refreshAccessToken(completion: @escaping (Result<Void, Error>) -> Void)
}
