//
//  DateFormatting.swift
//  
//
//  Created by Christopher Jr Riley on 2024-01-25.
//

import Foundation

/// A structure for custom date formatting to and from the ISO8601 format.
public struct CustomDateFormatter: Sendable {

    /// A shared, singleton instance for global access.
    static let shared = CustomDateFormatter()

    /// An array of date formatters for various supported formats.
    private let dateFormatters: [DateFormatter]

    /// A private initializer to enforce singleton usage.
    private init() {
        let formats = [
            "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX",        // preferred
            "yyyy-MM-dd'T'HH:mm:ss.SSSSSSXXXXX",
            "yyyy-MM-dd'T'HH:mm:ss.SSS",
            "yyyy-MM-dd'T'HH:mm:ss.SSSSSS",
            "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSSSSXXXXX", // supported
            "yyyy-MM-dd'T'HH:mm:ssXXXXX",
            "yyyy-MM-dd'T'HH:mm:ss.SXXXXX",
            "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        ]

        dateFormatters = formats.map { format in
            let formatter = DateFormatter()
            formatter.dateFormat = format
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            return formatter
        }
    }

    /// Converts a `Date` object to a `String` representation.
    /// - Parameter date: The `Date` object to format.
    /// - Returns: A `String` representation of the given `Date` object, or `nil` if the conversion fails.
    func string(from date: Date) -> String? {
        return dateFormatters.first?.string(from: date)
    }

    /// Parses a string into a `Date` object according to the ISO8601 format.
    /// - Parameter string: The string representation of the date.
    /// - Returns: A `Date` object if the string can be successfully parsed, otherwise `nil`.
    func date(from string: String) -> Date? {
        for formatter in dateFormatters {
            if let date = formatter.date(from: string) {
                return date
            }
        }
        return nil
    }
}

/// Decodes a non-optional date string using the provided `CustomDateFormatter`.
///
/// This is used as a replacement of `decode(_:forKey:)` specifically for `Date` objects.
///
/// - Parameters:
///   - container: The keyed decoding container.
///   - key: The key associated with the date string.
/// - Returns: A `Date` object if decoding is successful.
/// - Throws: `DecodingError` if the key is missing or the value is invalid.
public func decodeDate<T: CodingKey>(from container: KeyedDecodingContainer<T>, forKey key: T) throws -> Date {
    let dateString = try container.decode(String.self, forKey: key)
    guard let date = CustomDateFormatter.shared.date(from: dateString) else {
        throw DecodingError.dataCorruptedError(forKey: key, in: container, debugDescription: "Invalid date format: \(dateString)")
    }
    return date
}

/// Converts an ISO8601-formatted date string (if it exists) and converts it to a `Date?` object.
///
/// This is used as a replacement of `decodeIfPresent(_:forKey:)` specifically for `Date?` objects.
///
/// - Parameters:
///   - container: The keyed decoding container.
///   - key: The key associated with the date string.
/// - Returns: A `Date?` if decoding is successful, or `nil` if the date is absent or invalid.
/// - Throws: `DecodingError` if the key is present and the value is not a valid date.
public func decodeDateIfPresent<T: CodingKey>(from container: KeyedDecodingContainer<T>, forKey key: T) throws -> Date? {
    if let dateString = try container.decodeIfPresent(String.self, forKey: key) {
        guard let date = CustomDateFormatter.shared.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(forKey: key, in: container, debugDescription: "Invalid date format: \(dateString)")
        }
        return date
    }
    return nil
}

/// Encodes a `Date` value to its string representation and converts it to its ISO8601 format.
///
/// This is used as a replacement of `encode(_:forKey:)` specifically for `Date` objects.
///
/// - Parameters:
///   - date: The `Date` object to encode.
///   - container: The keyed encoding container.
///   - key: The key associated with the encoded date.
/// - Throws: `EncodingError` if the date cannot be encoded.
public func encodeDate<T: CodingKey>(_ date: Date?, with container: inout KeyedEncodingContainer<T>, forKey key: T) throws {
    if let date = date {
        if let dateString = CustomDateFormatter.shared.string(from: date) {
            try container.encode(dateString, forKey: key)
        } else {
            throw EncodingError.invalidValue(date, EncodingError.Context(codingPath: container.codingPath, debugDescription: "Invalid date value"))
        }
    }
}

/// Encodes a `Date?` value to its string representation (if the value exists) and converts it to
/// its ISO8601 format.
///
/// This is used as a replacement of `encodeIfPresent(_:forKey:)` specifically for `Date?` objects.
///
/// - Parameters:
///   - date: The optional `Date` object to encode.
///   - container: The keyed encoding container.
///   - key: The key associated with the encoded date.
/// - Throws: `EncodingError` if the date cannot be encoded.
public func encodeDateIfPresent<T: CodingKey>(_ date: Date?, with container: inout KeyedEncodingContainer<T>, forKey key: T) throws {
    if let date = date {
        if let dateString = CustomDateFormatter.shared.string(from: date) {
            try container.encode(dateString, forKey: key)
        } else {
            throw EncodingError.invalidValue(date, EncodingError.Context(codingPath: container.codingPath, debugDescription: "Invalid date value"))
        }
    }
}

