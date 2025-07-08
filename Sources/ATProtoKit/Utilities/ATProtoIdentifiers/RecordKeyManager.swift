//
//  RecordKeyManager.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-29.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// A class for creating a validating Record Keys.
public struct RecordKeyManager {

    /// The last timestamp recorded.
    public var lastTimestamp: UInt64 = UInt64(0)

    /// A number used for reducing the risk of collisions.
    private let clockIdentifier: UInt64

    /// A list of the valid characters in base32.
    private let base32Alphabet = "234567abcdefghijklmnopqrstuvwxyz"

    init() {
        // Generate a random 10-bit clock identifier.
        clockIdentifier = UInt64.random(in: 0..<1023)
    }

    /// Creates a `tid` (Timestamp Identifier) Record Key.
    ///
    /// According to the [AT Protocol Specifications][atproto], a `tid` Record Key consists of
    /// a 64-bit integer, in the big-endian byte order. : `UInt64` is encoded in `base32-sortable`,
    /// which is a 13 ASCII character that consists of `234567abcdefghijklmnopqrstuvwxyz` with no
    /// padding. The specification also requires that the number never decreases: it must
    /// always increase.
    ///
    /// A specific layout for `UInt64` are as follows:
    /// - Bit 0: `0`
    /// - Bits 1–54: The timestamp in microseconds since UNIX epoch.
    /// - Bits 55–64: The "clock identifier."
    ///
    /// The "clock identifier" is a 10-bit random number between `0` and `1024`, which reduces the
    /// chance of a collision between two Record Keys. However, it's important to note that this
    /// doesn't _guarantee_ that no two Record Keys are alike.
    ///
    /// - Returns: A new `tid` Record Key
    ///
    /// [atproto]: https://atproto.com/specs/record-key#record-key-type-tid
    public mutating func generateTID() -> String {
        let microsecondsSinceUNIXEpoch = UInt64(Date().timeIntervalSince1970 * 1_000_000)
        var timestampPart: UInt64

        // Ensure the timestamp is monotonically increasing
        if microsecondsSinceUNIXEpoch > lastTimestamp {
            timestampPart = microsecondsSinceUNIXEpoch
            lastTimestamp = microsecondsSinceUNIXEpoch
        } else {
            timestampPart = lastTimestamp + 1
            lastTimestamp += 1
        }

        // Combine the timestamp and clock identifier
        // Note: The timestamp is shifted left by 10 bits to make room for the clock identifier
        let combined = (timestampPart << 10) | clockIdentifier

        // Convert to base32-sortable
        let timestampIdentifierRecordKey = combined.toBase32Sortable()

        return timestampIdentifierRecordKey
    }

    /// Validates a Record Key.
    ///
    /// This method will say what kind of Record Key it is. It will only be able to validate
    /// `any` and `tid` Record Keys at this time.
    ///
    /// - Parameter recordKey: The Record Key to validate.
    /// - Returns: A `RecordKeyType`, which states whether it's a known type of Record Key.
    public func validate(_ recordKey: String) -> RecordKeyType {
        if isValidTID(recordKey: recordKey) {
            return .tid
        }

        let anyRegexPattern = "^(?!^\\.{1,2}$)[A-Za-z0-9._:~-]{1,512}$"

        if recordKey.range(of: anyRegexPattern, options: .regularExpression) != nil {
            return .any
        }

        return .unknown
    }

    /// Defines the type of Record Key being used.
    public enum RecordKeyType {

        /// Indicates the Record Key type as `tid`.
        case tid

        /// Indicates the Record Key type as `any`.
        case any

        /// The Record Key type is not known at this time.
        case unknown

        /// This is not a Record Key.
        ///
        /// You can perform some sort of error handling is this is selected.
        case notARecordKey
    }

    /// Checks if the Record Key type is a `tid`.
    ///
    /// - Parameter recordKey: The Record Key itself.
    /// - Returns: `true` if it is a `tid` Record Key; `false` if it isn't.
    private func isValidTID(recordKey: String) -> Bool {
        // Validate specific TID requirements
        guard recordKey.count == 13,
              let tidInt = decodeBase32To64BitInt(recordKey) else {
            return false
        }

        // Check top bit is always 0
        let topBitMask: UInt64 = 1 << 63
        if tidInt & topBitMask != 0 {
            return false
        }

        // TODO: Potentially add checks for the clock identifier and timestamp, if needed.

        return true
    }

    /// Decodes a base32 string to a 64-bit integer
    ///
    /// - Parameter base32String: The string written in base32.
    /// - Returns: An integer of type `UInt64`.
    private func decodeBase32To64BitInt(_ base32String: String) -> UInt64? {
        var result: UInt64 = 0
        for char in base32String {
            guard let charIndex = base32Alphabet.firstIndex(of: char) else {
                return nil
            }
            result = result << 5
            result |= UInt64(base32Alphabet.distance(from: base32Alphabet.startIndex, to: charIndex))
        }
        return result
    }
}
