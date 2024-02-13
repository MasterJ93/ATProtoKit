//
//  ExtensionHelpers.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-12.
//

import Foundation

// MARK: - String Extension
extension String: Truncatable {
    func truncated(toLength length: Int) -> String {
        return String(self.prefix(length))
    }
}

// MARK: - Array Extension
extension Array: Truncatable {
    func truncated(toLength length: Int) -> Array<Element> {
        return Array(self.prefix(length))
    }
}

// MARK: Encodable Extension
extension Encodable {
    func toJsonData() throws -> Data? {
        return try JSONEncoder().encode(self)
    }
}