// MARK: Deprecated property wrappers -
/// A property wrapper for encoding and decoding `Date` objects with the ISO8601 format.
///
/// When using `@DateFormatting`, you first need to add it to a `Date` property. It must be of type
/// `var` and can't be an optional `Date`:
/// ```swift
/// @DateFormatting public var indexedAt: Date
/// ```
///
/// In `init()`, instead of initializing the property the standard way, you need to set the value
/// of `wrappedValue` to an underscored (`_`) version of the name of the property.:
/// ```swift
/// // Incorrect method
/// self.indexedAt = indexedAt
///
/// // Correct method
/// self._indexedAt = DateFormatting(wrappedValue: indexedAt)
/// ```
///
/// In `init(from decoder: Decoder) throws`, attempt to to decode each `Date` property using
/// `@DateFormatting`'s `wrappedValue`:
/// ```swift
/// public init(from decoder: Decoder) throws {
///     let container = try decoder.container(keyedBy: CodingKeys.self)
///
///     self.indexedAt = try container.decode(DateFormatting.self, forKey: .indexedAt).wrappedValue
/// }
/// ```
///
/// Finally, for `encode(to encoder: Encoder)`, ensure that each `Date` property wrapped with
/// `@DateFormatting` is encoded using the custom encoding logic defined in the `DateFormatting`
/// wrapper, using the underscored (`_`) version of the name of the property.:
/// ```swift
/// public func encode(to encoder: Encoder) throws {
///     var container = encoder.container(keyedBy: CodingKeys.self)
///
///     try container.encode(self._indexedAt, forKey: .indexedAt)
/// }
/// ```
@available(*, deprecated, message: "Use encodeDate(from:) instead.")
@propertyWrapper
public struct DateFormatting: Sendable, Codable {

    /// The actual `Date` value being wrapped.
    public var wrappedValue: Date {
        get {
            value
        }
        set {
            value = newValue
        }
    }

    /// A private pproperty that stores the `wrappedValue`'s value. Optional.
    private var value: Date

    /// Initializes the property with a `Date` value.
    public init(wrappedValue: Date) {
        self.value = wrappedValue
    }

    /// Decodes a `Date` object from a `String` using the `CustomDateFormatter`.
    ///
    /// - Throws: If the date string does not match the expected format.
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        let dateString = try container.decode(String.self)
        guard let date = CustomDateFormatter.shared.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Date string does not match format expected by formatter.")
        }
        self.value = date
    }

    /// Encodes the `Date` object to a `String` using the `CustomDateFormatter`.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        let dateString = CustomDateFormatter.shared.string(from: wrappedValue)
        try container.encode(dateString)
    }
}

// TODO: Find a way to merge `DateFormattingOptional` with `DateFormatting` in order to remove duplicated code.
/// A property wrapper for optionally encoding and decoding `Date?` objects with the
/// ISO8601 format.
///
/// When using `@DateFormattingOptional`, you first need to add it to a `Date?` property:
/// ```swift
/// @DateFormattingOptional public var indexedAt: Date?
/// ```
///
/// In `init()`, instead of initializing the property the standard way, you need to set the value
/// of `wrappedValue` to an underscored (`_`) version of the name of the property.:
/// ```swift
/// // Incorrect method
/// self.indexedAt = indexedAt
///
/// // Correct method
/// self._indexedAt = DateFormattingOptional(wrappedValue: indexedAt)
/// ```
///
/// In `init(from decoder: Decoder) throws`, attempt to to decode each `Date` property using
/// `@DateFormattingOptional`'s `wrappedValue`:
/// ```swift
/// public init(from decoder: Decoder) throws {
///     let container = try decoder.container(keyedBy: CodingKeys.self)
///
///     self.indexedAt = try container.decodeIfPresent(DateFormattingOptional.self, forKey: .indexedAt)?.wrappedValue
/// }
/// ```
///
/// Finally, for `encode(to encoder: Encoder)`, ensure that each `Date` property wrapped with
/// `@DateFormattingOptional` is encoded using the custom encoding logic defined in the
/// `DateFormattingOptional` wrapper, using the underscored (`_`) version of the name of
/// the property:
/// ```swift
/// public func encode(to encoder: Encoder) throws {
///     var container = encoder.container(keyedBy: CodingKeys.self)
///
///     try container.encodeIfPresent(self._indexedAt, forKey: .indexedAt)
/// }
/// ```
@available(*, deprecated, message: "Use encodeDateIfPresent(from:) instead.")
@propertyWrapper
public struct DateFormattingOptional: Sendable, Codable {

    /// The optional `Date?` value being wrapped.
    public var wrappedValue: Date? {
        get {
            value
        }
        set {
            value = newValue
        }
    }

    /// A private pproperty that stores the `wrappedValue`'s value. Optional.
    private var value: Date?

    /// Initializes the property with an optional `Date?` value.
    public init(wrappedValue: Date?) {
        self.value = wrappedValue
    }

    /// Decodes an optional `Date?` object from a `String` using the `CustomDateFormatter`.
    /// 
    /// - Throws: If decoding fails or the value is `nil`, sets `wrappedValue` to `nil`.
    public init(from decoder: Decoder) throws {
        let container = try? decoder.singleValueContainer()

        if let dateString = try? container?.decode(String.self),
           let date = CustomDateFormatter.shared.date(from: dateString) {
            self.value = date
        } else {
            self.value = nil
        }
    }

    /// Encodes the optional `Date?` object to a `String` using the `CustomDateFormatter`,
    /// or encodes `nil`
    /// if `wrappedValue` is `nil`.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        if let date = value, let dateString = CustomDateFormatter.shared.string(from: date) {
            try container.encode(dateString)
        } else {
            try container.encodeNil()
        }
    }
}
