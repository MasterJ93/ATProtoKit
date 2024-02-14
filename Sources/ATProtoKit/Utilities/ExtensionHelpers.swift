//
//  ExtensionHelpers.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-12.
//

import Foundation

// MARK: - String Extension
extension String: Truncatable {
    /// Truncates the `String` to a certain length.
    ///
    /// In the AT Protocol, certain fields can only have a maximum of a certain number of "graphenes," which is a group of
    /// characters treated as one. In order to help prevent crashes, `ATProtoKit` will truncate a `String` to the maximum
    /// number of graphenes. However, we will still call them "characters" since this is the more understood term.
    /// - Parameter length: The maximum number of characters that the `String` can have before it truncates.
    /// - Returns: A new `String` that contains the maximum number of characters or less.
    func truncated(toLength length: Int) -> String {
        return String(self.prefix(length))
    }
}

// MARK: - Array Extension
extension Array: Truncatable {
    /// /// Truncates the number of items in an `Array` to a certain length.
    ///
    /// In the AT Protocol, certain fields can only have a maximum of items in their `Array`. In order to help prevent crashes,
    /// `ATProtoKit` will truncate an`Array` to the maximum number of items.
    /// - Parameter length: The maximum number of items that an `Array` can have before it truncates.
    /// - Returns: A new `Array` that contains the maximum number of items or less.
    func truncated(toLength length: Int) -> Array<Element> {
        return Array(self.prefix(length))
    }
}

// MARK: Encodable Extension
extension Encodable {
    /// Converts an object into a JSON object.
    ///
    /// - Returns: A JSON object.
    func toJsonData() throws -> Data? {
        return try JSONEncoder().encode(self)
    }
}
