//
//  Logging.swift
//
//
//  Created by Christopher Jr Riley on 2024-04-04.
//

#if canImport(os)
import Foundation
import Logging
import os

public struct OSLogHandler: LogHandler {
    public var logLevel: Logging.Logger.Level = .info
    public var metadata: Logging.Logger.Metadata = [:]
    private let osLogger: os.Logger

    init(label: String) {
        osLogger = os.Logger(subsystem: Bundle.main.bundleIdentifier ?? "default", category: label)
    }

    public func log(level: Logging.Logger.Level, message: Logging.Logger.Message, metadata: Logging.Logger.Metadata?,
                    source: String, file: String, function: String, line: UInt) {
        let combinedMetadata = self.metadata.merging(metadata ?? [:]) { (_, new) in new }
        let metaString = combinedMetadata.map { "\($0)=\($1)" }.joined(separator: " ")

        let finalMessage = "\(message) \(metaString)"

        switch level {
            case .trace, .debug:
                osLogger.debug("\(finalMessage, privacy: .public)")
            case .info, .notice:
                osLogger.info("\(finalMessage, privacy: .public)")
            case .warning:
                osLogger.warning("\(finalMessage, privacy: .public)")
            case .error:
                osLogger.error("\(finalMessage, privacy: .public)")
            case .critical:
                osLogger.log(level: .fault, "\(finalMessage, privacy: .public)")
        }
    }

    public subscript(metadataKey key: String) -> Logging.Logger.Metadata.Value? {
        get {
            metadata[key]
        }
        set(newValue) {
            metadata[key] = newValue
        }
    }
}
#endif
