//
//  LoggingBootstrapping.swift
//
//
//  Created by Christopher Jr Riley on 2024-04-04.
//

import Foundation
import Logging

/// The ATLogging Struct houses the basis for booststrapping the logging handler that
/// will be used by the rest of the ATProtoKit. This is an optional component, and can be
/// replaced wiith a seperate Log Handler if there is one already globally created for a
/// project that ustilizes the ATProto framework.
struct ATLogging {
    /// Bootstrap the Logging framework, using the built-in implementation
    /// that ATProtoKit provides. The Logger Handler provided by this framework
    /// will dynamically choose between the Apple OS and cross-platform logging
    /// implemnentations based on the target OS.
    public func bootstrap() {
        // Bootstrap the ATProtoKit logger for the libary
        // for a consistent logging format and auto switch
        // between the cross-platform and the Apple OS based
        // on target.
        LoggingSystem.bootstrap {
            label in ATLogHandler(subsystem: "\(defaultIdentifier()).\(label)")
        }
    }
    
    // Return the bundle for the prefix of the label for the logger
    // this prefix will show up in the logs for finding the source of
    // the logs
    private func defaultIdentifier() -> String {
        return Bundle.main.bundleIdentifier ?? "com.cjrriley.ATProtoKit"
    }
}
