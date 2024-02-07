//
//  AtprotoServerCreateSession.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-07.
//

import Foundation

public struct SessionCredentials: Encodable {
    let identifier: String
    let password: String
}
