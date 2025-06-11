//
//  ATUnionProtocol.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-06-10.
//

import Foundation

/// A set of tools related to union `enum`s.
///
/// All `enum`s used for union types must conform to this protocol.
public protocol ATUnionProtocol: Sendable, Codable {

    /// Attempts to decode a container into a `[String: Codable]`.
    ///
    /// - Parameters:
    ///   - singleValueContainer: A container that can support the storage and direct decoding of a single
    ///   nonkeyed value.
    ///   - decoder: A type that can decode values from a native format into in-memory representations.
    /// - Returns: A `[String: CodableValue]` representation of the JSON object.
    ///
    /// - Throws: `DecodingError` if the data is somehow corrupted.
    static func decodeDictionary(from singleValueContainer: SingleValueDecodingContainer, decoder: Decoder) throws -> [String: CodableValue]
}

extension ATUnionProtocol {

    public static func decodeDictionary(from singleValueContainer: SingleValueDecodingContainer, decoder: Decoder) throws -> [String: CodableValue] {
        do {
            return try singleValueContainer.decode([String: CodableValue].self)
        } catch {
            throw DecodingError.dataCorrupted(
                .init(
                    codingPath: decoder.codingPath,
                    debugDescription: "Failed to decode within the '\(String(describing: Swift.type(of: self)))' union type.",
                    underlyingError: error
                )
            )
        }
    }
}
