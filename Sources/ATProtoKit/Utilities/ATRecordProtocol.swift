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
/// record types using their Namespaced Identifier (NSID). `ATRecordProtocol` conforms to
/// `Codable`; all `Codable`-related features still apply to this `protocol`.
///
///
/// - Note: For performance reasons, It's strongly recommended to create your record as a `struct`
/// instead of a `class`. All documentation in ATProtoKit will assume that all of the record
/// objects are `struct`s.
///
/// To create a record, you'll need to make a `public` `struct` that conforms to this `protocol`.
/// The `type` property must be `public` and `static` due to the `protocol`, but it shouldn't
/// be changed for the entire lifetime of the `struct`. One way to solve this is to use a
/// `private(set)` keyword:
/// ```swift
/// public struct UserProfile: ATRecordProtocol {
///     public static private(set) var type = "com.example.actor.profile" // `private(set)` used here.
///     public let userID: Int
///     public let username: String
///     public var bio: String?
///     public var avatarURL: URL?
///     public var followerCount: Int?
///     public var followingCount: Int?
/// }
/// ```
/// 
/// You must create a `CodingKeys` `enum` that is of types `String` and `CodingKey`. This is
/// because the `type` property needs to map to the `$type` property in the lexicon.
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
    static var type: String { get }
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
/// This is used as a map for ``UnknownType`` to find the most appropriate type that the JSON object
/// will fit into.
public struct ATRecordTypeRegistry {
    /// The registry itself.
    ///
    /// Stores a mapping from NSID strings to corresponding record types.
    /// This contains a `Dictionary`, which contains the value of the `$type` property in the
    /// lexicon (which is used as the "key"), and the ``ATRecordProtocol``-conforming `struct`s
    /// (which is used as the "value"). ``UnknownType`` will search for the key that matches with
    /// the JSON object's `$type` property, and then decode or encode the JSON object using the
    /// `struct` that was found if there's a match.
    public static var recordRegistry = [String: ATRecordProtocol.Type]()

    /// Initializes the registry with an array of record types.
    /// - Parameter types: An array of ``ATRecordProtocol``-conforming `struct`s.
    public init(types: [ATRecordProtocol.Type]) {
        for type in types {
            ATRecordTypeRegistry.recordRegistry[String(describing: type.type)] = type
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

/// Handles decoding and encoding of records when their type is not known ahead of type.
///
/// This supports either the instantiation of registered record types or fallback to a dictionary
/// representation.
///
/// Within the ``ATRecordProtocol``-conforming `struct`, any properties that are of type
/// `unknown` as dictated by the lexicon the `struct`conforms to _must_ of this type. For example,
/// here's the basic structure for ``ATNotification``:
/// ```swift
/// public struct ATNotification: Codable {
///     public let notificationURI: String
///     public let notificationCID: String
///     public let notificationAuthor: String
///     public let notificationReason: Reason
///     public let reasonSubjectURI: String?
///     public let record: UnknownType // Records will be stored here.
///     public let isRead: Bool
///     @DateFormatting public var indexedAt: Date
///     public let labels: [Label]?
/// }
/// ```
/// 
/// As shown above, the `records` property is of type `UnknownType`. By adding this, any `struct`s
/// within the dictionary of ``ATRecordTypeRegistry/recordRegistry``  can be used to potentially
/// decode and encode the JSON object.
public enum UnknownType: Codable {
    /// Represents a decoded ``ATRecordProtocol``-conforming `struct`.
    case record(ATRecordProtocol)
    /// Represents an unknown type.
    ///
    /// When this is used, the JSON object is converted to `[String: Any]` object. It's your
    /// responsibility to handle this properly.
    case unknown([String: Any])

    /// Initializes `UnknownType` by attempting to decode a known record type or falling back
    /// to a raw dictionary.
    ///
    /// (Inherited from `Decoder`.)
    ///
    /// - Parameter decoder: The decoder to read data from.
    /// - Throws: an error can occur if the following happens:\
    ///     \- reading from the decoder fails\
    ///     \- the data read is corrupted or otherwise invalid\
    ///     \- the decoder is unable to find the `$type` property\
    ///     \- the JSON object is invalid
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)

        guard let typeKey = DynamicCodingKeys(stringValue: "$type") else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "Cannot create key for `$type`."))
        }

        print("Record $type: \(typeKey)")
        let typeIdentifier = try container.decode(String.self, forKey: typeKey)
        print("typeIdentifier: \(typeIdentifier)")

        if let recordType = try? ATRecordTypeRegistry.createInstance(ofType: typeIdentifier, from: decoder) {
            print("It passed; so why is it not working?")
            self = .record(recordType)
        } else {
            let jsonData = try decoder.singleValueContainer().decode(Data.self)
            if let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                self = .unknown(jsonDict)
            } else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription: "Failed to decode unknown type as [String: Any]."))
            }
        }
    }

    /// Encodes this instance into the given encoder.
    ///
    /// Inherited from `Encoder`.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
            case .record(let record):
                try container.encode(record)
            case .unknown(let unknownData):
                let jsonData = try JSONSerialization.data(withJSONObject: unknownData, options: [])
                try container.encode(jsonData)
        }
    }

    /// Aids in decoding by allowing dynamic key lookup.
    private struct DynamicCodingKeys: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        // `Int` will never be used here.
        var intValue: Int?
        init?(intValue: Int) {
            return nil
        }
    }
}
