//
//  ATRecordProtocol.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-25.
//

import Foundation

/// The common interface for record structs in the AT Protocol.
///
/// This enables variadic polymorphic handing of different records by providing a uniform
/// way to decode and identify record types using their Namespaced Identifier (NSID).
/// `ATRecordProtocol` conforms to `Codable`; all `Codable`-related features still
/// apply to this `protocol`.
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
/// The `init()`, `init(from decoder: Decoder) throws`, and
/// `func encode(to encoder: Encoder) throws` methods do not need to be implemented, but it's
/// reccommended to do so if custom implementations are needed.
///
/// - Warning: All record types _must_ conform to this protocol. ATProtoKit will not be able to
/// hold onto any `struct`s that don't conform to this protocol.
public protocol ATRecordProtocol: Sendable, Codable, Equatable, Hashable {

    /// The Namespaced Identifier (NSID) of the record.
    static var type: String { get }

    /// Creates a new instance by decoding from the given decoder.
    ///
    /// This initializer mirrors the one from `Decodable`, but is needed to help make the
    /// polymorphic decoding work.
    /// - Parameter decoder: The decoder to read data from.
    ///
    /// - Throws: An error is thrown if reading from the decoder fails, or if the data
    /// read is corrupted or otherwise invalid.
    init(from decoder: Decoder) throws
}

/// A configuration protocol for managing record lexicons.
public protocol ATRecordConfiguration {

    /// An array of record lexicon structs created by Bluesky.
    ///
    /// If `canUseBlueskyRecords` is set to `false`, these will not be used.
    var recordLexicons: [any ATRecordProtocol.Type] { get }

    /// Internal state to track the process of adding records to ``ATRecordConfiguration``.
    var initializationTask: Task<Void, Error>? { get }

    /// A method for setting the process of adding records to ``ATRecordTypeRegistry``.
    func checkInitialization() async throws
}

extension ATRecordConfiguration {

    public func checkInitialization() async throws {
        if let task = initializationTask {
            try await task.value
        }
    }
}

