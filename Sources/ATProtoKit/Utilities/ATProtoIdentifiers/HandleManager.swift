//
//  HandleManager.swift
//
//
//  Created by Christopher Jr Riley on 2024-06-07.
//

import Foundation

/// Identifies and validates handles.
public struct HandleManager {

    /// A placeholder for an invalid handle.
    public let invalidHandle: String = "handle.invalid"
    
    /// Normalizes the handle to be all lowercased letters.
    ///
    /// - Parameter handle: The handle to normalize.
    /// - Returns: A handle with all letters set to lowercased.
    public func normalize(_ handle: String) -> String {
        return handle.lowercased()
    }

    /// Normalizes and validates the handle.
    ///
    /// This method combines the efforts of ``normalize(_:)`` and
    /// ``validate(_:)`` into one convenient method.
    ///
    /// - Parameter handle: The handle to normalize and validate.
    /// - Returns: A validated handle with all letters set to lowercased.
    ///
    /// - Throws: An ``ATHandleError``, indicating the handle is invalid.
    public func normalizeAndValidate(_ handle: String) throws -> String {
        let normalized = normalize(handle)

        do {
            try validate(normalized)
        } catch {
            throw error
        }

        return normalized
    }

    /// Indicates whether the handle is valid.
    ///
    /// - Parameter handle: The handle to validate.
    /// - Returns: `true` if the handle is valid, or `false` if not.
    public func isValid(_ handle: String) -> Bool {
        do {
            _ = try validate(handle)
            return true
        } catch {
            return false
        }
    }

    /// Indicates whether the TLD segment of the handle is valid.
    ///
    /// - Parameter handle: The handle that contains the TLD to validate.
    /// - Returns: `true` if the handle is valid, or `false` if not.
    public func isValidTLD(handle: String) -> Bool {
        guard let tld = handle.split(separator: ".").last else {
            return false
        }

        return disallowedTLDs(rawValue: String(tld)) == nil
    }

    /// Ensures the handle is valid.
    ///
    /// - Parameter handle: The handle to validate.
    ///
    /// - Throws: An ``ATHandleError``, indicating the handle is invalid.
    public func validate(_ handle: String) throws {
        let asciiCheck = #"^[a-zA-Z0-9.-]*$"#

        guard ATProtoTools.match(asciiCheck, in: String(handle)) != nil else {
            throw ATURIError.disallowedASCIICharacters
        }

        guard handle.count <= 253 else {
            throw ATHandleError.tooLong
        }

        let segments = handle.split(separator: ".")

        guard segments.count >= 2 else {
            throw ATHandleError.notEnoughSegments
        }

        try segments.enumerated().forEach { index, segment in
            guard segment.count > 0 else {
                throw ATHandleError.emptySegment
            }

            guard segment.count <= 63 else {
                throw ATHandleError.segmentTooLong
            }

            guard !segment.hasPrefix("-"),
                  !segment.hasSuffix("-") else {
                throw ATHandleError.hyphenFoundAtSegmentEnds
            }
        }

        guard handle.last?.isLetter != nil else {
            throw ATHandleError.nonLatinLetterFoundInTLDSegment
        }
    }

    /// A collection of TLDs that are not permitted in the AT Protocol.
    public enum disallowedTLDs: String {

        /// Indicates the `.local` TLD is not permitted.
        case local = ".local"

        /// Indicates the `.arpa` TLD is not permitted.
        case arpa = ".arpa"

        /// Indicates the `.invalid` TLD is not permitted.
        case invalid = ".invalid"

        /// Indicates the `.localhost` TLD is not permitted.
        case localhost = ".localhost"

        /// Indicates the `.internal` TLD is not permitted.
        case `internal` = ".internal"

        /// Indicates the `.example` TLD is not permitted.
        case example = ".example"

        /// Indicates the `.alt` TLD is not permitted.
        case alt = ".alt"

        /// Indicates the `.onion` TLD is not permitted.
        case onion = ".onion"

#if !DEBUG
        /// Indicates the `.test` TLD is not permitted.
        ///
        /// - Note: This TLD can be used for debugging purposes.
        case test = ".test"
#endif
    }
}
