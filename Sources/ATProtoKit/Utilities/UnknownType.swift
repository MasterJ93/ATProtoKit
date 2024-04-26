//
//  UnknownType.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-25.
//

import Foundation

/// The common interface for record structs in the AT Protocol.
///
/// This enables cariadic polymorphic handing of different record by providing a uniform way to decode and identify
/// record types using their Namespaced Identifier (NSID).
///
/// - Note: For performance reasons, It's strongly recommended to create your record as a `struct` instead of a `class`.
///
/// To create a record, you'll need to make a `public` `struct` that conforms to `ATRecordProtocol`:
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
    init(from decoder: Decoder) throws
}

public struct UnknownType: Codable {}
