//
//  EncodeLocale.swift
//
//
//  Created by Christopher Jr Riley on 2025-01-21.
//

import Foundation

extension KeyedDecodingContainer {

    /// Decodes a non-optional `Locale` object.
    ///
    /// Given that `Locale` doesn't neatly decode from a JSON object, this is used as a replacement
    /// of `decode(_:forKey:)` specifically for `Locale` objects.
    ///
    /// - Parameter key: The key associated with the `Locale` object.
    /// - Returns: A `Locale` object if decoding is successful.
    ///
    /// - Throws: `DecodingError` if the key is missing.
    public func decodeLocale(forKey key: Key) throws -> Locale {
        let localeString = try self.decode(String.self, forKey: key)

        return Locale(identifier: localeString)

    }

    /// Decodes a non-optional `Locale` object.
    ///
    /// Given that `Locale` doesn't neatly decode from a JSON object, this is used as a replacement
    /// of `decodeIfPresent(_:forKey:)` specifically for `Locale?` objects.
    ///
    /// - Parameter key: The key associated with the `Locale` object.
    /// - Returns: A `Locale?` object if decoding is successful.
    ///
    /// - Throws: `DecodingError` if the key is missing.
    public func decodeLocaleIfPresent(forKey key: Key) throws -> Locale? {
        if let localeString = try? self.decodeIfPresent(String.self, forKey: key) {
            return Locale(identifier: localeString)
        }

        return nil
    }

    /// Decodes a non-optional `Locale`.
    ///
    /// Given that `Locale` doesn't neatly decode from a JSON object, this is used as a replacement
    /// of `decode(_:forKey:)` specifically for `[Locale]` objects.
    ///
    /// - Parameter key: The key associated with the `Locale` object.
    /// - Returns: A `[Locale]` object if decoding is successful.
    ///
    /// - Throws: `DecodingError` if the key is missing.
    public func decodeLocaleArray(forKey key: Key) throws -> [Locale] {
        let localeStringArray = try self.decode([String].self, forKey: key)

        return localeStringArray.map { Locale(identifier: $0) }
    }

    /// Decodes a non-optional `Locale` object.
    ///
    /// Given that `Locale` doesn't neatly decode from a JSON object, this is used as a replacement
    /// of `decodeIfPresent(_:forKey:)` specifically for `[Locale]?` objects.
    ///
    /// - Parameter key: The key associated with the `Locale` object.
    /// - Returns: A `[Locale]?` object if decoding is successful.
    ///
    /// - Throws: `DecodingError` if the key is missing.
    public func decodeLocaleArrayIfPresent(forKey key: Key) throws -> [Locale]? {
        if let localeStringArray = try? self.decodeIfPresent([String].self, forKey: key) {

            return localeStringArray.map { Locale(identifier: $0) }
        }

        return nil
    }
}
