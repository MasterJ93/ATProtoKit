//
//  TruncatedEncoding.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-25.
//

import Foundation

/// A protocol that defines a method for truncating an object.
internal protocol Truncatable {
    func truncated(toLength length: Int) -> Self
}

/// Encodes a `Truncatable & Encodable` value to a container with truncation.
///
/// This is used as a replacement of `encode(_:forKey:)` if the object needs to be truncated before
/// it's encoded.
///
/// - Parameters:
///   - value: The value to encode.
///   - container: The container to encode the value into.
///   - key: The key to associate with the encoded value.
///   - length: The maximum length to which the value should be truncated before encoding.
/// - Throws: `EncodingError.invalidValue` if the given value is invalid in the current context
/// for this format.
internal func truncatedEncode<T: CodingKey, Element: Truncatable & Encodable>(_ value: Element,
                                                                              withContainer container: inout KeyedEncodingContainer<T>,
                                                                              forKey key: T,
                                                                              upToLength length: Int) throws {
    let truncatedValue = value.truncated(toLength: length)
    try container.encode(truncatedValue, forKey: key)
}

/// Encodes an optional `Truncatable & Encodable` value to a container with truncation if the
/// value is present.
///
/// This is used as a replacement of `encodeIfPresent(_:forKey:)`  if the object needs to be
/// truncated before it's encoded.
///
/// - Parameters:
///   - value: The optional value to encode if present.
///   - container: The container to encode the value into.
///   - key: The key to associate with the encoded value.
///   - length: The maximum length to which the value should be truncated before encoding,
///   if present.
/// - Throws: `EncodingError.invalidValue` if the given value is invalid in the current context
/// for this format.
internal func truncatedEncodeIfPresent<T: CodingKey, Element: Truncatable & Encodable>(_ value: Element?,
                                                                                       withContainer container: inout KeyedEncodingContainer<T>,
                                                                                       forKey key: T,
                                                                                       upToLength length: Int) throws {
    if let value = value {
        let truncatedValue = value.truncated(toLength: length)
        try container.encode(truncatedValue, forKey: key)
    }
}
