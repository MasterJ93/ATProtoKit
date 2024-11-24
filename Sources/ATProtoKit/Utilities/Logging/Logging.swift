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

    public func log(level: Logging.Logger.Level,
                    message: Logging.Logger.Message,
                    metadata explicitMetadata: Logging.Logger.Metadata?,
                    source: String,
                    file: String,
                    function: String,
                    line: UInt) {
//        let allMetadata = self.metadata.merging(metadata ?? [:]) { _, new in new }
//        var messageMetadata = [String: Any]()
//        var privacySettings = [String: OSLogPrivacy]()

        switch level {
            case .trace, .debug:
                appleLogger.log(level: .debug, "\(message, privacy: .auto)")
            case .info:
                appleLogger.log(level: .info, "\(message, privacy: .auto)")
            case .notice:
                appleLogger.log(level: .default, "\(message, privacy: .auto)")
            case .warning:
                appleLogger.log(level: .error, "\(message, privacy: .auto)")
            case .error:
                appleLogger.log(level: .error, "\(message, privacy: .auto)")
            case .critical:
                appleLogger.log(level: .fault, "\(message, privacy: .auto)")
        }
    }

    subscript(metadataKey key: String) -> Logging.Logger.Metadata.Value? {
        get { metadata[key] }
        set { metadata[key] = newValue }
    }
}
#endif

/// An actor handles logger configuration.
package actor LogBootstrapConfiguration {

    /// Displays the number of times `LoggingSystem.bootstrap` has run.
    ///
    /// Given the limited number of times `LoggingSystem.bootstrap` can be run, `counter`
    private var counter: Int = 0

    private var logger: Logging.Logger = {
        var sharedLogger = Logger(label: "com.cjrriley.ATProtoKit")
        sharedLogger.logLevel = .info // Set a default log level, if needed
        return sharedLogger
    }()

    /// Provides the current logger.
    func getLogger() -> Logging.Logger {
        return logger
    }

    /// Updates the logger.
    func setLogger(_ newLogger: Logging.Logger) {
        logger = newLogger
    }

    /// Gets the current counter value.
    func getCounter() -> Int {
        return counter
    }

    /// Increments the `counter` by 1.
    ///
    /// This should _only_ be run once. If the method detects `counter` is not `0`, it will
    /// not increment further.
    func incrementCounter() {
        if getCounter() < 1 {
            counter += 1
        }
    }

    /// Sets up the logging system and returns a configured logger.
    ///
    /// - Parameters:
    ///   - logCategory: The category of the logger. Optional.
    ///   - logLevel: The level of the logger. Optional.
    ///   - logIdentifier: The identifier for the logger. Optional.
    func setupLog(logCategory: String?, logLevel: Logging.Logger.Level?, logIdentifier: String?) {
        #if canImport(os)

        // Ensure LoggingSystem.bootstrap is called only once
        if counter == 0 {
            LoggingSystem.bootstrap { label in
                ATLogHandler(subsystem: label, category: logCategory ?? "ATProtoKit")
            }
            incrementCounter()
        }

        #else
        LoggingSystem.bootstrap(StreamLogHandler.standardOutput)
        #endif

        var newLogger = Logger(label: logIdentifier ?? "com.cjrriley.ATProtoKit")
        newLogger.logLevel = logLevel ?? .info
        setLogger(newLogger) // Update the internal logger reference
    }
}

