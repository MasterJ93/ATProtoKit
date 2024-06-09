//
//  NSIDManager.swift
//  
//
//  Created by Christopher Jr Riley on 2024-06-07.
//

import Foundation

/// A class that identifies and validates Namespaced Identifiers (NSIDs).
public struct NSIDManager {

    /// An array of segments for the Namespaced Identifier (NSID).
    private var segments: [String] = []

    /// Returns the authority segment of the Namespaced Identifier (NSID).
    ///
    /// This will show the authority segment the same way you see a hostname. Example: instead of
    /// seeing `app.bsky`, the property will display `bsky.app`.
    public var authority: String {
        return Array(segments.prefix(2).reversed()).joined(separator: ".")
    }

    /// Returns the name segment of the Namespaced Identifier (NSID).
    public var name: String {
        return Array(segments.dropFirst(2)).joined(separator: ".")
    }

    /// Returns the subdomain segment of the Namespaced Identifier (NSID). Optional.
    ///
    /// If the NSID only has three segments, then the property will return `nil`.
    ///
    /// ```swift
    /// let nsidWithSubdomain = NSIDManager(nsid: app.bsky.feed.post)
    /// let nsidWithoutSubdomain = NSIDManager(nsid: app.bsky.feed)
    ///
    /// print(nsidWithSubdomain.subdomain)    // Returns "feed".
    /// print(nsidWithoutSubdomain.subdomain) // Returns nil.
    /// ```
    public var subdomain: String? {
        if segments.count > 3 {
            return segments[2]
        }

        return nil
    }

    /// Initializes the class and ensures the Namespaced Identifier (NSID) is valid.
    ///
    /// - Parameter nsid: The Namespaced Identifier (NSID) to validate.
    ///
    /// - Throws: An ``ATNSIDError``, indicating the NSID is invalid.
    public init(nsid: String) throws {
        try validate(nsid)
        self.segments = nsid.split(separator: ".").map(String.init)
    }

    /// Parses the given Namespaced Identifier (NSID) into different segments.
    ///
    /// - Parameter nsid: The NSID to parse.
    /// - Returns: An instance of ``NSIDManager``, containing a valid NSID split into segments.
    ///
    /// - Throws: An ``ATNSIDError``, indicating the NSID is invalid.
    public static func parse(_ nsid: String) throws -> NSIDManager {
        return try NSIDManager(nsid: nsid)
    }

    /// Creates a new Namespaced Identifier (NSID).
    ///
    /// - Parameters:
    ///   - authority: The domain authority segment of the NSID.
    ///   - name: The name segment of the NSID.
    /// - Returns: An instance of ``NSIDManager``, containing a valid NSID split into segments.
    ///
    /// - Throws: An ``ATNSIDError``, indicating the NSID is invalid.
    public static func create(authority: String, name: String) throws -> NSIDManager {
        var authorityArray = authority.split(separator: ".").map(String.init)
        authorityArray.append(name)

        let segments = authorityArray.joined(separator: ".")
        return try NSIDManager(nsid: segments)
    }

    /// Normalizes the Namespaced Identifier (NSID).
    ///
    /// - Parameter nsid: The NSID to be normalized.
    /// - Returns: The NSID with the domain authority segments normalized.
    ///
    /// - Throws: An ``ATNSIDError``, which indicates the NSID is not valid.
    public func normalize(_ nsid: String) -> String {
        _ = segments[0].lowercased()
        _ = segments[1].lowercased()

        return toString()
    }

    /// Indicates whether the Namespaced Identifier (NSID) is valid or not.
    ///
    /// - Parameter nsid: The Namespaced Identifier (NSID) to validate.
    /// - Returns: `true` if the NSID is valid, or `false` if it isn't.
    public static func isValid(nsid: String) -> Bool {
        do {
            _ = try NSIDManager.parse(nsid)
            return true
        } catch {
            return false
        }
    }

    /// Combines the segments into a `String`.
    ///
    /// - Returns: A fully constructed Namespaced Identifier (NSID).
    public func toString() -> String {
        return segments.joined(separator: ".")
    }

    /// Ensures the Namespaced Identifier (NSID) is valid.
    ///
    /// According to the AT Protocol, a valid NSID consists of two parts:
    /// 1. A valid domain name in reversed notation.
    /// 2. A period-separated name that is written in camel case.
    ///
    /// - Parameter nsid: The NSID to validate.
    ///
    /// - Throws: An ``ATNSIDError``, indicating the NSID is invalid.
    public func validate(_ nsid: String) throws {
        let toCheck = nsid

        // Check if all of the characters are ASCII.
        let asciiCheck = try Regex("^[a-zA-Z0-9.-]*$")
        guard toCheck.wholeMatch(of: asciiCheck) != nil else {
            throw ATNSIDError.disallowedASCIICharacters
        }

        guard toCheck.count <= 317 else {
            throw ATNSIDError.tooLong
        }

        let segments = toCheck.split(separator: ".").map(String.init)
        guard segments.count >= 3 else {
            throw ATNSIDError.notEnoughSegments
        }

        try segments.enumerated().forEach { index, segment in
            guard segment.count > 0 else {
                throw ATNSIDError.emptySegment
            }

            guard segment.count <= 63 else {
                throw ATNSIDError.segmentTooLong
            }

            guard !segment.hasPrefix("-"),
                  !segment.hasSuffix("-") else {
                throw ATNSIDError.hyphenFoundAtSegmentEnds
            }

            if index == 0 {
                guard segment.first?.isNumber == false else {
                    throw ATNSIDError.numberFoundinFirstSegment
                }
            }
        }

        let latinLetters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
        let nameSegment = Array(segments[2...]).joined(separator: ".")
        guard nameSegment.rangeOfCharacter(from: latinLetters.inverted) != nil else {
            throw ATNSIDError.nonLatinLetterFoundInNameSegment
        }
    }

    /// Ensures the Namespaced Identifier (NSID) is valid using a regular expression.
    ///
    /// This is similar to ``NSIDManager/validate(_:)``, but a regular expression is used for
    /// validation instead.
    ///
    /// According to the AT Protocol, a valid NSID consists of two parts:
    /// 1. A valid domain name in reversed notation.
    /// 2. A period-separated name that is written in camel case.
    ///
    /// - Parameter nsid: The NSID to validate.
    ///
    /// - Throws: An ``ATNSIDError``, indicating the NSID is invalid.
    public func validateViaRegex(_ nsid: String) throws {
        let nsidRegex = try Regex("^[a-zA-Z]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(\\.[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+(\\.[a-zA-Z]([a-zA-Z]{0,61}[a-zA-Z])?)$")

        guard try nsidRegex.wholeMatch(in: nsid) != nil else {
            throw ATNSIDError.failedToValidateViaRegex
        }

        guard nsid.count <= 317 else {
            throw ATNSIDError.tooLong
        }
    }
}
