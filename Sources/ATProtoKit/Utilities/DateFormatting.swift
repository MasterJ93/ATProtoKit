//
//  DateFormatting.swift
//  
//
//  Created by Christopher Jr Riley on 2024-01-25.
//

import Foundation

struct CustomDateFormatter {
    static let shared = CustomDateFormatter()

    private let dateFormatter: ISO8601DateFormatter

    private init() {
        dateFormatter = ISO8601DateFormatter()
    }

    func string(from date: Date) -> String? {
        return dateFormatter.string(from: date)
    }

    func date(from string: String) -> Date? {
        return dateFormatter.date(from: string)
    }
}

@propertyWrapper
public struct DateFormatting: Codable {
    public var wrappedValue: Date

    public init(wrappedValue: Date) {
        self.wrappedValue = wrappedValue
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let dateString = try container.decode(String.self)
        guard let date = CustomDateFormatter.shared.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Date string does not match format expected by formatter.")
        }
        self.wrappedValue = date
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let dateString = CustomDateFormatter.shared.string(from: wrappedValue)
        try container.encode(dateString)
    }
}

@propertyWrapper
public struct DateFormattingOptional: Codable {
    public var wrappedValue: Date?

    public init(wrappedValue: Date?) {
        self.wrappedValue = wrappedValue
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dateString = try? container.decode(String.self) {
            self.wrappedValue = CustomDateFormatter.shared.date(from: dateString)
        } else {
            self.wrappedValue = nil
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let date = wrappedValue, let dateString = CustomDateFormatter.shared.string(from: date) {
            try container.encode(dateString)
        } else {
            try container.encodeNil()
        }
    }
}
