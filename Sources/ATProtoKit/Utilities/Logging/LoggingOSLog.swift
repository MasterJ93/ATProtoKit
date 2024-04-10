//
//  LoggingOSLog.swift
//
//
//  Created by Christopher Jr Riley on 2024-04-10.
//

#if canImport(os)
import Foundation
import Logging
import os

public struct LoggingOSLog: LogHandler {
    public var logLevel: Logging.Logger.Level = .info
    public let label: String
    private let oslogger: os.Logger

    public init(label: String) {
        self.label = label
        self.oslogger = os.Logger(subsystem: label, category: "")
    }

    public init(label: String, log: os.Logger) {
        self.label = label
        self.oslogger = log
    }

    //    @available(macOS 11.0, *)
    mutating func log(level: Logging.Logger.Level, message: Logging.Logger.Message, metadata: Logging.Logger.Metadata?, source: String, file: String,
                      function: String, line: UInt) {
        var combinedPrettyMetadata = self.prettyMetadata
        if let metadataOverride = metadata, !metadataOverride.isEmpty {
            combinedPrettyMetadata = self.prettify(
                self.metadata.merging(metadataOverride) {
                    return $1
                }
            )
        }

        var formedMessage = message.description
        if let combinedPrettyMetadata = combinedPrettyMetadata {
            formedMessage += " -- " + combinedPrettyMetadata
        }
        self.oslogger.log(level: OSLogType.from(loggerLevel: level), "\(formedMessage)")
    }

    private var prettyMetadata: String?
    public var metadata = Logger.Metadata() {
        didSet {
            self.prettyMetadata = self.prettify(self.metadata)
        }
    }

    /// Add, remove, or change the logging metadata.
    /// - parameters:
    ///    - metadataKey: the key for the metadata item.
    public subscript(metadataKey metadataKey: String) -> Logging.Logger.Metadata.Value? {
        get {
            return self.metadata[metadataKey]
        }
        set {
            self.metadata[metadataKey] = newValue
        }
    }

    private func prettify(_ metadata: Logging.Logger.Metadata) -> String? {
        if metadata.isEmpty {
            return nil
        }
        return metadata.map {
            "\($0)=\($1)"
        }.joined(separator: " ")
    }
}

extension OSLogType {
    static func from(loggerLevel: Logging.Logger.Level) -> Self {
        switch loggerLevel {
            case .trace:
                /// `OSLog` doesn't have `trace`, so use `debug`
                return .debug
            case .debug:
                return .debug
            case .info:
                return .info
            case .notice:
                // https://developer.apple.com/documentation/os/logging/generating_log_messages_from_your_code
                // According to the documentation, `default` is `notice`.
                return .default
            case .warning:
                /// `OSLog` doesn't have `warning`, so use `info`
                return .info
            case .error:
                return .error
            case .critical:
                return .fault
        }
    }
}
#endif
