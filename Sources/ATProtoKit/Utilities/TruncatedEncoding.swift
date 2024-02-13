//
//  TruncatedEncoding.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-25.
//

import Foundation

internal protocol Truncatable {
    func truncated(toLength length: Int) -> Self
}

internal func truncatedEncode<T: CodingKey, Element: Truncatable & Encodable>(_ value: Element, withContainer container: inout KeyedEncodingContainer<T>, forKey key: T, upToLength length: Int) throws {
    let truncatedValue = value.truncated(toLength: length)
    try container.encode(truncatedValue, forKey: key)
}

internal func truncatedEncodeIfPresent<T: CodingKey, Element: Truncatable & Encodable>(_ value: Element?, withContainer container: inout KeyedEncodingContainer<T>, forKey key: T, upToLength length: Int) throws {
    if let value = value {
        let truncatedValue = value.truncated(toLength: length)
        try container.encode(truncatedValue, forKey: key)
    }
}
