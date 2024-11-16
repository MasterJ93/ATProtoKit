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
        guard let target = target as? SourceModuleTarget else { return [] }
        // Fetch the latest Git tag (version).
        // Default if no tag or Git unavailable.
        let versionNumber = try fetchLatestGitTag() ?? "0.0.0"

        // Write the version to a Swift file.
        let outputFilePath = context.pluginWorkDirectory.appending("Sources/\(target.name)/Utilities/VersionNumber.swift")

        try generateVersionFile(at: outputFilePath, version: versionNumber)

        return [
            .buildCommand(
                displayName: "Generating Version.swift with version \(versionNumber)",
                executable: Path("/usr/bin/env"),
                arguments: ["touch", "\(outputFilePath)"],
                outputFiles: [outputFilePath]
            )
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
        // VersionNumber.swift
        //
        //
        // Auto-generated: Do not manually change this.
        // (c) 2014 Christopher Jr Riley
        
        import Foundation
        
        /// The version number for ATProtoKit.
        public let versionNumber = "\(version)"
        """

        // Convert the content to Data
        guard let data = content.data(using: .utf8) else {
            throw NSError(domain: "VersionFileError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode content as UTF-8"])
        }

        // Convert Path to URL by initializing with path.string
        let fileURL = URL(fileURLWithPath: path.string)

        // Write the data to the file at the specified path
        try data.write(to: fileURL)
    }
}
