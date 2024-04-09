//
//  Logging.swift
//
//
//  Created by Christopher Jr Riley on 2024-04-04.
//

import Logging

//#if canImport(os)
//import os
//
//struct OSLogHandler: LogHandler {
//    public let subsystem: String
//    public let category: String
//    public var logLevel: Logging.Logger.Level = .info
//    public var metadata: Logging.Logger.Metadata = [:]
//
//    init(subsystem: String, category: String) {
//        self.subsystem = subsystem
//        self.category = category
//    }
//
//    mutating func log(level: Logging.Logger.Level, message: Logging.Logger.Message, metadata: Logging.Logger.Metadata?, source: String, file: String, function: String, line: UInt) {
//        let allMetadata = self.metadata.merging(metadata ?? [:]) { _, new in new }
//        var messageMetadata = [String: Any]()
//        var privacySettings = [String: OSLogPrivacy]()
//
//        let appleLogger = os.Logger(subsystem: subsystem, category: category)
////        appleLogger(level: level, message: formattedMessage)
////        appleLogger.log(level: .info, "\(formattedMessage)")
//        switch level {
//            case .trace:
//                appleLogger.trace("\(message, privacy: .public)")
//            case .debug:
//                appleLogger.debug("")
//            case .info:
//                appleLogger.info("%{public}@")
//            case .notice:
//                appleLogger.notice("%{public}@")
//            case .warning:
//                appleLogger.warning("%{public}@")
//            case .error:
//                appleLogger.error("%{public}@")
//            case .critical:
//                appleLogger.critical("%{public}@")
//        }
//    }
//
//    subscript(metadataKey key: String) -> Logging.Logger.Metadata.Value? {
//        get { metadata[key] }
//        set { metadata[key] = newValue }
//    }
//}
//#endif
