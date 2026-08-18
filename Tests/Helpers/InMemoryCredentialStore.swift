//
//  InMemoryCredentialStore.swift
//  ATProtoKitTests
//
//  Created by Christopher Jr Riley on 2026-08-17.
//

import Foundation
@testable import ATProtoKit

internal actor InMemoryCredentialStore: ATCredentialStore {

    private var values: [String: Data] = [:]

    internal func loadValue(forKey key: String) async throws -> Data? {
        return values[key]
    }

    internal func saveValue(_ value: Data, forKey key: String) async throws {
        values[key] = value
    }

    internal func deleteValue(forKey key: String) async throws {
        values[key] = nil
    }
}
