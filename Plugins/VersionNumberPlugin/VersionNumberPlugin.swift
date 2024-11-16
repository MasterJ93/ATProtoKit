//
//  VersionNumberPlugin.swift
//
//
//  Created by Christopher Jr Riley on 2024-11-11.
//

import Foundation
import PackagePlugin

@main
struct VersionNumberPlugin: BuildToolPlugin {

    func createBuildCommands(context: PluginContext, target: Target) throws -> [Command] {

        // Fetch the latest Git tag (version).
        // Default if no tag or Git unavailable.
        let versionNumber = try fetchLatestGitTag() ?? "0.0.0"

        let output = context.pluginWorkDirectory.appending("VersionNumber.swift")
        return [
            .buildCommand(displayName: "Generating VersionNumber.swift with version \(versionNumber)",
                          executable: try context.tool(named: "VersionNumberPluginExec").path,
                          arguments: [output],
                          environment: [:],
                          inputFiles: [],
                          outputFiles: [output])
        ]
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
}

public enum BuildToolError: Error {
    case cannotFindTarget
}
