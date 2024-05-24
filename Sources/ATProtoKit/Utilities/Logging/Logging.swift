//
//  Logging.swift
//
//
//  Created by Christopher Jr Riley on 2024-04-04.
//

// Choose the logging library based on the
// platform we are working with
#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
// If the platform is based on an Apple-product
// then we will use the default-provided Apple logger
import os
#endif
// This library will be used regardless for the log levels
import Logging

// Define the ATLogHandler
// The log handler will automatically choose
// the correct logging library based on the framework
struct ATLogHandler: LogHandler {
    // Subsystem is the component within the ATProto
    // Library that will be logged
    public let subsystem: String
    // The category is a meta-data field for the log to
    // help provide more context in-line
    public let category: String
    // The default log level, if not provided
    public var logLevel: Logging.Logger.Level = .info
    public var metadata: Logging.Logger.Metadata = [:]
#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
    // if on an apple platform, we will use the default lib
    private var appleLogger: os.Logger
#else
    // Otherwise, use the cross-platform logging lib
    private var appleLogger: Logging.StreamLogHandler
#endif

    // Init the Logger Library
    init(subsystem: String, category: String? = nil) {
        self.subsystem = subsystem
        self.category = category ?? "ATProtoKit"
#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
        // Using the apple logger built-into the Apple OSs
        self.appleLogger = Logger(subsystem: subsystem, category: category ?? "ATProtoKit")
#else
        // Otherwise, use the cross-platform logging lib
        self.appleLogger = Logging.StreamLogHandler(label: "\(subsystem) \(category ?? "ATProtoKit")")
#endif
    }

    // The logger override function that will actually do the mapping
    public func log(level: Logging.Logger.Level,
                    message: Logging.Logger.Message,
                    metadata explicitMetadata: Logging.Logger.Metadata?,
                    source: String,
                    file: String,
                    function: String,
                    line: UInt) {
        
        // Obtain all the metadata between the standard and the incoming
        let allMetadata = self.metadata.merging(explicitMetadata ?? [:]) { (current, new) in
            return new
        }
        
#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
        // Set a log msg prefix made to resemble the alt platform logger
        let logMsgPrefix = "\(allMetadata) [\(source)]"
        // Map the loglevels to match what the apple logger would expect
        switch level {
            case .trace:
                appleLogger.trace("\(logMsgPrefix) \(message, privacy: .auto)")
            case .debug:
                appleLogger.debug("\(logMsgPrefix) \(message, privacy: .auto)")
            case .info:
                appleLogger.info("\(logMsgPrefix) \(message, privacy: .auto)")
            case .notice:
                appleLogger.notice("\(logMsgPrefix) \(message, privacy: .auto)")
            case .warning:
                appleLogger.warning("\(logMsgPrefix) \(message, privacy: .auto)")
            case .error:
                appleLogger.error("\(logMsgPrefix) \(message, privacy: .auto)")
            case .critical:
                appleLogger.critical("\(logMsgPrefix) \(message, privacy: .auto)")
        }
#else
        // if logging on other platforms, pass down the log details to the standard logger
        appleLogger.log(level: level, message: "\(message, privacy: .auto)", metadata: allMetadata, source: source, file: file, function: function, line: line)
#endif
    }

    // Required to extend the protocol
    subscript(metadataKey key: String) -> Logging.Logger.Metadata.Value? {
        get { metadata[key] }
        set { metadata[key] = newValue }
    }
}

//#endif
