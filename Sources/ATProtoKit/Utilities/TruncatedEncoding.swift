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

extension String: Truncatable {
    func truncated(toLength length: Int) -> String {
        return String(self.prefix(length))
    }
}

extension Array: Truncatable {
    func truncated(toLength length: Int) -> Array<Element> {
        return Array(self.prefix(length))
    }
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
