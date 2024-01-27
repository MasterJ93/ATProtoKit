//
//  AtprotoIdentityResolveHandle.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-27.
//

import Foundation

// Represents the query parameters for `resolveHandle`
public struct ResolveHandleQuery: Encodable {
    public let handle: String
}

// Represents the output of the `resolveHandle` query
public struct ResolveHandleOutput: Decodable {
    public let did: String
}
