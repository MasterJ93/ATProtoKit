//
//  ATLexiconKnownValue.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2026-08-23.
//


/// Defines a string-backed Lexicon value whose schema uses an open set of known values.
public protocol ATLexiconKnownValue: RawRepresentable, Codable, Equatable, ExpressibleByStringLiteral where RawValue == String, StringLiteralType == String {

    /// Creates a Lexicon value from its serialized string representation.
    ///
    /// Unlike the usual `RawRepresentable` initializer, this initializer is
    /// intentionally non-failable because Lexicon `knownValues` are an open set.
    ///
    /// - Parameter rawValue: The `String` value to input.
    init(rawValue: String)
}

extension ATLexiconKnownValue {

    /// Creates the value from a `String` literal.
    ///
    /// - Parameter value: The string value used to initialize the type from a string literal.
    public init(stringLiteral value: String) {
        self.init(rawValue: value)
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()

        let rawValue = try container.decode(String.self)
        self.init(rawValue: rawValue)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()

        try container.encode(rawValue)
    }
}