/// A registry for all decodable record types in the AT Protocol.
///
/// All record lexicon `struct`s (whether from Bluesky or user created) will be included in
/// the registry. This is used as a map for ``UnknownType`` to find the most appropriate type
/// that the JSON object will fit into.
///
/// This registry is managed by an `actor`, ensuring concurrency-safe access to its internal
/// data. Because of this, most interactions with `ATRecordTypeRegistry` must be done
/// asynchronously using `await`.
///
/// When adding a record, you need to type `.self` at the end.
/// ```swift
/// Task {
///     _ = await ATRecordTypeRegistry.shared.register(types: [UserProfile.self])
/// }
/// ```
///
/// - Important: Make sure you don't add the same `struct` multiple times.
///
/// - Warning: All record types _must_ conform to ``ATRecordProtocol``. Failure to do so may
/// result in an error.
///
/// # Waiting For the Registry To Be Ready
///
/// If you need to ensure that the registry is ready to be read. In order to do this, you should
/// use ``ATRecordTypeRegistry/waitUntilRegistryIsRead()`` in the function. This prevents the
/// function from continuing until the registry is ready to be used.
///
/// - Note: ``ATRecordTypeRegistry/waitUntilRegistryIsRead()`` only works in functions that
/// are `async`.
public actor ATRecordTypeRegistry {

    /// The shared instance of `ATRecordTypeRegistry`.
    public static let shared = ATRecordTypeRegistry()

    /// A private dispatch queue for the registry.
    private let registryQueue = DispatchQueue(label: "com.cjrriley.ATProtoKit.ATRecordTypeRegistryQueue")

    /// A private property of ``recordRegistry``.
    private(set) static var _recordRegistry: [String: any ATRecordProtocol.Type] = [:]

    /// The registry itself.
    ///
    /// Stores a mapping from Namespaced Identifier (NSID) strings to corresponding record types.
    ///
    /// This contains a `Dictionary`, which contains the value of the `$type` property in the
    /// lexicon (which is used as the "key"), and the ``ATRecordProtocol``-conforming `struct`s
    /// (which is used as the "value"). ``UnknownType`` will search for the key that matches with
    /// the JSON object's `$type` property, and then decode or encode the JSON object using the
    /// `struct` that was found if there's a match.
    public static var recordRegistry: [String: any ATRecordProtocol.Type] {
        get {
            return self.shared.registryQueue.sync {
                Self._recordRegistry
            }
        }
    }

    /// Indicates whether any Bluesky-related `ATRecordProtocol`-conforming `struct`s have been
    /// added to ``recordRegistry``. Defaults to `false`.
    ///
    /// - Warning: Don't touch this property; this should only be used for ``ATProtoKit``.
    public private(set) static var areBlueskyRecordsRegistered = false

    /// Tracks whether the registry is currently being modified.
    public private(set) var isUpdating = false

    /// An array of continuations waiting for the registry to be ready.
    private var continuations: [CheckedContinuation<Void, Never>] = []

    private init() {}

    /// Registers an array of record types.
    ///
    /// - Parameter types: An array of ``ATRecordProtocol``-conforming `struct`s.
    public func register(types: [any ATRecordProtocol.Type]) async {
        self.isUpdating = true

        for type in types {
            let typeKey = type.type
            guard !self.isRegistered(typeKey) else {
                print("Record type '\(typeKey)' is already registered. Skipping.")
                continue
            }

            self.registryQueue.sync {
                Self._recordRegistry[typeKey] = type
            }
        }

        await endUpdating()
    }

    /// Registers an array of Bluesky record lexicon types.
    ///
    /// - Note: This must only be used for the main `ATProtoKit` `class` and only for
    /// Bluesky-specific record lexicon models.
    ///
    /// - Parameter blueskyLexiconTypes: An array of ``ATRecordProtocol``-conforming `struct`s.
    public func register(blueskyLexiconTypes: [any ATRecordProtocol.Type]) async {
        let alreadyRegistered = self.registryQueue.sync {
            Self.areBlueskyRecordsRegistered
        }

        guard !alreadyRegistered else { return }

        self.isUpdating = true

        for type in blueskyLexiconTypes {
            let typeKey = type.type
            guard !isRegistered(typeKey) else {
                print("Record type '\(typeKey)' is already registered. Skipping.")
                continue
            }

            self.registryQueue.sync {
                Self._recordRegistry[typeKey] = type
            }
        }

        self.registryQueue.sync {
            Self.areBlueskyRecordsRegistered = true
        }

        await endUpdating()
    }

    /// Indicates whether the specified lexicon `struct` type is registered
    /// inside ``recordRegistry``.
    ///
    /// - Parameter typeKey: The Namespaced Identifier (NSID) of the lexicon.
    /// - Returns: `true` if there is a `struct` that correspondences with the `typeKey` value, or
    /// `false` if not.
    public func isRegistered(_ typeKey: String) -> Bool {
        return self.registryQueue.sync { Self._recordRegistry[typeKey] != nil }
    }

    /// Sets ``areBlueskyRecordsRegistered`` to a `Bool` value.
    ///
    /// - Parameter value: The `Bool` value used to set the property.
    public static func setBlueskyRecordsRegistered(_ value: Bool) {
        self.shared.registryQueue.sync {
            Self.areBlueskyRecordsRegistered = value
        }
    }

    /// Halts the execution of code until ``recordRegistry`` is ready to be used.
    public func waitUntilRegistryIsRead() async {
        if isUpdating == false { return }

        await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
            continuations.append(continuation)
        }
    }

    /// Attempts to create an instance of a record type based on the provided NSID string
    /// and decoder.
    ///
    /// While `Codable` allows for polymorphic handling via `enum`s, it has a limitation where it
    /// can't directly decode or encode `protocol`s. This method circumvents this limitation by
    /// decoding the object directly and returning the result. To `Codable`, this is not a
    /// `protocol`, but a normal object.
    ///
    /// - Parameters:
    ///   - type: The Namespaced Identifier (NSID) of the record.
    ///   - decoder: The decoder to read data from.
    /// - Returns: A `struct` or `class`, which conforms to ``ATRecordProtocol``.
    ///
    /// - Throws: An error can occur if one if the following happens:\
    ///     \- reading from the decoder fails\
    ///     \- the data read is corrupted or otherwise invalid
    ///     \- no object key in `recordRegistry` matches the `$type`'s value.
    public static func createInstance(ofType type: String, from decoder: Decoder) throws -> (any ATRecordProtocol)? {
        guard let typeClass = self.getRecordType(for: type) else {
            return nil
        }

        // Instantiate the record from the decoder
        return try typeClass.init(from: decoder)
    }

    /// Retrieves a specific record type based on the Namespaced Identifier (NSID) of the record.
    /// 
    /// - Parameter type: The NSID string.
    /// - Returns: The ``ATRecordProtocol``-conforming type (if there's a match), or `nil`
    /// (if there isn't).
    public static func getRecordType(for type: String) -> (any ATRecordProtocol.Type)? {
        self.shared.registryQueue.sync {
            return ATRecordTypeRegistry.recordRegistry[type]
        }
    }

    /// Called when ``recordRegistry`` updates are completed.
    private func endUpdating() async {
        isUpdating = false

        for continuation in continuations {
            continuation.resume()
        }
        // Clear the waiting list.
        continuations.removeAll()
    }
}

