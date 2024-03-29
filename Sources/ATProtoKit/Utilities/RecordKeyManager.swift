//
//  RecordKeyManager.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-29.
//

import Foundation

/// A class for creating a validating Record Keys.
class RecordKeyManager {
    private var lastTimestamp = UInt64(0)
    private let clockIdentifier: UInt64

    init() {
        // Generate a random 10-bit clock identifier.
        clockIdentifier = UInt64.random(in: 0..<1024)
    }

    /// Creates a `tid` Record Key.
    ///
    /// According to the [AT Protocol Specifications][atproto]
    ///
    /// - Returns:
    ///
    /// [atproto]: 
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
