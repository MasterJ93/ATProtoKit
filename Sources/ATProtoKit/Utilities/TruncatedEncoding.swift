//
//  TruncatedEncoding.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-25.
//

import Foundation

func truncatedEncode<T: CodingKey>(_ string: String, withContainer container: inout KeyedEncodingContainer<T>, forKey key: T, upToLength length: Int) throws {
    let truncatedString = String(string.prefix(length))
    try container.encode(truncatedString, forKey: key)
}

func truncatedEncodeIfPresent<T: CodingKey>(_ string: String?, withContainer container: inout KeyedEncodingContainer<T>, forKey key: T, upToLength length: Int) throws {
    if let string = string {
        let truncatedString = String(string.prefix(length))
        try container.encode(truncatedString, forKey: key)
    }
}
