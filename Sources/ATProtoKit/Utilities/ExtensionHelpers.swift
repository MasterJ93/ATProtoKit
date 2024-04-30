//
//  ExtensionHelpers.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-12.
//

import Foundation
//#if canImport(os)
//import Logging
//import os.log
//#endif

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

    /// Transforms a string into one with a limited selection of characters.
    ///
    /// Only the English alphabet in lowercase and the standard hyphen (-) are allowed to be used. Any uppercased characters will be lowercased.
    /// Any characters that could be interpreted as hypens will be converted into standard hyphens. Any additional characters will be discarded.
    func transformToLowerASCIIAndHyphen() -> String {
        // Trim trailing spaces.
        let trimmedString = self.trimmingCharacters(in: .whitespacesAndNewlines)

        // Convert to lowercase.
        let lowercasedString = trimmedString.lowercased()

        // Define a set of Unicode scalars that represent various hyphen-like characters.
        let hyphenLikeScalars: [UnicodeScalar] = [
            "\u{2010}", // Hyphen
            "\u{2011}", // Non-breaking hyphen
            "\u{2012}", // Figure dash
            "\u{2013}", // En dash
            "\u{2014}", // Em dash
            "\u{2015}", // Horizontal bar
            "\u{2043}", // Hyphen bullet
            "\u{2053}", // Swung dash
            "\u{2212}", // Minus sign
            "\u{2E3A}", // Two-em dash
            "\u{2E3B}", // Three-em dash
            "\u{FE58}", // Small em dash
            "\u{FE63}", // Small hyphen-minus
            "\u{FF0D}"  // Full-width hyphen-minus
        ]
        let hyphenLikeCharacters = CharacterSet(hyphenLikeScalars)

        // Replace spaces and hyphen-like characters with standard hyphens.
        let withHyphens = lowercasedString.unicodeScalars.map { scalar in
                if CharacterSet.whitespaces.contains(scalar) || hyphenLikeCharacters.contains(scalar) {
                    return "-"
                } else {
                    return String(scalar)
                }
            }
            .joined()

        // Define allowed characters: letters and hyphen.
        let allowedCharacters = CharacterSet.letters.union(CharacterSet(charactersIn: "-"))

        // Filter the string to remove characters not in the allowed set.
        let filteredString = withHyphens.unicodeScalars.filter { allowedCharacters.contains($0) }.map(String.init).joined()

        return filteredString
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

// MARK: - Encodable Extension
extension Encodable {
    /// Converts an object into a JSON object.
    ///
    /// - Returns: A JSON object.
    func toJsonData() throws -> Data? {
        return try JSONEncoder().encode(self)
    }
}

// MARK: - UInt64 Extension
extension UInt64 {
    /// Converts a `UInt64` to a Base32-sortable string, according to the
    /// AT Protocol specifications.
    ///
    /// According to the (specifications)[atproto], a `base32-sortable` integer is encoded with
    /// the characters `234567abcdefghijklmnopqrstuvwxyz` and is 13 characters in length.
    ///
    /// - Returns: A `String` that's encoded in a Base32-sortable format.
    func toBase32Sortable() -> String {
        let base32Characters = "234567abcdefghijklmnopqrstuvwxyz"
        var number = self
        var encoded = ""

        for _ in 0..<13 {
            let index = Int(number & 31) // Get the last 5 bits
            let character = Array(base32Characters)[index]
            encoded = String(character) + encoded
            number >>= 5
        }

        return encoded
    }
}

//// MARK: - Logging.Logger Extension
//#if canImport(os)
//extension Logging.Logger {
//    enum PrivacyAwareMetadataValue {
//        case string(String, OSLogPrivacy)
//        case stringConvertible(CustomStringConvertible, OSLogPrivacy)
//
//        var privacy: OSLogPrivacy {
//            switch self {
//                case .string(_, let privacy), .stringConvertible(_, let privacy):
//                    return privacy
//            }
//        }
//
//        var value: String {
//            switch self {
//                case .string(let value, _):
//                    return value
//                case .stringConvertible(let value, _):
//                    return value.description
//            }
//        }
//    }
//}
//#endif
//
//// MARK: - DefaultStringInterpolation Extension
//extension DefaultStringInterpolation {
//    mutating func appendInterpolation(_ message: OSLogMessage) {
//        #if canImport(os)
//        appendInterpolation(value)
//        appendLiteral("")
//        #else
//        appendLiteral(value)
//        #endif
//    }
//
//    private mutating func wrapMessage(_ value: OSLogMessage) {
//        appendInterpolation(<#T##OSLogMessage#>)
//    }
//}
