//
//  Logger+.swift
//  
//  
//  Created by Keisuke Chinone on 2024/03/29.
//


import OSLog

extension Logger {
    /// Logger to record errors in the package
    ///
    /// This variable provides a way to display errors, debugging information, etc. on the console.
    /// Unlike the print function, you can click on the contents of the console to display the corresponding code. (Xcode 15 required)
    ///
    /// ```swift
    /// Logger.package.info("Information you want to display in the console") // Used to display information
    /// Logger.package.error("Errors you want to display in the console") // Used to display errors
    /// ```
    static let package = Logger(subsystem: "ATProtoKit-ATProtoKit-resources", category: "package")
}