/// Handles decoding and encoding of records when their type is not known ahead of type.
///
/// This supports either the instantiation of registered record types or fallback to a dictionary
/// representation.
///
/// Within the ``ATRecordProtocol``-conforming `struct`, any properties that are of type
/// `unknown` as dictated by the lexicon the `struct`conforms to _must_ of this type. For example,
/// here's the basic structure for ``AppBskyLexicon/Notification/Notification``:
/// ```swift
/// public struct Notification: Codable {
///     public let notificationURI: String
///     public let notificationCID: String
///     public let notificationAuthor: String
///     public let notificationReason: Reason
///     public let reasonSubjectURI: String?
///     public let record: UnknownType // Records will be stored here.
///     public let isRead: Bool
///     public var indexedAt: Date
///     public let labels: [Label]?
/// }
/// ```
/// 
/// As shown above, the `records` property is of type `UnknownType`. By adding this, any `struct`s
/// within the dictionary of ``ATRecordTypeRegistry/recordRegistry`` can be used to potentially
/// decode and encode the JSON object.
public enum UnknownType: Sendable, Codable {

    /// Represents a decoded ``ATRecordProtocol``-conforming `struct`.
    case record(any ATRecordProtocol)

    /// Represents an unknown type.
    ///
    /// When this is used, the JSON object is converted to `[String: Any]` object. It's your
    /// responsibility to handle this properly.
    case unknown([String: CodableValue])

