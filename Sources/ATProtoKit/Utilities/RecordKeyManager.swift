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
    private var lastTimestamp = UInt64(0)
    /// A number used for reducing the risk of collisions.
    private let clockIdentifier: UInt64

    init() {
        // Generate a random 10-bit clock identifier.
        clockIdentifier = UInt64.random(in: 0..<1024)
    }

    /// Creates a `tid` (Timestamp Identifier) Record Key.
    ///
    /// According to the [AT Protocol Specifications][atproto], a `tid` Record Key consists of a 64-bit integer, in the big-endian byte order. : `UInt64` is
    /// encoded in `base32-sortable`, which is a 13 ASCII character that consists of `234567abcdefghijklmnopqrstuvwxyz` with no padding.
    ///
    /// A specific layout for `UInt64` are as follows:
    /// - Bit 0: `0`
    /// - Bits 1–54: The timestamp in microseconds since UNIX epoch.
    /// - Bits 55–64: The "clock identifier."
    ///
    /// The "clock identifier" is a 10-bit random number between `0` and `1024`, which reduces the chance of a collision between two Record Keys. However,
    /// it's important to note that this doesn't _garantee_ that no two Record Keys are alike.
    ///
    /// This method produces a `tid` (timestamp identifier) as specified by the AT Protocol.
    /// The `tid` combines a high-precision timestamp with a randomly generated "clock identifier"
    /// to minimize the risk of collisions. The timestamp portion is derived from the current time
    /// in microseconds since the UNIX epoch, ensuring that `tid` values are generally increasing
    /// and sortable. The clock identifier is a 10-bit random value unique to each instance of
    /// `RecordKeyManager`, which helps distinguish `tid` values generated in the same microsecond.
    ///
    /// - Returns: A new Record Key
    ///
    /// [atproto]: https://atproto.com/specs/record-key#record-key-type-tid
    public func generateTID() {

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
