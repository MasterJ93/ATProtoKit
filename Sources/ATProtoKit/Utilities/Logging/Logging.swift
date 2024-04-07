//
//  Logging.swift
//
//
//  Created by Christopher Jr Riley on 2024-04-04.
//

import Logging

#if canImport(os)
import os

struct OSLogHandler: LogHandler {
    public let subsystem: String
    public let category: String
    public var logLevel: Logging.Logger.Level = .info
    public var metadata: Logging.Logger.Metadata = [:]
    private let appleLogger: Logging.Logger

    init(subsystem: String, category: String) {
        self.subsystem = subsystem
        self.category = category
    }

    public func log(level: Logging.Logger.Level, message: Logging.Logger.Message, metadata: Logging.Logger.Metadata?, source: String, file: String,
                    function: String, line: UInt) {
        let combinedMetadata = (metadata ?? [:]).merging(self.metadata) { _, new in new }
        let metaString = combinedMetadata.map { "\($0)=\($1)" }.joined(separator: ", ")
        let logMessage = "\(message) \(metaString)"

        let appleLogger = Logger(subsystem: subsystem, category: category)

        switch level {
            case .trace:
                appleLogger.trace("%{public}@")
            case .debug:
                appleLogger.debug("%{public}@")
            case .info:
                appleLogger.info("%{public}@")
            case .notice:
                appleLogger.notice("%{public}@")
            case .warning:
                appleLogger.warning("%{public}@")
            case .error:
                appleLogger.error("%{public}@")
            case .critical:
                appleLogger.critical("%{public}@")
        }
    }

    subscript(metadataKey key: String) -> Logging.Logger.Metadata.Value? {
        get { metadata[key] }
        set { metadata[key] = newValue }
    }
}
#endif

