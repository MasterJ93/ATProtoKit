//
//  CustomError.swift
//
//
//  Created by Christopher Jr Riley on 2024-09-12.
//

import Foundation
import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

enum CustomError: Error, CustomStringConvertible {
    case message(String)

    var description: String {
        switch self {
            case .message(let text):
                return text
        }
    }
}

struct SimpleDiagnosticMessage: DiagnosticMessage, Error {
    let message: String
    let diagnosticID: MessageID
    let severity: DiagnosticSeverity
}

extension SimpleDiagnosticMessage: FixItMessage {
    var fixItID: MessageID { diagnosticID }
}
