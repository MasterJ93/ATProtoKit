//
//  LoggingBootstrapping.swift
//
//
//  Created by Christopher Jr Riley on 2024-04-04.
//

import Foundation
import Logging

struct ATLogging {
    public func bootstrap() {
        func bootstrapWithOSLog(subsystem: String) {
            LoggingSystem.bootstrap { label in
                #if canImport(os)
                OSLogHandler(subsystem: subsystem, category: label)
                #else
                StreamLogHandler.standardOutput(label: label)
                #endif
            }
        }
    }
    public func handleBehavior(_ behavior: HandleBehavior = .default) {

    }

    public enum HandleBehavior {
        case `default`
        case osLog
        case swiftLog
    }
}
