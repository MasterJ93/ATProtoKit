//
//  CodingUserInfoKey+DecodingDepth.swift
//

import Foundation

public extension CodingUserInfoKey {
    /// A key used to access the recursion depth tracker in `userInfo` during decoding.
    static let decodingDepthState = CodingUserInfoKey(rawValue: "com.atprotokit.decodingDepthState")!
}

/// A class to manage the recursion depth during decoding.
public final class DecodingDepthState: @unchecked Sendable {
    private let lock = NSLock() 
    private var _internalCurrentDepth: Int = 0 

    /// The current recursion depth.
    public var currentDepth: Int {
        get {
            lock.lock()
            defer { lock.unlock() }
            return _internalCurrentDepth
        }
        set {
            lock.lock()
            _internalCurrentDepth = newValue
            lock.unlock()
        }
    }
    /// The maximum allowed recursion depth.
    public let maxDepth: Int 

    /// Initializes a new decoding state.
    /// - Parameter maxDepth: The maximum depth to allow before stopping recursion. Defaults to 25.
    public init(maxDepth: Int = 25) {
        self.maxDepth = maxDepth
        // _internalCurrentDepth is initialized to 0.
    }
}
