//
//  ATRecordProtocol.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-25.
//

import Foundation

/// The common interface for record structs in the AT Protocol.
///
/// This enables variadic polymorphic handing of different record by providing a uniform way to decode and identify
/// record types using their Namespaced Identifier (NSID).
///
/// - Note: For performance reasons, It's strongly recommended to create your record as a `struct` instead of a `class`.
/// All documentation in ATProtoKit will assume that all of the record objects are `struct`s.
///
/// To create a record, you'll need to make a `public` `struct` that conforms to this `protocol`:
/// ```swift
/// public struct UserProfile {
///     public let type = "com.example.actor.profile"
///     public let userID: Int
///     public let username: String
///     public var bio: String?
///     public var avatarURL: URL?
///     public var followerCount: Int?
///     public var followingCount: Int?
/// }
/// ```
/// You must create a `CodingKeys` `enum` that is of types `String` and `CodingKey`. This is because the `type` property
/// needs to map to the `$type` property in the lexicon.
/// ```swift
/// enum CodingKeys: String, CodingKeys {
///     case type = "$type"
///     // Additional cases...
/// }
/// ```
///
/// The `init()`, `init(from decoder: Decoder) throws`, and `func encode(to encoder: Encoder) throws`
/// methods do not need to be implemented, but it's reccommended to do so if custom implementations are needed.
///
/// - Warning: All record types _must_ conform to this protocol. ATProtoKit will not be able to hold onto any `struct`s that don't conform to this protocol.
public protocol ATRecordProtocol: Codable {
    /// The Namespaced Identifier (NSID) of the record.
    var type: String { get }
    /// Creates a new instance by decoding from the given decoder.
    ///
    /// This initializer mirrors the one from `Decodable`, but is needed to help make the polymorphic
    /// decoding work.
    /// - Parameter decoder: The decoder to read data from.
    /// - Throws: An error is thrown if reading from the decoder fails, or if the data
    /// read is corrupted or otherwise invalid.
    init(from decoder: Decoder) throws
}

/// A registry for all decodable record types in the AT Protocol.
///
/// All record lexicon `struct`s (whether from Bluesky or user created) will be included in the registry.
/// This is used as a map for `UnknownType` to find the most appropriate type that the JSON object
/// will fit into.
public struct ATRecordTypeRegistry {
    /// The registry itself.
    ///
    /// Stores a mapping from NSID strings to corresponding record types.
    /// This contains a `Dictionary`, which contains the value of the `$type` property in the
    /// lexicon (which is used as the "key"), and the ``ATRecordProtocol``-conforming `struct`s
    /// (which is used as the "value"). `UnknownType` will search for the key that matches with
    /// the JSON object's `$type` property, and then decode or encode the JSON object using the
    /// `struct` that was found if there's a match.
    static var recordRegistry = [String: ATRecordProtocol.Type]()

    /// Initializes the registry with an array of record types.
    /// - Parameter types: An array of ``ATRecordProtocol``-conforming `struct`s.
    public init(types: [ATRecordProtocol.Type]) {
        for type in types {
            ATRecordTypeRegistry.recordRegistry[String(describing: type)] = type
        }
    }

    /// Attempts to create an instance of a record type based on the provided NSID string and decoder.
    ///
    /// While `Codable` allows for polymorphic handling via `enum`s, it has a limitation where it
    /// can't directly decode or encode `protocol`s. This method circumvents this limitation by
    /// decoding the object directly and returning the result. To `Codable`, this is not a
    /// `protocol`, but a normal object.
    ///
    /// - Parameters:
    ///   - type: The Namespaced Identifier (NSID) of the record.
    ///   - decoder: The decoder to read data from.
    /// - Returns: A
    /// - Throws: An error can occur if one if the following happens:\
    ///     \- reading from the decoder fails\
    ///     \- the data read is corrupted or otherwise invalid
    ///     \- no object key in `recordRegistry` matches the `$type`'s value.
    public static func createInstance(ofType type: String, from decoder: Decoder) throws -> ATRecordProtocol? {
        guard let typeClass = recordRegistry[type] else { return nil }
        return try typeClass.init(from: decoder)
    }
}

public struct UnknownType: Codable {}
