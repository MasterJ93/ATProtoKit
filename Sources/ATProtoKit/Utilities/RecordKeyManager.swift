//
//  RecordKeyManager.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-29.
//

import Foundation

/// A class for creating a validating Record Keys.
class RecordKeyManager {
    /// The last timestamp recorded.
    private var lastTimestamp: UInt64 = UInt64(0)
    /// A number used for reducing the risk of collisions.
    private let clockIdentifier: UInt64

    init() {
        // Generate a random 10-bit clock identifier.
        clockIdentifier = UInt64.random(in: 0..<1023)
    }

    /// Creates a `tid` (Timestamp Identifier) Record Key.
    ///
    /// According to the [AT Protocol Specifications][atproto], a `tid` Record Key consists of a 64-bit integer, in the big-endian byte order. : `UInt64` is
    /// encoded in `base32-sortable`, which is a 13 ASCII character that consists of `234567abcdefghijklmnopqrstuvwxyz` with no padding. The
    /// specification also requires that the number never decreases: it must always increase.
    ///
    /// A specific layout for `UInt64` are as follows:
    /// - Bit 0: `0`
    /// - Bits 1–54: The timestamp in microseconds since UNIX epoch.
    /// - Bits 55–64: The "clock identifier."
    ///
    /// The "clock identifier" is a 10-bit random number between `0` and `1024`, which reduces the chance of a collision between two Record Keys. However,
    /// it's important to note that this doesn't _garantee_ that no two Record Keys are alike.
    ///
    /// - Returns: A new `tid` Record Key
    ///
    /// [atproto]: https://atproto.com/specs/record-key#record-key-type-tid
    public func generateTID() -> String {
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
    /// This method will say what kind of Record Key it is. It will only be able to validate `any` and `tid` Record Keys at this time.
    ///
    /// - Parameter recordKey: The Record Key to validate.
    /// - Returns: A `RecordKeyType`, which states whether it's a known type of Record Key.
    public func validateRecordKey(_ recordKey: String) {

    }
}
