//
//  DateFormatting.swift
//  
//
//  Created by Christopher Jr Riley on 2024-01-25.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

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

// TODO: Move date format decode/encode methods to KeyedDecodingContainer
extension KeyedDecodingContainer {

    /// Decodes a non-optional date string using the provided `CustomDateFormatter`.
    ///
    /// This is used as a replacement of `decode(_:forKey:)` specifically for `Date` objects.
    ///
    /// - Parameter key: The key associated with the date string.
    /// - Returns: A `Date` object if decoding is successful.
    /// - Throws: `DecodingError` if the key is missing or the value is invalid.
    public func decodeDate(forKey key: Key) throws -> Date {
        let dateString = try self.decode(String.self, forKey: key)
        guard let date = CustomDateFormatter.shared.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(forKey: key, in: self, debugDescription: "Invalid date format: \(dateString)")
        }
        return date
    }

    /// Converts an ISO8601-formatted date string (if it exists) and converts it to a `Date?` object.
    ///
    /// This is used as a replacement of `decodeIfPresent(_:forKey:)` specifically for `Date?` objects.
    ///
    /// - Parameter key: The key associated with the date string.
    /// - Returns: A `Date?` object if decoding is successful or `nil` if the date is absent or invalid.
    /// - Throws: `DecodingError` if the key is present and the value is not a valid date.
    public func decodeDateIfPresent(forKey key: Key) throws -> Date? {
        if let dateString = try self.decodeIfPresent(String.self, forKey: key) {
            guard let date = CustomDateFormatter.shared.date(from: dateString) else {
                throw DecodingError.dataCorruptedError(forKey: key, in: self, debugDescription: "Invalid date format: \(dateString)")
            }
            return date
        }
        return nil
    }
}

extension KeyedEncodingContainer {

    /// Encodes a `Date` value to its string representation and converts it to its ISO8601 format.
    ///
    /// This is used as a replacement of `encode(_:forKey:)` specifically for `Date` objects.
    ///
    /// - Parameters:
    ///   - date: The `Date` object to encode.
    ///   - key: The key associated with the encoded date.
    /// - Throws: `EncodingError` if the date cannot be encoded.
    public mutating func encodeDate(_ date: Date, forKey key: Key) throws {
        if let dateString = CustomDateFormatter.shared.string(from: date) {
            try self.encode(dateString, forKey: key)
        } else {
            throw EncodingError.invalidValue(date, EncodingError.Context(codingPath: self.codingPath, debugDescription: "Invalid date value"))
        }
    }

    /// Encodes a `Date?` value to its string representation (if the value exists) and converts it to
    /// its ISO8601 format.
    ///
    /// This is used as a replacement of `encodeIfPresent(_:forKey:)` specifically for
    /// `Date?` objects.
    ///
    /// - Parameters:
    ///   - date: The optional `Date` object to encode.
    ///   - key: The key associated with the encoded date.
    /// - Throws: `EncodingError` if the date cannot be encoded.
    public mutating func encodeDateIfPresent(_ date: Date?, forKey key: Key) throws {
        if let date = date {
            if let dateString = CustomDateFormatter.shared.string(from: date) {
                try self.encode(dateString, forKey: key)
            } else {
                throw EncodingError.invalidValue(date, EncodingError.Context(codingPath: self.codingPath, debugDescription: "Invalid date value"))
            }
        }
    }
}
