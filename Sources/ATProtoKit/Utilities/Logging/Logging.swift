//
//  Logging.swift
//
//
//  Created by Christopher Jr Riley on 2024-04-04.
//

#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
// If the platform is based on an Apple-product
// then we will use the default-provided Apple logger
// for processing the SDK logs
import os
#endif
import Logging

/// The ATLogHandler is a handler class that dyanmically switches between the
/// cross-platform compatible SwiftLogger framework for multiplatform use and
/// for use on Apple-based OSs.
struct ATLogHandler: LogHandler {
    // Component
    public let subsystem: String
    // Category Metadata Field
    public let category: String
    // INFO will be the default log level
    public var logLevel: Logging.Logger.Level = .info
    // Metadata for the specific log msg, consisting of keys and values
    public var metadata: Logging.Logger.Metadata = [:]
#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
    private var logger: os.Logger
#else
    private var logger: Logging.StreamLogHandler
#endif

    /// Initialization of the ATLogHandler
    /// - Parameters:
    ///    - subSystem: The subsystem component in which the logs are applicable.
    ///    - category: The categorty that the log applies to. Most of the time this can be nil and will default to ATProtoKit.
    init(subsystem: String, category: String? = nil) {
        self.subsystem = subsystem
        self.category = category ?? "ATProtoKit"
#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
        // Using the apple logger built-into the Apple OSs
        self.logger = Logger(subsystem: subsystem, category: category ?? "ATProtoKit")
#else
        // Otherwise, use the cross-platform logging lib
        self.logger = Logging.StreamLogHandler(label: "\(subsystem) \(category ?? "ATProtoKit")")
#endif
    }

    /// The Log function will perform the mapping betweent the StreamLogHandler from the SwiftLogger
    /// library for cross-platform logging and the Apple logger from Apple's OS frameworks for when an Apple
    /// OS is chosen as the target.
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
            // Given the log status, pass in the formatted string that should
            // closely resemble what the StreamLogHandler format so that logs
            // will hopefully resemble each other despite being on different
            // platforms
            case .trace:
                logger.trace("\(logMsgPrefix) \(message, privacy: .auto)")
            case .debug:
                logger.debug("\(logMsgPrefix) \(message, privacy: .auto)")
            case .info:
                logger.info("\(logMsgPrefix) \(message, privacy: .auto)")
            case .notice:
                logger.notice("\(logMsgPrefix) \(message, privacy: .auto)")
            case .warning:
                logger.warning("\(logMsgPrefix) \(message, privacy: .auto)")
            case .error:
                logger.error("\(logMsgPrefix) \(message, privacy: .auto)")
            case .critical:
                logger.critical("\(logMsgPrefix) \(message, privacy: .auto)")
        }
#else
        // if logging on other platforms, pass down the log details to the standard logger
        logger.log(level: level, message: "\(message, privacy: .auto)", metadata: allMetadata, source: source, file: file, function: function, line: line)
#endif
    }

    /// Obtain or set a particular metadata key for the standard metadata for the handler.
    /// - Parameters:
    ///  - key: The metadata key whos value is to be obtained or inserted
    /// - Returns: A `Logging.Logger.Metadata.Value` that contains the configured value for a given metadata key.
    subscript(metadataKey key: String) -> Logging.Logger.Metadata.Value? {
        get { metadata[key] }
        set { metadata[key] = newValue }
    }
}
