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

    /// Creates a new instance by decoding from the given decoder to a `[String: CodableValue]`.
    ///
    /// Do not use this initializer directly: this must only be used inside of a union `enum`.
    ///
    /// This initializer throws an error if reading from the decoder fails, or if the data read is corrupted
    /// or otherwise invalid.
    ///
    /// - Parameter decoder: The decoder to read data from.
    init(fromUnknown decoder: Decoder) throws
}