    /// Initializes `UnknownType` by attempting to decode a known record type or falling back
    /// to a raw dictionary.
    ///
    /// (Inherited from `Decoder`.)
    ///
    /// - Parameter decoder: The decoder to read data from.
    ///
    /// - Throws: an error can occur if the following happens:\
    ///     \- reading from the decoder fails\
    ///     \- the data read is corrupted or otherwise invalid\
    ///     \- the decoder is unable to find the `$type` property\
    ///     \- the JSON object is invalid
    @_documentation(visibility: private)
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)

        if let typeKey = DynamicCodingKeys(stringValue: "$type"),
           let typeIdentifier = try container.decodeIfPresent(String.self, forKey: typeKey),
           let recordType = ATRecordTypeRegistry.recordRegistry[typeIdentifier] {
            let record = try recordType.init(from: decoder)
            self = .record(record)
        } else {
            do {
                let dictionary = try UnknownType.decodeNestedDictionary(container: container)
                self = .unknown(dictionary)
            } catch {
                print("Error decoding nested dictionary: \(error)")
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: container.codingPath,
                        debugDescription: "Failed to decode dictionary.",
                        underlyingError: error))
            }
        }
    }

    /// Attempts to retrieve a record of the specified type from an `UnknownType` instance.
    ///
    /// This is a convience method that handles the case checks. By using this, you can reference
    /// a specific property within a record with just one line.
    ///
    /// - Parameter type: An ``ATRecordProtocol``-conforming type.
    /// - Returns: An instance of the specified record type if the `UnknownType` contains a record
    /// of that type.
    public func getRecord<Record: ATRecordProtocol>(ofType type: Record.Type) -> Record? {
        guard case .record(let record as Record) = self else {
            return nil
        }

        return record
    }

    /// Converts the output into raw JSON data.
    ///
    /// - Returns: A `Data` object containing the raw JSON representation of the data. If there is
    /// no data in any of the cases, the method returns `nil`.
    public func toJSON() throws -> Data? {
        do {
            switch self {
                case let .record(record):
                    let encoder = JSONEncoder()
                    encoder.outputFormatting = [.prettyPrinted]

                    return try encoder.encode(record)
                case let .unknown(dictionary):
                    let encoder = JSONEncoder()
                    encoder.outputFormatting = [.prettyPrinted]

                    return try encoder.encode(dictionary)
            }
        } catch {
            return nil
        }
    }

    /// Converts the `UnknownType` into a `[String: CodableValue]`.
    ///
    /// If the instance is a `.record` case, then it will attempt to encode the record into
    /// a dictionary. Otherwise, it will simply return the stored dictionary.
    ///
    /// - Returns: A `[String: CodableValue]` version. of the instance.
    ///
    /// - Throws: An error if the conversion fails.
    public func asCodableValue() throws -> [String: CodableValue] {
        switch self {
            case .unknown(let dictionary):
                return dictionary
            case .record(let record):
                let data = try JSONEncoder().encode(record)
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                guard let dictionary = jsonObject as? [String: Any] else {
                    throw CodableValueConversionError.invalidRecordConversion
                }
                return try dictionary.mapValues { try CodableValue.fromAny($0) }
        }
    }

    /// Represents possible errors during conversion.
    public enum CodableValueConversionError: ATProtoError {

        /// The instance's `.record` case failed to convert.
        case invalidRecordConversion
    }

    /// Decodes a nested dictionary from an unknown JSON object.
    ///
    /// This is essential to decode truly unknown types.
    ///
    /// - Parameter container: The container that the JSON object resides in.
    /// - Returns: A `[String: Any]` object.
    ///
    /// - Throws: A `DecodingError` if there's a type mismatch.
    private static func decodeNestedDictionary(container: KeyedDecodingContainer<DynamicCodingKeys>) throws -> [String: CodableValue] {
        var dictionary = [String: CodableValue]()
        for key in container.allKeys {
            if let value = try? container.decode(Bool.self, forKey: key) {
                dictionary[key.stringValue] = .bool(value)
            } else if let value = try? container.decode(Int.self, forKey: key) {
                dictionary[key.stringValue] = .int(value)
            } else if let value = try? container.decode(Double.self, forKey: key) {
                dictionary[key.stringValue] = .double(value)
            } else if let value = try? container.decode(String.self, forKey: key) {
                dictionary[key.stringValue] = .string(value)
            } else if let nestedContainer = try? container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: key) {
                dictionary[key.stringValue] = .dictionary(try decodeNestedDictionary(container: nestedContainer))
            } else if let array = try? decodeArray(from: container, forKey: key) {
                dictionary[key.stringValue] = .array(array)
            } else {
                throw DecodingError.typeMismatch(
                    CodableValue.self,
                    DecodingError.Context(
                        codingPath: container.codingPath,
                        debugDescription: "Could not decode item at key \(key.stringValue)"))
            }
        }
        return dictionary
    }

    /// Decodes a nested array from an unknown JSON object.
    ///
    /// This is essential to decode truly unknown types.
    ///
    /// - Parameter container: The container that the JSON object resides in.
    /// - An `[Any]` object.
    /// 
    /// - Throws: A `DecodingError` if there's a type mismatch.
    private static func decodeArray(from container: KeyedDecodingContainer<DynamicCodingKeys>, forKey key: DynamicCodingKeys) throws -> [CodableValue] {
        var unkeyedContainer = try container.nestedUnkeyedContainer(forKey: key)
        var array = [CodableValue]()

        while !unkeyedContainer.isAtEnd {
            if let value = try? unkeyedContainer.decode(Bool.self) {
                array.append(.bool(value))
            } else if let value = try? unkeyedContainer.decode(Int.self) {
                array.append(.int(value))
            } else if let value = try? unkeyedContainer.decode(Double.self) {
                array.append(.double(value))
            } else if let value = try? unkeyedContainer.decode(String.self) {
                array.append(.string(value))
            } else if let nestedContainer = try? unkeyedContainer.nestedContainer(keyedBy: DynamicCodingKeys.self) {
                array.append(.dictionary(try decodeNestedDictionary(container: nestedContainer)))
            } else {
                throw DecodingError.dataCorruptedError(in: unkeyedContainer, debugDescription: "Could not decode array element.")
            }
        }
        return array
    }

    /// Encodes this instance into the given encoder.
    ///
    /// Inherited from `Encoder`.
    @_documentation(visibility: private)
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

