//
//  Logging.swift
//
//
//  Created by Christopher Jr Riley on 2024-04-04.
//

import Logging

#if canImport(os)
import os

struct ATLogHandler: LogHandler {
    public let subsystem: String
    public let category: String
    public var logLevel: Logging.Logger.Level = .info
    public var metadata: Logging.Logger.Metadata = [:]
    private var appleLogger: os.Logger

    init(subsystem: String, category: String? = nil) {
        self.subsystem = subsystem
        self.category = category ?? "ATProtoKit"
        self.appleLogger = Logger(subsystem: subsystem, category: category ?? "ATProtoKit")
    }

    mutating func log(level: Logging.Logger.Level, message: Logging.Logger.Message, metadata: Logging.Logger.Metadata?, source: String, file: String, function: String, line: UInt) {
        let allMetadata = self.metadata.merging(metadata ?? [:]) { _, new in new }
        var messageMetadata = [String: Any]()
        var privacySettings = [String: OSLogPrivacy]()

//        appleLogger(level: level, message: formattedMessage)
//        appleLogger.log(level: .info, "\(formattedMessage)")
        switch level {
            case .trace:
                appleLogger.trace("\(message, privacy: .auto)")
            case .debug:
                appleLogger.debug("\(message, privacy: .auto)")
            case .info:
                appleLogger.info("\(message, privacy: .auto)")
            case .notice:
                appleLogger.notice("\(message, privacy: .auto)")
            case .warning:
                appleLogger.warning("\(message, privacy: .auto)")
            case .error:
                appleLogger.error("\(message, privacy: .auto)")
            case .critical:
                appleLogger.critical("\(message, privacy: .auto)")
        }
    }

    subscript(metadataKey key: String) -> Logging.Logger.Metadata.Value? {
        get { metadata[key] }
        set { metadata[key] = newValue }
    }
}
#endif
