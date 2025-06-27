//
//  ProvidingMacros.swift
//
//
//  Created by Christopher Jr Riley on 2024-08-31.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftCompilerPlugin

@main
struct ATMacro: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        ATLexiconModelMacro.self
    ]
}
