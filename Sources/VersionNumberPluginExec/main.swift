//
//  main.swift
//
//
//  Created by Christopher Jr Riley on 2024-11-11.
//

import Foundation

let arguments = ProcessInfo().arguments

if arguments.count < 2 {
    print("missing arguments")
}

let outputURL = URL(filePath: CommandLine.arguments[1])

var generatedCode = """
    //
    // VersionNumber.swift
    //
    //
    // Auto-generated: Do not manually change this.
    // (c) 2014 Christopher Jr Riley
    //
    
    import Foundation
    
    /// The version number for ATProtoKit.
    """

let test = "Testing"

let process = Process()
process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
process.arguments = ["git", "describe", "--tags", "--abbrev=0"]

let outputPipe = Pipe()
process.standardOutput = outputPipe
process.standardError = outputPipe

try process.run()
process.waitUntilExit()

let data = outputPipe.fileHandleForReading.readDataToEndOfFile()

let gitTagOutput = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)

generatedCode.append("\npublic let versionNumber = \"\(gitTagOutput ?? "0.0.0")\"\n")
guard let generatedCode = generatedCode.data(using: .utf8) else {
    throw CodeGeneratorError.invalidData
}


try generatedCode.write(to: outputURL, options: .atomic)


@available(macOS 13.00.0, *)
enum CodeGeneratorError: Error {
    case invalidArguments
    case invalidData
}
