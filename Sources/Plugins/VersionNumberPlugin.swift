//
//  VersionNumberPlugin.swift
//
//
//  Created by Christopher Jr Riley on 2024-11-11.
//

import Foundation
import PackagePlugin

@main
/// Exposes the version number for the rest of the project.
struct VersionNumberPlugin: BuildToolPlugin {

    func createBuildCommands(context: PluginContext, target: Target) throws -> [Command] {
        // Fetch the latest Git tag (version).
        // Default if no tag or Git unavailable.
        let version = try fetchLatestGitTag() ?? "0.0.0"


    }

    /// Fetches the latest `git` tag as a `String`.
    private func fetchLatestGitTag() throws -> String? {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.arguments = ["git", "describe", "--tags", "--abbrev=0"]

        let outputPipe = Pipe()
        process.standardOutput = outputPipe
        process.standardError = outputPipe

        try process.run()
        process.waitUntilExit()

        let data = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)

        return output
    }

    /// Generates the Swift file that contains the version as a constant.
    /// 
    /// - Parameters:
    ///   - path: The path to insert the version file to.
    ///   - version: The actual version number.
    ///
    ///   - Throws: The file failed to be generated.
    private func generateVersionFile(at path: Path, version: String) throws {
        let content = """
        //
        // Generated Version.swift
        //
        //
        // Auto-generated: Do not manually change this.
        // (c) 2014 Christopher Jr Riley
        
        import Foundation
        
        public let packageVersion = "\(version)"
        """

        try content.write(to: path.url, atomically: true, encoding: .utf8)
    }
}