extension UnknownType: Equatable {
    public static func == (lhs: UnknownType, rhs: UnknownType) -> Bool {
        do {
            // Convert both sides to CodableValue dictionaries
            let lhsValue = try lhs.asCodableValue()
            let rhsValue = try rhs.asCodableValue()
            return lhsValue == rhsValue
        } catch {
            // If conversion fails, consider them unequal
            return false
        }
    }
}

extension UnknownType: Hashable {
    public func hash(into hasher: inout Hasher) {
        do {
            // Convert the UnknownType instance to a CodableValue
            let codableValue = try self.asCodableValue()
            // Hash the CodableValue representation
            codableValue.hash(into: &hasher)
        } catch {
            // If conversion fails, hash a fallback value
            hasher.combine("UnknownTypeError")
        }
    }
}

/// A type-safe and thread-safe representation of JSON-compatible values, used for encoding and
/// decoding arbitrary JSON data.
public enum CodableValue: Codable, Sendable, Equatable, Hashable {

    /// Stores a `Bool` value.
    case bool(Bool)

    /// Stores an `Int` value.
    case int(Int)

    /// Stores a `Double` value.
    case double(Double)

    /// Stores a `String` value.
    case string(String)

    /// Stores an `Array` of `CodableValue` elements.
    case array([CodableValue])

    /// Stores a `Dictionary` with `String` keys and `CodableValue` values.
    case dictionary([String: CodableValue])

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let value = try? container.decode(Bool.self) {
            self = .bool(value)
        } else if let value = try? container.decode(Int.self) {
            self = .int(value)
        } else if let value = try? container.decode(Double.self) {
            self = .double(value)
        } else if let value = try? container.decode(String.self) {
            self = .string(value)
        } else if let value = try? container.decode([CodableValue].self) {
            self = .array(value)
        } else if let value = try? container.decode([String: CodableValue].self) {
            self = .dictionary(value)
        } else {
            throw DecodingError.typeMismatch(
                CodableValue.self,
                DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "Unsupported value"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
            case .bool(let value):
                try container.encode(value)
            case .int(let value):
                try container.encode(value)
            case .double(let value):
                try container.encode(value)
            case .string(let value):
                try container.encode(value)
            case .array(let value):
                try container.encode(value)
            case .dictionary(let value):
                try container.encode(value)
        }
    }

    /// Converts an `Any` type to a `CodableValue` type.
    ///
    /// - Parameter value: The value to convert.
    /// - Returns: A `CodableValue` value.
    ///
    /// - Throws: A `DecodingError` where the value was not supported.
    public static func fromAny(_ value: Any) throws -> CodableValue {
        switch value {
            case let boolValue as Bool:
                return .bool(boolValue)
            case let intValue as Int:
                return .int(intValue)
            case let doubleValue as Double:
                return .double(doubleValue)
            case let stringValue as String:
                return .string(stringValue)
            case let arrayValue as [Any]:
                let codableArray = try arrayValue.map { try CodableValue.fromAny($0) }
                return .array(codableArray)
            case let dictValue as [String: Any]:
                var codableDict = [String: CodableValue]()

                for (key, nestedValue) in dictValue {
                    codableDict[key] = try CodableValue.fromAny(nestedValue)
                }
                return .dictionary(codableDict)
            default:
                throw DecodingError.typeMismatch(
                    CodableValue.self,
                    DecodingError.Context(codingPath: [], debugDescription: "Unsupported value type \(type(of: value))")
                )
        }
    }
}
